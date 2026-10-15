import 'package:flutter_hbb/common/wald_hangul.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('영문·숫자·기호만이면 한글 아님', () {
    expect(waldHasHangul(''), isFalse);
    expect(waldHasHangul('abcd1234'), isFalse);
    expect(waldHasHangul('Ab!@#\$%^&*()_+-=[]{};:\'",.<>/?`~ '), isFalse);
  });

  test('한글 모드로 친 abcd1234 = 뮻ㅇ1234', () {
    expect(waldHasHangul('뮻ㅇ1234'), isTrue);
  });

  test('조합 중인 낱자·첫가끝 자모도 한글', () {
    expect(waldHasHangul('ㅁ'), isTrue); // 호환 자모
    expect(waldHasHangul('ㅏ'), isTrue);
    expect(waldHasHangul('ᄆ'), isTrue); // 첫가끝 초성 ㅁ
    expect(waldHasHangul('ᆼ'), isTrue); // 첫가끝 종성 ㅇ
    expect(waldHasHangul('a한'), isTrue);
  });

  test('한글이 아닌 다른 문자는 대상 아님', () {
    expect(waldHasHangul('あア漢'), isFalse);
  });
}
