// Waldlust(DSK-07): 아이콘 세트를 Lucide(lucide_icons_flutter, MIT)로 통일한다.
//
// - 기본 굵기 글꼴('Lucide') 하나만 쓴다. 다른 굵기 변형(LucideIcons.x100 … x600)은 섞지 않는다.
// - 모든 IconData 는 const 다(릴리스 빌드의 아이콘 글꼴 트리 셰이킹이 그대로 동작한다).
// - 크기: 버튼·메뉴 16, 툴바·파일 목록 18, 탭·연결 관리 창 머리 20(WaldSize).
// - IconFont(common.dart)의 상수도 Lucide 를 가리키므로, IconFont 를 쓰는 곳은 호출부를 고치지
//   않아도 Lucide 로 그려진다.
// - 호출부는 waldIcon(Icons.x) 처럼 Material 이름을 그대로 두고(업스트림 병합 때 원래 아이콘이
//   보이게), Lucide 대응은 아래 표(kWaldLucideFor) 한 곳에 모은다. 표에 없는 아이콘은 Material 그대로다.
// - 플랫폼 로고·로그인 제공자 로고·키보드 배열 그림·연결 보안 배지·화면 번호 SVG 는 유지한다.
import 'package:flutter/material.dart';
import 'package:flutter_hbb/common/wald_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

export 'package:lucide_icons_flutter/lucide_icons.dart' show LucideIcons;

/// Material → Lucide 대응. IconData 는 == 를 재정의해 const Map 키로 쓸 수 없어 final 로 둔다
/// (키·값은 모두 const 라 릴리스 빌드의 아이콘 글꼴 트리 셰이킹은 그대로 동작한다).
final Map<IconData, IconData> kWaldLucideFor = {
  Icons.network_ping_outlined: LucideIcons.activity,
  Icons.web_asset_outlined: LucideIcons.appWindow,
  Icons.arrow_back: LucideIcons.arrowLeft,
  Icons.arrow_back_rounded: LucideIcons.arrowLeft,
  Icons.arrow_forward_rounded: LucideIcons.arrowRight,
  Icons.block: LucideIcons.ban,
  Icons.check: LucideIcons.check,
  Icons.done: LucideIcons.check,
  Icons.done_rounded: LucideIcons.check,
  Icons.arrow_drop_down: LucideIcons.chevronDown,
  Icons.expand_more: LucideIcons.chevronDown,
  Icons.expand_more_sharp: LucideIcons.chevronDown,
  Icons.keyboard_arrow_down_rounded: LucideIcons.chevronDown,
  Icons.arrow_left: LucideIcons.chevronLeft,
  Icons.chevron_left: LucideIcons.chevronLeft,
  Icons.arrow_forward_ios: LucideIcons.chevronRight,
  Icons.arrow_right: LucideIcons.chevronRight,
  Icons.chevron_right: LucideIcons.chevronRight,
  Icons.keyboard_arrow_right: LucideIcons.chevronRight,
  Icons.keyboard_arrow_right_rounded: LucideIcons.chevronRight,
  Icons.navigate_next_rounded: LucideIcons.chevronRight,
  Icons.expand_less: LucideIcons.chevronUp,
  Icons.keyboard_arrow_up_rounded: LucideIcons.chevronUp,
  Icons.error_outline: LucideIcons.circleAlert,
  Icons.check_circle: LucideIcons.circleCheck,
  Icons.help: LucideIcons.circleHelp,
  Icons.help_outline: LucideIcons.circleHelp,
  Icons.help_outline_outlined: LucideIcons.circleHelp,
  Icons.pause_circle_filled: LucideIcons.circlePause,
  Icons.cancel: LucideIcons.circleX,
  Icons.assignment_rounded: LucideIcons.clipboardList,
  Icons.explore: LucideIcons.compass,
  Icons.copy: LucideIcons.copy,
  Icons.download: LucideIcons.download,
  Icons.launch_outlined: LucideIcons.externalLink,
  Icons.visibility: LucideIcons.eye,
  Icons.visibility_off: LucideIcons.eyeOff,
  Icons.file_copy_outlined: LucideIcons.files,
  Icons.file_copy_sharp: LucideIcons.files,
  Icons.folder_outlined: LucideIcons.folder,
  Icons.drive_file_move_outlined: LucideIcons.folderInput,
  Icons.folder_open: LucideIcons.folderOpen,
  Icons.create_new_folder: LucideIcons.folderPlus,
  Icons.drag_handle: LucideIcons.gripHorizontal,
  Icons.drag_indicator: LucideIcons.gripVertical,
  Icons.access_time_filled: LucideIcons.history,
  Icons.hourglass_top: LucideIcons.hourglass,
  Icons.home: LucideIcons.house,
  Icons.home_outlined: LucideIcons.house,
  Icons.home_sharp: LucideIcons.house,
  Icons.info: LucideIcons.info,
  Icons.info_outline: LucideIcons.info,
  Icons.info_outline_rounded: LucideIcons.info,
  Icons.key: LucideIcons.key,
  Icons.password_rounded: LucideIcons.keyRound,
  Icons.keyboard: LucideIcons.keyboard,
  Icons.link: LucideIcons.link,
  Icons.link_outlined: LucideIcons.link,
  Icons.lock_outline: LucideIcons.lock,
  Icons.no_encryption_outlined: LucideIcons.lockOpen,
  Icons.login_rounded: LucideIcons.logIn,
  Icons.logout_rounded: LucideIcons.logOut,
  Icons.email: LucideIcons.mail,
  Icons.fullscreen: LucideIcons.maximize,
  Icons.chat: LucideIcons.messageSquare,
  Icons.fullscreen_exit: LucideIcons.minimize,
  Icons.remove: LucideIcons.minus,
  Icons.computer: LucideIcons.monitor,
  Icons.desktop_windows: LucideIcons.monitor,
  Icons.desktop_windows_outlined: LucideIcons.monitor,
  Icons.desktop_windows_sharp: LucideIcons.monitor,
  Icons.mouse: LucideIcons.mouse,
  Icons.lan_outlined: LucideIcons.network,
  Icons.edit: LucideIcons.pencil,
  Icons.edit_rounded: LucideIcons.pencil,
  Icons.call_rounded: LucideIcons.phone,
  Icons.call_received_rounded: LucideIcons.phoneIncoming,
  Icons.call_end_rounded: LucideIcons.phoneOff,
  Icons.phone_disabled_rounded: LucideIcons.phoneOff,
  Icons.call_made_rounded: LucideIcons.phoneOutgoing,
  Icons.add: LucideIcons.plus,
  Icons.add_rounded: LucideIcons.plus,
  Icons.print: LucideIcons.printer,
  Icons.print_outlined: LucideIcons.printer,
  Icons.extension: LucideIcons.puzzle,
  Icons.extension_outlined: LucideIcons.puzzle,
  Icons.refresh: LucideIcons.refreshCw,
  Icons.refresh_rounded: LucideIcons.refreshCw,
  Icons.reply: LucideIcons.reply,
  Icons.restart_alt_rounded: LucideIcons.rotateCcw,
  Icons.screen_share_outlined: LucideIcons.screenShare,
  Icons.send_rounded: LucideIcons.send,
  Icons.dns_outlined: LucideIcons.server,
  Icons.build_outlined: LucideIcons.settings,
  Icons.build_sharp: LucideIcons.settings,
  Icons.settings: LucideIcons.settings,
  Icons.settings_outlined: LucideIcons.settings,
  Icons.admin_panel_settings: LucideIcons.shieldCheck,
  Icons.enhanced_encryption: LucideIcons.shieldCheck,
  Icons.enhanced_encryption_outlined: LucideIcons.shieldCheck,
  Icons.security_rounded: LucideIcons.shieldCheck,
  Icons.security_sharp: LucideIcons.shieldCheck,
  Icons.crop_square: LucideIcons.square,
  Icons.star: LucideIcons.star,
  Icons.delete: LucideIcons.trash2,
  Icons.delete_forever: LucideIcons.trash2,
  Icons.delete_outline: LucideIcons.trash2,
  Icons.delete_outline_rounded: LucideIcons.trash2,
  Icons.delete_rounded: LucideIcons.trash2,
  Icons.warning_amber_rounded: LucideIcons.triangleAlert,
  Icons.warning_amber_sharp: LucideIcons.triangleAlert,
  Icons.warning_rounded: LucideIcons.triangleAlert,
  Icons.link_off_rounded: LucideIcons.unlink,
  Icons.upload: LucideIcons.upload,
  Icons.upload_file_rounded: LucideIcons.upload,
  Icons.account_circle_outlined: LucideIcons.user,
  Icons.person: LucideIcons.user,
  Icons.person_outline: LucideIcons.user,
  Icons.group: LucideIcons.users,
  Icons.videocam_outlined: LucideIcons.video,
  Icons.videocam_rounded: LucideIcons.video,
  Icons.volume_up_rounded: LucideIcons.volume2,
  Icons.clear: LucideIcons.x,
  Icons.close: LucideIcons.x,
  Icons.close_rounded: LucideIcons.x,
};

/// [material] 의 Lucide 대응을 돌려준다(대응이 없으면 [material] 그대로).
IconData waldIcon(IconData material) => kWaldLucideFor[material] ?? material;

/// [widget] 이 대응표에 있는 Material 아이콘이면 같은 크기·색의 Lucide 아이콘으로 바꾼다.
Widget? waldLucideIconWidget(Widget? widget) {
  if (widget is Icon) {
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
  // 파일 전송(arrow 는 오른쪽 화살표를 돌려 뒤로·위로·보내기·받기에 쓴다)
  'assets/arrow.svg': LucideIcons.arrowRight,
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

/// [asset] SVG 를 대신할 Lucide 아이콘. 대응이 없으면 null(SVG 를 그대로 쓴다).
IconData? waldAssetIcon(String asset) => kWaldAssetIcon[asset];

/// 예전 SVG 는 [box] 크기 상자 안에 여백까지 그려져 있었다. 그 자리를 같은 크기 상자 가운데의
/// Lucide 아이콘([size])으로 대신한다.
Widget waldIconBox(IconData icon,
    {double box = 32, double size = WaldSize.icon, Color? color}) {
  return SizedBox.square(
    dimension: box,
    child: Center(child: Icon(icon, size: size, color: color)),
  );
}

/// SvgPicture.asset 대신 쓴다. 대응이 있으면 같은 크기 상자 가운데에 Lucide 를,
/// 아니면 SVG 를 그린다. [color] 는 SVG 에 주던 svgColor(color) 와 같다. 크기를 주지 않으면
/// 예전 SVG 의 기본 크기(32)를 쓰고, 아이콘은 상자의 18/32 크기다(예: 32 → 18).
Widget waldSvg(String asset,
    {Color? color, double? width, double? height, double? iconSize}) {
  final lucide = waldAssetIcon(asset);
  if (lucide == null) {
    return SvgPicture.asset(asset,
        colorFilter:
            color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
        width: width,
        height: height);
  }
  final w = width ?? height ?? 32;
  final h = height ?? width ?? 32;
  return SizedBox(
    width: w,
    height: h,
    child: Center(
      child: Icon(lucide,
          size: iconSize ?? (w < h ? w : h) * WaldSize.icon / 32, color: color),
    ),
  );
}
