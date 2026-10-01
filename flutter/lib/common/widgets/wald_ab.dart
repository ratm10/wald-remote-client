import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/common/widgets/dialog.dart';
import 'package:flutter_hbb/common/widgets/peer_card.dart';
import 'package:flutter_hbb/desktop/widgets/popup_menu.dart';
import 'package:flutter_hbb/models/ab_model.dart';
import 'package:flutter_hbb/models/peer_model.dart';
import 'package:flutter_hbb/models/peer_tab_model.dart';
import 'package:flutter_hbb/models/wald_peer_names.dart';
import 'package:get/get.dart';

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
  return _waldCardButton(
      Icons.edit_outlined, translate('Rename'), () => waldRenameAbPeer(peer));
}

/// Waldlust(DSK-04): 주소록 카드 오른쪽 버튼 — 연결, 파일 전송, (권한이 있으면) 이름 편집, 그다음 업스트림 더보기 메뉴.
/// 그리드 카드는 이름과 한 줄을 나눠 쓰므로 버튼을 작게 둔다.
Widget waldAbCardActions(BuildContext context, Peer peer, Widget more) {
  return Row(mainAxisSize: MainAxisSize.min, children: [
    _waldCardButton(Icons.screen_share_outlined, translate('Connect'),
        () => connectInPeerTab(context, peer, PeerTabIndex.ab)),
    _waldCardButton(
        Icons.folder_outlined,
        translate('Transfer file'),
        () => connectInPeerTab(context, peer, PeerTabIndex.ab,
            isFileTransfer: true)),
    if (waldCanRename(gFFI.abModel.current)) waldEditButton(peer),
    more,
  ]);
}

Widget _waldCardButton(IconData icon, String tooltip, VoidCallback onTap) {
  return Tooltip(
    message: tooltip,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Icon(icon, size: 18),
      ),
    ),
  );
}

/// Waldlust(DSK-04): 주소록 왼쪽 패널에 선택 드롭다운·태그 대신 브랜드 목록을 둔다(`address_book.dart`).
/// const 가 아닌 것은 업스트림 패널 코드가 죽은 코드로 표시되지 않게 하려는 것이다.
final waldAbBrandPanel = true;

const _kAllAbGuid = 'all'; // 서버의 '전체' 주소록(권한 범위 전체 기기)

/// 브랜드(공유 주소록) 목록. 맨 위는 '전체', 나머지는 드롭다운과 같은 이름순. 고르면 오른쪽에 그 기기 목록이 보인다.
class WaldAbBrandList extends StatelessWidget {
  final bool isPortrait;
  const WaldAbBrandList({Key? key, required this.isPortrait}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final abModel = gFFI.abModel;
      final names = abModel.addressBookNames()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      final allIndex = names.indexWhere((e) =>
          abModel.addressbooks[e]?.sharedProfile()?.guid == _kAllAbGuid);
      if (allIndex > 0) names.insert(0, names.removeAt(allIndex));
      final current = abModel.currentName.value;
      final list = ListView.builder(
          shrinkWrap: isPortrait,
          itemCount: names.length,
          itemBuilder: (context, index) => _buildItem(context, names[index],
              isAll: index == 0 && allIndex >= 0,
              selected: names[index] == current));
      if (isPortrait) {
        return LimitedBox(
            maxHeight: max(MediaQuery.of(context).size.height / 6, 100.0),
            child: list);
      }
      return list.marginOnly(top: 8);
    });
  }

  Widget _buildItem(BuildContext context, String name,
      {required bool isAll, required bool selected}) {
    return InkWell(
      onTap: () async {
        // 업스트림은 이미 받은 주소록을 다시 받지 않는다. 다른 주소록에서 바꾼 이름이 늦게 보이지 않게 다시 받는다.
        final pulled = gFFI.abModel.addressbooks[name]?.initialized == true;
        await gFFI.abModel.setCurrentName(name);
        if (pulled) {
          gFFI.abModel.pullAb(force: ForcePullAb.current, quiet: true);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected ? MyTheme.color(context).highlight : null,
          border: Border(
              bottom: BorderSide(
                  width: 0.7,
                  color: Theme.of(context).dividerColor.withOpacity(0.1))),
        ),
        child: Row(
          children: [
            Icon(isAll ? Icons.apps_rounded : Icons.storefront_outlined,
                    color: MyTheme.accent, size: 19)
                .marginOnly(right: 6),
            Expanded(
                child: Text(gFFI.abModel.translatedName(name),
                    overflow: TextOverflow.ellipsis)),
          ],
        ).paddingSymmetric(vertical: 6),
      ),
    ).marginSymmetric(horizontal: 12).marginOnly(bottom: 4);
  }
}
