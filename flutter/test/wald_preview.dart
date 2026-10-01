// Waldlust(DSK-07): 디자인 미리보기. 원격 툴바·파일 전송 창을 연결 없이 '연결된 상태'로 띄운다.
//
// flutter run -d macos --release -t test/wald_preview.dart
//
// - 연결 관리 창은 test/cm_demo.dart 를 쓴다.
// - 핀·닫기·전체화면·채팅 버튼은 누르지 않는다(공용 설정에 쓰거나 세션이 필요하다).
// - 라이트/다크 버튼은 이 창만 바꾼다(Get.changeThemeMode). 공용 설정(theme)은 건드리지 않는다.
//   MyTheme.currentThemeMode() 로 색을 고르는 곳은 앱 설정·시스템 모드를 따르므로,
//   다크를 정확히 보려면 시스템 화면 모드도 다크로 둔다.
import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/common/shared_state.dart';
import 'package:flutter_hbb/consts.dart';
import 'package:flutter_hbb/desktop/pages/file_manager_page.dart';
import 'package:flutter_hbb/desktop/widgets/remote_toolbar.dart';
import 'package:flutter_hbb/desktop/widgets/tabbar_widget.dart';
import 'package:flutter_hbb/main.dart';
import 'package:flutter_hbb/models/file_model.dart';
import 'package:flutter_hbb/models/model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

const _kToolbarPeerId = 'wald-preview';
const _kFilePeerId = 'wald-preview-ft';

void main() async {
  isTest = true;
  waldFileManagerPreview = true;
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await initEnv(kAppTypeMain);

  final controller = DesktopTabController(tabType: DesktopTabType.cm);
  controller.add(TabInfo(
      key: 'toolbar',
      label: '원격 툴바',
      selectedIcon: Icons.desktop_windows_sharp,
      unselectedIcon: Icons.desktop_windows_outlined,
      closable: false,
      page: const _ToolbarPreview()));
  controller.add(TabInfo(
      key: 'files',
      label: '파일 전송',
      selectedIcon: Icons.file_copy_sharp,
      unselectedIcon: Icons.file_copy_outlined,
      closable: false,
      page: const _FileTransferPreview()));
  controller.add(TabInfo(
      key: 'gallery',
      label: '버튼·입력',
      selectedIcon: Icons.widgets,
      unselectedIcon: Icons.widgets_outlined,
      closable: false,
      page: const _GalleryPreview()));
  controller.jumpTo(0);

  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: MyTheme.currentThemeMode(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      home: Scaffold(
        body: DesktopTab(
          controller: controller,
          showMaximize: false,
          selectedBorderColor: MyTheme.accent,
          tail: const _ThemeToggle(),
        ),
      )));

  WindowOptions windowOptions =
      getHiddenTitleBarWindowOptions(size: const Size(1280, 860));
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.setSize(const Size(1280, 860));
    await windowManager.center();
    await windowManager.focus();
  });
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return TextButton(
      onPressed: () =>
          Get.changeThemeMode(dark ? ThemeMode.light : ThemeMode.dark),
      child: Text(dark ? '라이트로' : '다크로'),
    ).paddingSymmetric(horizontal: 8);
  }
}

/// 연결된 Windows 기기(디스플레이 2개, 권한 모두 허용)를 가정한 원격 툴바.
class _ToolbarPreview extends StatefulWidget {
  const _ToolbarPreview();

  @override
  State<_ToolbarPreview> createState() => _ToolbarPreviewState();
}

class _ToolbarPreviewState extends State<_ToolbarPreview>
    with AutomaticKeepAliveClientMixin {
  final _ffi = FFI(null);
  final _toolbarState = ToolbarState();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _ffi.id = _kToolbarPeerId;
    initSharedStates(_kToolbarPeerId);
    ConnectionTypeState.init(_kToolbarPeerId);
    final pi = _ffi.ffiModel.pi;
    pi.platform = kPeerPlatformWindows;
    pi.version = '1.4.8';
    pi.username = 'wald';
    pi.hostname = 'PREVIEW-PC';
    pi.displays.value = [
      Display(),
      Display()..x = kDesktopDefaultDisplayWidth.toDouble(),
    ];
    pi.displaysCount.value = 2;
    _ffi.ffiModel.setPermissions({
      'keyboard': true,
      'clipboard': true,
      'audio': true,
      'file': true,
      'restart': true,
      'recording': true,
      'block_input': true,
    });
    pi.isSet.value = true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _ffi.ffiModel),
        ChangeNotifierProvider.value(value: _ffi.imageModel),
        ChangeNotifierProvider.value(value: _ffi.cursorModel),
        ChangeNotifierProvider.value(value: _ffi.canvasModel),
        ChangeNotifierProvider.value(value: _ffi.recordingModel),
      ],
      child: Stack(children: [
        Container(color: kColorCanvas),
        Overlay(initialEntries: [
          OverlayEntry(
              builder: (_) => RemoteToolbar(
                    id: _kToolbarPeerId,
                    ffi: _ffi,
                    state: _toolbarState,
                    onEnterOrLeaveImageSetter: (_, __) {},
                    onEnterOrLeaveImageCleaner: (_) {},
                    setRemoteState: (_) {},
                  ))
        ]),
      ]),
    );
  }
}

/// 로컬(macOS)·원격(Windows) 목록과 전송 작업 네 상태를 채운 파일 전송 창.
class _FileTransferPreview extends StatefulWidget {
  const _FileTransferPreview();

  @override
  State<_FileTransferPreview> createState() => _FileTransferPreviewState();
}

class _FileTransferPreviewState extends State<_FileTransferPreview> {
  late final FileManagerPage _page =
      FileManagerPage(id: _kFilePeerId, password: null, isSharedPassword: null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fill());
  }

  void _fill() {
    final model = _page.ffi.fileModel;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    Entry entry(String name, int type, int size, int ago) => Entry()
      ..name = name
      ..entryType = type
      ..size = size
      ..modifiedTime = now - ago;

    final local = model.localController;
    local.options.value
      ..home = '/Users/wald'
      ..isWindows = false;
    local.directory.value = FileDirectory()
      ..path = '/Users/wald/Documents'
      ..entries = [
        entry('매장 자료', 1, 0, 3600),
        entry('Invoices', 1, 0, 86400),
        entry('메뉴판_2026.pdf', 4, 2345678, 600),
        entry('report.xlsx', 4, 345678, 7200),
        entry('사진.png', 4, 12345678, 172800),
      ]
      ..format(false);

    final remote = model.remoteController;
    remote.options.value
      ..home = 'C:\\Users\\POS'
      ..isWindows = true;
    remote.directory.value = FileDirectory()
      ..path = 'C:\\Users\\POS\\Desktop'
      ..entries = [
        entry('주문 백업', 1, 0, 1800),
        entry('Logs', 1, 0, 5400),
        entry('설정.ini', 4, 2048, 300),
        entry('sales_0930.csv', 4, 98765, 9000),
      ]
      ..format(true);

    JobProgress job(int id, JobState state, String name, int total, int done,
            {bool toLocal = true, String err = ''}) =>
        JobProgress()
          ..id = id
          ..type = JobType.transfer
          ..state = state
          ..fileName = name
          ..jobName = name
          ..totalSize = total
          ..finishedSize = done
          ..speed = state == JobState.inProgress ? 1536000 : 0
          ..isRemoteToLocal = toLocal
          ..err = err;
    model.jobController.jobTable.addAll([
      job(1, JobState.inProgress, 'sales_0930.csv', 98765000, 45000000),
      job(2, JobState.paused, '주문 백업.zip', 52428800, 10485760),
      job(3, JobState.done, '메뉴판_2026.pdf', 2345678, 2345678, toLocal: false),
      job(4, JobState.error, '설정.ini', 2048, 0, err: 'Permission denied'),
    ]);
  }

  @override
  Widget build(BuildContext context) => _page;
}

/// 버튼(가운데 기준선 표시)·입력·토글·대화상자·메뉴 견본.
class _GalleryPreview extends StatefulWidget {
  const _GalleryPreview();

  @override
  State<_GalleryPreview> createState() => _GalleryPreviewState();
}

class _GalleryPreviewState extends State<_GalleryPreview> {
  bool _check = true;
  bool _switch = true;
  int _radio = 0;

  // 버튼 세로 가운데에 1px 기준선을 그어 글자가 가운데 있는지 본다.
  Widget _guide(Widget button) => Stack(
        alignment: Alignment.center,
        children: [
          button,
          IgnorePointer(
            child: Container(
                height: 1, width: 140, color: Colors.red.withOpacity(0.6)),
          ),
        ],
      );

  Widget _section(String title, List<Widget> children) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall)
              .paddingOnly(bottom: 8),
          Wrap(spacing: 12, runSpacing: 12, children: children),
        ],
      ).paddingOnly(bottom: 24);

  @override
  Widget build(BuildContext context) {
    void noop() {}
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _section('dialogButton — 한글', [
            _guide(dialogButton('확인', onPressed: noop)),
            _guide(dialogButton('취소', onPressed: noop, isOutline: true)),
            _guide(dialogButton('연결',
                onPressed: noop, icon: const Icon(Icons.done_rounded))),
            _guide(dialogButton('닫기',
                onPressed: noop,
                isOutline: true,
                icon: const Icon(Icons.close_rounded))),
            _guide(dialogButton('비활성', onPressed: null)),
          ]),
          _section('dialogButton — English', [
            _guide(dialogButton('Okay', onPressed: noop)),
            _guide(dialogButton('Dismiss', onPressed: noop, isOutline: true)),
            _guide(dialogButton('Connect now',
                onPressed: noop, icon: const Icon(Icons.done_rounded))),
            _guide(dialogButton('Disabled', onPressed: null)),
          ]),
          _section('Lucide 아이콘 — 16 / 18 / 20', [
            for (final size in [16.0, 18.0, 20.0])
              Wrap(spacing: 10, children: [
                for (final icon in const [
                  LucideIcons.monitor,
                  LucideIcons.keyboard,
                  LucideIcons.messageSquare,
                  LucideIcons.phone,
                  LucideIcons.zap,
                  LucideIcons.pin,
                  LucideIcons.circleDot,
                  LucideIcons.x,
                  LucideIcons.folder,
                  LucideIcons.folderPlus,
                  LucideIcons.trash2,
                  LucideIcons.refreshCw,
                  LucideIcons.house,
                  LucideIcons.settings,
                  LucideIcons.star,
                  LucideIcons.history,
                  LucideIcons.bookUser,
                  LucideIcons.shieldCheck,
                ])
                  Icon(icon, size: size),
              ]),
          ]),
          _section('입력', [
            const SizedBox(
                width: 240,
                child:
                    TextField(decoration: InputDecoration(hintText: '기기 이름'))),
            const SizedBox(
                width: 240,
                child: TextField(
                    decoration: InputDecoration(
                        hintText: '비밀번호', errorText: '비밀번호가 틀렸습니다'))),
            const SizedBox(
                width: 240,
                child: TextField(
                    enabled: false,
                    decoration: InputDecoration(hintText: '비활성'))),
          ]),
          _section('토글', [
            Row(mainAxisSize: MainAxisSize.min, children: [
              Checkbox(
                  value: _check,
                  onChanged: (v) => setState(() => _check = v ?? false)),
              const Text('체크박스'),
            ]),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Switch(
                  value: _switch,
                  onChanged: (v) => setState(() => _switch = v)),
              const Text('스위치'),
            ]),
            for (final i in [0, 1])
              Row(mainAxisSize: MainAxisSize.min, children: [
                Radio<int>(
                    value: i,
                    groupValue: _radio,
                    onChanged: (v) => setState(() => _radio = v ?? 0)),
                Text('라디오 ${i + 1}'),
              ]),
          ]),
          _section('대화상자·메뉴', [
            dialogButton('대화상자 열기',
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => CustomAlertDialog(
                          title: const Text('기기 이름 변경'),
                          content: const TextField(
                              decoration: InputDecoration(hintText: '새 이름')),
                          actions: [
                            dialogButton('취소',
                                onPressed: () => Navigator.pop(context),
                                isOutline: true),
                            dialogButton('저장',
                                onPressed: () => Navigator.pop(context)),
                          ],
                        ))),
            PopupMenuButton<int>(
              tooltip: '메뉴',
              itemBuilder: (_) => const [
                PopupMenuItem(value: 0, child: Text('연결')),
                PopupMenuItem(value: 1, child: Text('파일 전송')),
                PopupMenuItem(value: 2, child: Text('이름 변경')),
              ],
              child: const Icon(Icons.more_vert),
            ),
            const Tooltip(message: '툴팁 예시', child: Text('툴팁(마우스 올리기)')),
          ]),
        ],
      ),
    );
  }
}
