// Waldlust(DSK-07): 어드민(웹)과 같은 톤의 디자인 토큰.
//
// 값은 어드민 실사이트 CSS(Tailwind v4 neutral·green·red·amber·blue)에서 옮겼다.
// neutral 800·950 과 red 950 은 어드민 CSS 에 없어 Tailwind 기본값으로 보탰다(다크 모드용).
// 주요 버튼은 검정(다크는 밝은 회색), 선택·진행·링크·켜진 토글은 파랑(blue600)이다.
// 이 파일은 common.dart 를 import 하지 않는다(common.dart 가 이 파일을 쓴다).
import 'package:flutter/material.dart';

class WaldPalette {
  WaldPalette._();

  static const Color white = Color(0xFFFFFFFF);

  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFE5E5E5);
  static const Color neutral300 = Color(0xFFD4D4D4);
  static const Color neutral400 = Color(0xFFA1A1A1);
  static const Color neutral500 = Color(0xFF737373);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral700 = Color(0xFF404040);
  static const Color neutral800 = Color(0xFF262626);
  static const Color neutral900 = Color(0xFF171717);
  static const Color neutral950 = Color(0xFF0A0A0A);

  static const Color green50 = Color(0xFFF0FDF4);
  static const Color green100 = Color(0xFFDCFCE7);
  static const Color green500 = Color(0xFF00C758);
  static const Color green600 = Color(0xFF00A544);
  static const Color green700 = Color(0xFF008138);

  static const Color red50 = Color(0xFFFEF2F2);
  static const Color red200 = Color(0xFFFFCACA);
  static const Color red500 = Color(0xFFFB2C36);
  static const Color red600 = Color(0xFFE40014);
  static const Color red700 = Color(0xFFBF000F);
  static const Color red950 = Color(0xFF460809);

  static const Color amber50 = Color(0xFFFFFBEB);
  static const Color amber500 = Color(0xFFF99C00);
  static const Color amber600 = Color(0xFFDD7400);

  static const Color blue600 = Color(0xFF155DFC);
  static const Color blue700 = Color(0xFF1447E6);

  // 알파 변형(const 문맥에서 쓰인다).
  static const Color blue600a77 = Color(0x77155DFC);
  static const Color blue600aAA = Color(0xAA155DFC);
  static const Color neutral200a80 = Color(0x80E5E5E5);
  static const Color neutral800a80 = Color(0x80262626);
}

class WaldSize {
  WaldSize._();

  static const double radius = 8;
  static const double dialogRadius = 16;
  static const double buttonHeight = 32;
  static const double buttonFont = 14;
  static const double smallFont = 12;
  static const double iconSm = 16;
  static const double icon = 18;
  static const double iconLg = 20;
}

/// 라이트·다크에 따라 달라지는 어드민 톤 색. `WaldColors.of(context)` 로 읽는다.
class WaldColors extends ThemeExtension<WaldColors> {
  const WaldColors({
    required this.primaryBg,
    required this.primaryFg,
    required this.secondaryBg,
    required this.secondaryBorder,
    required this.secondaryFg,
    required this.selectionBg,
    required this.headerBg,
    required this.permOn,
    required this.permOff,
    required this.permOffFg,
    required this.textMuted,
  });

  /// 주요 버튼 바탕·글자.
  final Color primaryBg;
  final Color primaryFg;

  /// 보조(테두리) 버튼 바탕·테두리·글자.
  final Color secondaryBg;
  final Color secondaryBorder;
  final Color secondaryFg;

  /// 선택된 목록 행 바탕.
  final Color selectionBg;

  /// 연결 관리 창 머리 바탕(글자는 흰색).
  final Color headerBg;

  /// 연결 관리 창 권한 타일(켜짐 바탕, 꺼짐 바탕·아이콘).
  final Color permOn;
  final Color permOff;
  final Color permOffFg;

  /// 보조 설명 글자.
  final Color textMuted;

  static const light = WaldColors(
    primaryBg: WaldPalette.neutral900,
    primaryFg: WaldPalette.white,
    secondaryBg: WaldPalette.white,
    secondaryBorder: WaldPalette.neutral300,
    secondaryFg: WaldPalette.neutral900,
    selectionBg: Color(0x1F155DFC),
    headerBg: WaldPalette.neutral900,
    permOn: WaldPalette.blue600,
    permOff: WaldPalette.neutral200,
    permOffFg: WaldPalette.neutral500,
    textMuted: WaldPalette.neutral500,
  );

  static const dark = WaldColors(
    primaryBg: WaldPalette.neutral100,
    primaryFg: WaldPalette.neutral900,
    secondaryBg: WaldPalette.neutral900,
    secondaryBorder: WaldPalette.neutral700,
    secondaryFg: WaldPalette.neutral100,
    selectionBg: Color(0x3D155DFC),
    headerBg: WaldPalette.neutral800,
    permOn: WaldPalette.blue600,
    permOff: WaldPalette.neutral700,
    permOffFg: WaldPalette.neutral400,
    textMuted: WaldPalette.neutral400,
  );

  static WaldColors of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<WaldColors>() ??
        (theme.brightness == Brightness.dark ? dark : light);
  }

  @override
  WaldColors copyWith({
    Color? primaryBg,
    Color? primaryFg,
    Color? secondaryBg,
    Color? secondaryBorder,
    Color? secondaryFg,
    Color? selectionBg,
    Color? headerBg,
    Color? permOn,
    Color? permOff,
    Color? permOffFg,
    Color? textMuted,
  }) {
    return WaldColors(
      primaryBg: primaryBg ?? this.primaryBg,
      primaryFg: primaryFg ?? this.primaryFg,
      secondaryBg: secondaryBg ?? this.secondaryBg,
      secondaryBorder: secondaryBorder ?? this.secondaryBorder,
      secondaryFg: secondaryFg ?? this.secondaryFg,
      selectionBg: selectionBg ?? this.selectionBg,
      headerBg: headerBg ?? this.headerBg,
      permOn: permOn ?? this.permOn,
      permOff: permOff ?? this.permOff,
      permOffFg: permOffFg ?? this.permOffFg,
      textMuted: textMuted ?? this.textMuted,
    );
  }

  @override
  WaldColors lerp(ThemeExtension<WaldColors>? other, double t) {
    if (other is! WaldColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t) ?? b;
    return WaldColors(
      primaryBg: l(primaryBg, other.primaryBg),
      primaryFg: l(primaryFg, other.primaryFg),
      secondaryBg: l(secondaryBg, other.secondaryBg),
      secondaryBorder: l(secondaryBorder, other.secondaryBorder),
      secondaryFg: l(secondaryFg, other.secondaryFg),
      selectionBg: l(selectionBg, other.selectionBg),
      headerBg: l(headerBg, other.headerBg),
      permOn: l(permOn, other.permOn),
      permOff: l(permOff, other.permOff),
      permOffFg: l(permOffFg, other.permOffFg),
      textMuted: l(textMuted, other.textMuted),
    );
  }
}

/// 데스크탑 입력 칸. 채움색은 기존처럼 바탕과 같은 톤으로 두어 테두리 없는 칸(홈 화면 ID·비밀번호 등)이
/// 바탕에 묻히게 하고, 테두리만 어드민처럼 연한 회색 · 포커스는 진한 색 · 오류는 빨강으로 둔다.
InputDecorationTheme waldInputTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final idle = dark ? WaldPalette.neutral700 : WaldPalette.neutral300;
  final disabled = dark ? WaldPalette.neutral800 : WaldPalette.neutral200;
  final focus = dark ? WaldPalette.neutral300 : WaldPalette.neutral900;
  final error = dark ? WaldPalette.red500 : WaldPalette.red600;
  Color stateColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.error)) return error;
    if (states.contains(WidgetState.focused)) return focus;
    if (states.contains(WidgetState.disabled)) return disabled;
    return idle;
  }

  return InputDecorationTheme(
    fillColor: dark ? WaldPalette.neutral900 : WaldPalette.neutral100,
    filled: true,
    isDense: true,
    border: MaterialStateOutlineInputBorder.resolveWith(
      (states) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(WaldSize.radius),
        borderSide: BorderSide(color: stateColor(states)),
      ),
    ),
    floatingLabelStyle: WidgetStateTextStyle.resolveWith(
      (states) => TextStyle(
          color: states.contains(WidgetState.error) ||
                  states.contains(WidgetState.focused)
              ? stateColor(states)
              : null),
    ),
  );
}
