import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../common.dart';
import '../../models/platform_model.dart';

// Waldlust(DSK-07·DSK-10 — 명세 부록 A-38): 화면에 쓰는 앱 이름. 런처 라벨(AndroidManifest
// android:label)·macOS 번들 이름(AppInfo.xcconfig PRODUCT_NAME)·Windows 시작 메뉴(Inno AppName)와 같다.
// APP_NAME(`Waldlust`)은 설정 폴더·IPC 에 묶여 있어 그대로 둔다(Q-29).
const kWaldAppDisplayName = 'Waldlust 원격지원';

/// 앱바 오른쪽 정보 버튼. 수신 전용 Android 는 설정 탭이 잠겨 있어(disable-settings) 버전을 볼 곳이 없다.
Widget waldAppInfoButton() {
  return IconButton(
    tooltip: translate('About'),
    icon: Icon(waldIcon(Icons.info_outline)),
    onPressed: showWaldAppInfo,
  );
}

/// 앱 이름·버전·빌드 날짜와 공개 고지 링크(데스크탑 설정 '정보'와 같은 항목, 지문은 뺌).
Future<void> showWaldAppInfo() async {
  final buildDate = await bind.mainGetBuildDate();
  gFFI.dialogManager.show((setState, close, context) {
    Widget infoRow(String label, String value) => Row(children: [
          SizedBox(
              width: 80,
              child: Text(label,
                  style: const TextStyle(color: WaldPalette.neutral500))),
          Expanded(child: SelectableText(value)),
        ]).marginSymmetric(vertical: 4);
    Widget link(String text, String url) => InkWell(
          onTap: () => launchUrlString(url),
          child: Row(children: [
            Text(text,
                style: const TextStyle(decoration: TextDecoration.underline)),
            Icon(waldIcon(Icons.launch_outlined),
                    size: 14, color: WaldPalette.neutral500)
                .marginOnly(left: 4),
          ]).marginSymmetric(vertical: 6),
        );
    return CustomAlertDialog(
      title: Text(kWaldAppDisplayName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          infoRow(translate('Version'), version),
          infoRow(translate('Build Date'), buildDate),
          const Divider(height: 24),
          // Waldlust(D35): 이 앱이 보내는 정보·오픈소스 고지(자사 공개 페이지).
          link(translate('Privacy Statement'), kWaldPrivacyUrl),
          link(translate('Open source notices'), kWaldOssUrl),
          Text(
            // Waldlust(D35 — AGPL §5): 데스크탑 설정 '정보'의 저작권 줄과 같다.
            'Copyright © ${DateTime.now().toString().substring(0, 4)} Purslane Ltd.\n'
            'Modifications © 2026 Waldlust Co., Ltd.\n'
            'Licensed under the GNU AGPL-3.0, without any warranty.',
            style: const TextStyle(fontSize: 11, color: WaldPalette.neutral500),
          ).marginOnly(top: 12),
        ],
      ),
      actions: [dialogButton('Close', onPressed: close)],
      onCancel: close,
    );
  }, backDismiss: true, clickMaskDismiss: true);
}
