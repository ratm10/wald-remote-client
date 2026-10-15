// Waldlust(DSK-03 — 명세 부록 A-32): 로그인 비밀번호의 한/영 실수 막기.
//
// OS·브라우저의 비밀번호 칸은 한글 입력기를 꺼서 한글 모드에서도 영문이 들어간다. Flutter 입력 칸은 그러지 않아
// 한글 모드로 친 비밀번호가 한글로 서버에 가고 로그인이 실패한다. 칸에는 ●만 보여 사용자는 이유를 모른다.
// 입력 중에는 글자를 고치지 않는다 — 조합 중인 한글을 입력 칸이 바꾸면 입력기 상태와 어긋난다(글자 중복·누락).
// 대신 한글이 들어오면 칸 아래에 안내를 띄우고(PasswordWidget warnHangul), 로그인 요청은 보내지 않는다(login.dart).

const kWaldPasswordHangulTip = 'wald-password-hangul-tip';

// 완성형, 첫가끝 자모와 확장 A·B, 호환 자모(조합 중인 낱자).
final _hangul = RegExp(r'[ᄀ-ᇿ㄰-㆏ꥠ-꥿가-퟿]');

/// [s] 에 한글이 섞여 있는지.
bool waldHasHangul(String s) => _hangul.hasMatch(s);
