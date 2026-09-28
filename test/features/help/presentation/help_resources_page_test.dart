import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:nyaya/features/help/data/help_resources_repository.dart';
import 'package:nyaya/features/help/presentation/help_resources_page.dart';
import 'package:nyaya/features/help/presentation/help_resources_view_model.dart';

import '../../../support/fake_backend.dart';
import '../../../support/help_resources_backend.dart';
import '../../../support/localized_app.dart';

void main() {
  late List<Uri> opened;
  late bool canOpen;

  Future<void> pumpPage(
    WidgetTester tester,
    Map<String, Object> routes, {
    Locale locale = const Locale('en'),
  }) async {
    opened = [];
    canOpen = true;
    final viewModel = HelpResourcesViewModel(
      repository: HelpResourcesRepository(fakeBackend(routes)),
    );
    addTearDown(viewModel.dispose);
    await pumpLocalized(
      tester,
      HelpResourcesPage(
        viewModel: viewModel,
        openLink: (uri) async {
          opened.add(uri);
          return canOpen;
        },
      ),
      locale: locale,
    );
  }

  Future<void> scrollTo(WidgetTester tester, Finder target) async {
    await tester.scrollUntilVisible(
      target,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the picked filters and matching contacts', (tester) async {
    await pumpPage(tester, helpResourcesRoutes());

    expect(find.text('Tamil Nadu'), findsOneWidget);
    expect(find.text("Women's safety"), findsOneWidget);
    await scrollTo(tester, find.text('Women Helpline'));
    expect(find.text('National helpline'), findsOneWidget);
    expect(find.text('Source verified Sep 1, 2026'), findsOneWidget);
    await scrollTo(tester, find.text('TN State Commission for Women'));
    expect(find.text('Needs verification'), findsOneWidget);
  });

  testWidgets('call, email, website and source open the right links', (
    tester,
  ) async {
    await pumpPage(tester, helpResourcesRoutes());
    final card = find.byKey(const ValueKey('helpRes.1'));
    await scrollTo(tester, card);

    for (final action in ['call', 'email', 'website', 'source']) {
      final button = find.byKey(ValueKey('helpRes.1.$action'));
      await scrollTo(tester, button);
      await tester.tap(button);
      await tester.pumpAndSettle();
    }

    expect(opened, [
      Uri.parse('tel:181'),
      Uri.parse('mailto:help@wcd.example.in'),
      Uri.parse('https://wcd.example.in'),
      Uri.parse('https://wcd.example.in/helplines'),
    ]);
  });

  testWidgets('the emergency note dials 112', (tester) async {
    await pumpPage(tester, helpResourcesRoutes());

    await tester.tap(find.byKey(const ValueKey('helpRes.emergency')));

    expect(opened, [Uri.parse('tel:112')]);
  });

  testWidgets('a link that cannot open is explained', (tester) async {
    await pumpPage(tester, helpResourcesRoutes());
    canOpen = false;
    final call = find.byKey(const ValueKey('helpRes.1.call'));
    await scrollTo(tester, call);

    await tester.tap(call);
    await tester.pumpAndSettle();

    expect(find.text("Couldn't open this on your phone."), findsOneWidget);
  });

  testWidgets('changing the state reloads contacts', (tester) async {
    final routes = helpResourcesRoutes();
    await pumpPage(tester, routes);
    routes['/help-resources'] = {'items': []};

    await tester.tap(find.byKey(const ValueKey('helpRes.state')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Karnataka').last);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'No verified contacts for this choice. Try another kind of help or '
        'state.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('a failure shows Retry, which reloads', (tester) async {
    final routes = helpResourcesRoutes()
      ..['/help-resources/states'] = http.Response('{"message":"x"}', 500);
    await pumpPage(tester, routes);

    routes.addAll(helpResourcesRoutes());
    await tester.tap(find.byKey(const ValueKey('loadState.retry')));
    await tester.pumpAndSettle();

    expect(find.text('Tamil Nadu'), findsOneWidget);
  });

  testWidgets('fits large text on a small phone; Hindi', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpPage(tester, helpResourcesRoutes(), locale: const Locale('hi'));
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('आपातकाल में 112 डायल करें।'), findsOneWidget);
  });

  testWidgets('no matching contacts shows the empty state', (tester) async {
    await pumpPage(tester, helpResourcesRoutes(resources: []));
    await scrollTo(tester, find.byKey(const ValueKey('loadState.empty')));

    expect(find.byKey(const ValueKey('loadState.empty')), findsOneWidget);
  });

  testWidgets('a failed contact list shows Retry, which reloads', (
    tester,
  ) async {
    final routes = helpResourcesRoutes()
      ..['/help-resources'] = http.Response('{}', 500);
    await pumpPage(tester, routes);
    final retry = find.byKey(const ValueKey('loadState.retry'));
    await scrollTo(tester, retry);

    routes.addAll(helpResourcesRoutes());
    await tester.tap(retry);
    await tester.pumpAndSettle();

    await scrollTo(tester, find.text('Women Helpline'));
    expect(find.text('Women Helpline'), findsOneWidget);
  });

  testWidgets('call and 112 are labelled buttons', (tester) async {
    await pumpPage(tester, helpResourcesRoutes());

    expect(
      tester.getSemantics(find.byKey(const ValueKey('helpRes.emergency'))),
      isSemantics(
        isButton: true,
        hasTapAction: true,
        label: 'In an emergency, dial 112.',
      ),
    );
    final call = find.byKey(const ValueKey('helpRes.1.call'));
    await scrollTo(tester, call);
    expect(
      tester.getSemantics(call),
      isSemantics(isButton: true, hasTapAction: true, label: 'Call 181'),
    );
  });
}
