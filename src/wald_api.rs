//! Waldlust(DSK-03): 로그인·주소록이 쓰는 API 서버(어드민 `/rd` — 업스트림 RustDesk API 계약)를 빌드 때 고정한다.
//!
//! 빌드 환경변수 `WALDLUST_API_SERVER`(운영 값은 명세 Q-35, 로컬 목업
//! `http://127.0.0.1:8787/rd`)가 있으면 `api-server` 를 OVERWRITE 로 넣는다. OVERWRITE 값은 사용자 설정과
//! heartbeat `strategy` 로 바뀌지 않는다(`Config::get_option`·`set_option`). 값이 없거나 형식이 틀리면 계정
//! 기능을 끈다(HARD `disable-account` — 로그인·주소록·그룹 탭이 사라진다). 포크는 `api-server` 가 비면
//! `https://admin.rustdesk.com` 으로 떨어져 운영자 계정·주소록 요청이 RustDesk 공식 서버로 가기 때문이다
//! (명세 F-39, P0-02 3번).

use hbb_common::config::{self, keys};

const API_SERVER: Option<&str> = option_env!("WALDLUST_API_SERVER");

/// 프로세스마다 한 번 적용한다(`global_init`).
pub fn apply() {
    static ONCE: std::sync::Once = std::sync::Once::new();
    ONCE.call_once(|| apply_preset(API_SERVER.unwrap_or_default()));
}

fn apply_preset(api: &str) {
    let api = api.trim().trim_end_matches('/');
    if !is_valid(api) {
        config::HARD_SETTINGS
            .write()
            .unwrap()
            .insert("disable-account".to_owned(), "Y".to_owned());
        return;
    }
    config::OVERWRITE_SETTINGS
        .write()
        .unwrap()
        .insert(keys::OPTION_API_SERVER.to_owned(), api.to_owned());
    let mut local = config::OVERWRITE_LOCAL_SETTINGS.write().unwrap();
    // 브랜드는 주소록(브랜드 = 공유 주소록)으로 보이므로 그룹(접근 가능한 기기) 탭과 그 요청은 쓰지 않는다(DSK-04).
    local.insert(keys::OPTION_DISABLE_GROUP_PANEL.to_owned(), "Y".to_owned());
    // 최근 세션 정보를 주소록으로 올리지 않는다. 기기 정보의 정본은 어드민이다.
    local.insert(
        keys::OPTION_SYNC_AB_WITH_RECENT_SESSIONS.to_owned(),
        "N".to_owned(),
    );
}

fn is_valid(api: &str) -> bool {
    match url::Url::parse(api) {
        Ok(u) => {
            matches!(u.scheme(), "http" | "https")
                && u.host_str().is_some()
                && u.query().is_none()
                && u.fragment().is_none()
        }
        Err(_) => false,
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use hbb_common::config::{Config, LocalConfig};

    #[test]
    fn test_is_valid() {
        assert!(is_valid("https://api.example.com/rd"));
        assert!(is_valid("http://127.0.0.1:8787/rd"));
        assert!(!is_valid(""));
        assert!(!is_valid("api.example.com/rd"));
        assert!(!is_valid("ftp://api.example.com/rd"));
        assert!(!is_valid("https://api.example.com/rd?x=1"));
    }

    // 설정 맵에만 넣고 읽는다(설정 파일에는 쓰지 않는다).
    #[test]
    fn test_apply_preset_sets_api_server() {
        apply_preset(" http://127.0.0.1:8787/rd/ ");
        assert_eq!(
            Config::get_option(keys::OPTION_API_SERVER),
            "http://127.0.0.1:8787/rd"
        );
        assert_eq!(
            crate::common::get_api_server(
                Config::get_option(keys::OPTION_API_SERVER),
                Config::get_option("custom-rendezvous-server"),
            ),
            "http://127.0.0.1:8787/rd"
        );
        assert_eq!(
            LocalConfig::get_option(keys::OPTION_DISABLE_GROUP_PANEL),
            "Y"
        );
    }

    #[test]
    fn test_apply_preset_without_value_disables_account() {
        apply_preset("");
        assert!(config::is_disable_account());
    }
}
