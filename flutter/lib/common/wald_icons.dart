// Waldlust(DSK-07): 아이콘 세트를 Lucide(lucide_icons_flutter, MIT)로 통일한다.
//
// - 기본 굵기 글꼴('Lucide') 하나만 쓴다. 다른 굵기 변형(LucideIcons.x100 … x600)은 섞지 않는다.
// - 모든 IconData 는 const 다(릴리스 빌드의 아이콘 글꼴 트리 셰이킹이 그대로 동작한다).
// - 크기: 버튼·메뉴 16, 툴바·파일 목록 18, 탭·연결 관리 창 머리 20(WaldSize).
// - IconFont(common.dart)의 상수도 Lucide 를 가리키므로, IconFont 를 쓰는 곳은 호출부를 고치지
//   않아도 Lucide 로 그려진다.
// - 아이콘 세트는 kWaldLucideIcons 한 곳에서 고른다. 호출부는 waldIcon(Icons.x) 처럼 Material 이름을
//   그대로 두고, Lucide 대응은 아래 표(kWaldLucideFor) 한 곳에 모은다(Material 과 비교하기 쉽게).
// - 플랫폼 로고·로그인 제공자 로고·키보드 배열 그림·연결 보안 배지·화면 번호 SVG 는 유지한다.
import 'package:flutter/material.dart';
import 'package:flutter_hbb/common/wald_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

export 'package:lucide_icons_flutter/lucide_icons.dart' show LucideIcons;

/// 아이콘 세트. 기본은 Lucide 이고, `--dart-define=WALD_MATERIAL_ICONS=true` 로 빌드하면
/// 기존 Material·자체 아이콘 글꼴·SVG 를 그대로 쓴다(비교용).
const bool kWaldLucideIcons = !bool.fromEnvironment('WALD_MATERIAL_ICONS');

/// Material → Lucide 대응. IconData 는 == 를 재정의해 const Map 키로 쓸 수 없어 final 로 둔다
/// (키·값은 모두 const 라 릴리스 빌드의 아이콘 글꼴 트리 셰이킹은 그대로 동작한다).
final Map<IconData, IconData> kWaldLucideFor = {
  Icons.done: LucideIcons.check,
  Icons.done_rounded: LucideIcons.check,
  Icons.check: LucideIcons.check,
  Icons.close: LucideIcons.x,
  Icons.close_rounded: LucideIcons.x,
  Icons.clear: LucideIcons.x,
  Icons.delete_outline_rounded: LucideIcons.trash2,
  Icons.delete_forever: LucideIcons.trash2,
  Icons.delete: LucideIcons.trash2,
  Icons.refresh: LucideIcons.refreshCw,
  Icons.refresh_rounded: LucideIcons.refreshCw,
  Icons.link: LucideIcons.link,
  Icons.link_off_rounded: LucideIcons.unlink,
  Icons.send_rounded: LucideIcons.send,
  Icons.edit: LucideIcons.pencil,
  Icons.edit_rounded: LucideIcons.pencil,
  Icons.copy: LucideIcons.copy,
  Icons.add: LucideIcons.plus,
  Icons.add_rounded: LucideIcons.plus,
  Icons.arrow_forward_rounded: LucideIcons.arrowRight,
  Icons.navigate_next_rounded: LucideIcons.chevronRight,
  Icons.arrow_back_rounded: LucideIcons.arrowLeft,
  Icons.security_rounded: LucideIcons.shieldCheck,
  Icons.call_rounded: LucideIcons.phone,
  Icons.call_end_rounded: LucideIcons.phoneOff,
  Icons.logout_rounded: LucideIcons.logOut,
  Icons.login_rounded: LucideIcons.logIn,
};

/// Lucide 모드면 [material] 의 Lucide 대응을, 아니면(또는 대응이 없으면) [material] 을 돌려준다.
IconData waldIcon(IconData material) =>
    kWaldLucideIcons ? (kWaldLucideFor[material] ?? material) : material;

/// [widget] 이 대응표에 있는 Material 아이콘이면 같은 크기·색의 Lucide 아이콘으로 바꾼다.
Widget? waldLucideIconWidget(Widget? widget) {
  if (kWaldLucideIcons && widget is Icon) {
    final icon = widget.icon;
    final lucide = icon == null ? null : kWaldLucideFor[icon];
    if (lucide != null) {
      return Icon(lucide,
          size: widget.size,
          color: widget.color,
          semanticLabel: widget.semanticLabel);
    }
  }
  return widget;
}

/// SVG 아이콘(원격 툴바·파일 전송·연결 관리 창) → Lucide. 없는 항목은 SVG 를 그대로 쓴다.
/// Lucide 모드가 아니면 쓰지 않는다(waldAssetIcon).
const Map<String, IconData> kWaldAssetIcon = {
  // 원격 툴바
  'assets/pinned.svg': LucideIcons.pin,
  'assets/unpinned.svg': LucideIcons.pinOff,
  'assets/actions.svg': LucideIcons.zap,
  'assets/actions_mobile.svg': LucideIcons.smartphone,
  'assets/display.svg': LucideIcons.monitor,
  'assets/keyboard_mouse.svg': LucideIcons.keyboard,
  'assets/chat.svg': LucideIcons.messageSquare,
  'assets/message_24dp_5F6368.svg': LucideIcons.messageSquareText,
  'assets/voice_call.svg': LucideIcons.phone,
  'assets/call_wait.svg': LucideIcons.phoneCall,
  'assets/rec.svg': LucideIcons.circleDot,
  'assets/close.svg': LucideIcons.x,
  // 파일 전송
  'assets/refresh.svg': LucideIcons.refreshCw,
  'assets/search.svg': LucideIcons.search,
  'assets/home.svg': LucideIcons.house,
  'assets/folder_new.svg': LucideIcons.folderPlus,
  'assets/trash.svg': LucideIcons.trash2,
  'assets/dots.svg': LucideIcons.ellipsisVertical,
  'assets/transfer.svg': LucideIcons.arrowLeftRight,
  'assets/file.svg': LucideIcons.file,
  'assets/folder.svg': LucideIcons.folder,
  // 연결 관리 창
  'assets/chat2.svg': LucideIcons.messageSquare,
  'assets/file_transfer.svg': LucideIcons.arrowLeftRight,
};

/// Lucide 모드면 [asset] SVG 를 대신할 Lucide 아이콘, 아니면 null(SVG 를 그대로 쓴다).
IconData? waldAssetIcon(String asset) =>
    kWaldLucideIcons ? kWaldAssetIcon[asset] : null;

/// 예전 SVG 는 [box] 크기 상자 안에 여백까지 그려져 있었다. 그 자리를 같은 크기 상자 가운데의
/// Lucide 아이콘([size])으로 대신한다.
Widget waldIconBox(IconData icon,
    {double box = 32, double size = WaldSize.icon, Color? color}) {
  return SizedBox.square(
    dimension: box,
    child: Center(child: Icon(icon, size: size, color: color)),
  );
}
