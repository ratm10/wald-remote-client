import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/common/widgets/dialog.dart';
import 'package:flutter_hbb/desktop/widgets/popup_menu.dart';
import 'package:flutter_hbb/models/ab_model.dart';
import 'package:flutter_hbb/models/peer_model.dart';
import 'package:flutter_hbb/models/wald_peer_names.dart';

/// Waldlust(DSK-06): 주소록 기기 이름 편집.
///
/// 브랜드 주소록은 서버가 읽기 전용(rule 1)으로 줘서 업스트림이 태그·메모·삭제 같은 쓰기 메뉴를 스스로 숨긴다.
/// 이름 변경만 서버가 `AbProfile.info.wald_rename` 으로 허용한다. 이름의 정본은 어드민이다.
bool waldCanRename(BaseAb ab) {
  final info = ab.sharedProfile()?.info;
  return info is Map && info['wald_rename'] == true;
}

void waldRenameAbPeer(Peer peer) {
  final oldName = peer.alias;
  renameDialog(
      oldName: oldName,
      onSubmit: (String newName) async {
        if (newName == oldName) return;
        // 업스트림 _renameAction 과 달리 로컬 피어 파일(alias)은 쓰지 않는다 — 저장에 실패해도 로컬 값이 바뀌고,
        // 파일 수정 시각이 최근접속목록 순서를 바꾸기 때문이다. 실패하면 changeAlias 가 오류 토스트를 띄운다.
        if (await gFFI.abModel.changeAlias(id: peer.id, alias: newName)) {
          WaldPeerNames.instance.set(peer.id, newName);
        }
      });
}

MenuEntryButton<String> waldRenameMenuEntry(Peer peer, EdgeInsets? padding) {
  return MenuEntryButton<String>(
    childBuilder: (TextStyle? style) => Text(
      translate('Rename'),
      style: style,
    ),
    proc: () => waldRenameAbPeer(peer),
    padding: padding,
    dismissOnClicked: true,
  );
}

/// 주소록 카드의 수정 버튼(명세 Q-31 기본값: 버튼 + 다이얼로그).
Widget waldEditButton(Peer peer) {
  return Tooltip(
    message: translate('Rename'),
    child: InkWell(
      onTap: () => waldRenameAbPeer(peer),
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(Icons.edit_outlined, size: 18),
      ),
    ),
  );
}
