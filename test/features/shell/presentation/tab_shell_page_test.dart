import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/core/presentation/widgets/nyaya_icon.dart';
import 'package:nyaya/features/shell/presentation/tab_shell_page.dart';

ShellTab tab(String id, WidgetBuilder builder) => ShellTab(
  id: id,
  label: id.toUpperCase(),
  icon: HomeIconType.navHome,
  builder: builder,
);

void main() {
  late TabShellController controller;

  setUp(() => controller = TabShellController());
  tearDown(() => controller.dispose());

  Future<void> pumpShell(WidgetTester tester, List<ShellTab> tabs) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TabShellPage(tabs: tabs, controller: controller),
      ),
    );
    await tester.pumpAndSettle();
  }

  final plainTabs = [
    tab('home', (_) => const Text('home body')),
    tab('categories', (_) => const Text('categories body')),
    tab('profile', (_) => const Text('profile body')),
  ];

  testWidgets('shows the first tab active with a nav item per tab', (
    tester,
  ) async {
    await pumpShell(tester, plainTabs);

    expect(find.text('HOME'), findsOneWidget);
    expect(find.text('CATEGORIES'), findsOneWidget);
    expect(find.text('PROFILE'), findsOneWidget);
    expect(find.byKey(const ValueKey('nav.home.active')), findsOneWidget);
    expect(find.text('home body'), findsOneWidget);
  });

  testWidgets('AC-002 tapping a tab shows it and marks it active', (
    tester,
  ) async {
    await pumpShell(tester, plainTabs);

    await tester.tap(find.byKey(const ValueKey('nav.profile')));
    await tester.pumpAndSettle();

    expect(find.text('profile body'), findsOneWidget);
    expect(find.text('home body'), findsNothing);
    expect(find.byKey(const ValueKey('nav.profile.active')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav.home.inactive')), findsOneWidget);
  });

  testWidgets('AC-003 a tab keeps its state when switching away and back', (
    tester,
  ) async {
    await pumpShell(tester, [
      tab('home', (_) => const _Counter()),
      tab('profile', (_) => const Text('profile body')),
    ]);

    await tester.tap(find.byKey(const ValueKey('counter.add')));
    await tester.tap(find.byKey(const ValueKey('counter.add')));
    await tester.pump();
    expect(find.text('count 2'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav.profile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav.home')));
    await tester.pumpAndSettle();

    expect(find.text('count 2'), findsOneWidget);
  });

  testWidgets('AC-004 the controller switches tabs from inside a page', (
    tester,
  ) async {
    await pumpShell(tester, plainTabs);

    controller.select(1);
    await tester.pumpAndSettle();

    expect(find.text('categories body'), findsOneWidget);
    expect(find.byKey(const ValueKey('nav.categories.active')), findsOneWidget);
  });

  testWidgets('AC-005 back on another tab returns to the first tab', (
    tester,
  ) async {
    await pumpShell(tester, plainTabs);
    await tester.tap(find.byKey(const ValueKey('nav.profile')));
    await tester.pumpAndSettle();

    final handled = await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(handled, isTrue);
    expect(find.text('home body'), findsOneWidget);
    expect(find.byKey(const ValueKey('nav.home.active')), findsOneWidget);
  });

  testWidgets('spec 037 AC-003 long nav labels stay on one line', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpShell(tester, [
      tab('home', (_) => const SizedBox()),
      tab('categories', (_) => const SizedBox()),
      tab('leaderboard', (_) => const SizedBox()),
      tab('articles', (_) => const SizedBox()),
      tab('profile', (_) => const SizedBox()),
    ]);

    final label = tester.widget<Text>(find.text('LEADERBOARD'));
    expect(label.maxLines, 1);
    expect(label.softWrap, isFalse);
    expect(tester.takeException(), isNull);
    // Selecting keeps the same weight, so the row doesn't shift.
    expect(label.style?.fontWeight, FontWeight.w600);
  });
}

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  var _count = 0;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text('count $_count'),
      TextButton(
        key: const ValueKey('counter.add'),
        onPressed: () => setState(() => _count++),
        child: const Text('add'),
      ),
    ],
  );
}
