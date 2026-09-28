import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/profile/data/photo_picker.dart';
import 'package:nyaya/features/profile/data/profile_repository.dart';
import 'package:nyaya/features/profile/presentation/edit_profile_page.dart';
import 'package:nyaya/features/profile/presentation/edit_profile_view_model.dart';

import '../../../support/localized_app.dart';

const asha = UserProfile(
  fullName: 'Asha Rao',
  phone: '+919800000000',
  profession: 'Law Student',
);

void main() {
  late List<http.Request> requests;
  late bool online;
  late int changes;

  Future<void> pumpPage(
    WidgetTester tester, {
    PhotoPicker? pickPhoto,
    Locale locale = const Locale('en'),
  }) async {
    requests = [];
    online = true;
    changes = 0;
    final viewModel = EditProfileViewModel(
      repository: ProfileRepository(
        ApiClient(
          httpClient: MockClient((request) async {
            requests.add(request);
            if (!online) {
              throw http.ClientException('offline');
            }
            return request.url.path.endsWith('/avatar')
                ? http.Response(
                    '{"fullName":"Asha Rao","avatarUrl":"/u/7.jpg"}',
                    200,
                  )
                : http.Response(request.body, 200);
          }),
        ),
      ),
      profile: asha,
      onChanged: () => changes++,
    );
    addTearDown(viewModel.dispose);
    await pumpLocalized(
      tester,
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => EditProfilePage(
                      viewModel: viewModel,
                      pickPhoto: pickPhoto ?? (_) async => null,
                    ),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
      locale: locale,
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Finder nameField() => find.byKey(const ValueKey('editProfile.name'));

  testWidgets('pre-fills current values; phone is read-only', (tester) async {
    await pumpPage(tester);

    expect(
      tester.widget<TextFormField>(nameField()).controller!.text,
      'Asha Rao',
    );
    expect(find.text('Law Student'), findsOneWidget);
    expect(find.text('+919800000000'), findsOneWidget);
  });

  testWidgets('saving sends the edits, then closes with a message', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.enterText(nameField(), 'Asha R');
    await tester.tap(find.byKey(const ValueKey('editProfile.profession')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lawyer / Advocate').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('editProfile.save')));
    await tester.pumpAndSettle();

    expect(jsonDecode(requests.single.body), {
      'fullName': 'Asha R',
      'profession': 'Lawyer / Advocate',
    });
    expect(changes, 1);
    expect(find.byType(EditProfilePage), findsNothing);
    expect(find.text('Profile updated'), findsOneWidget);
  });

  testWidgets('an invalid name is not sent', (tester) async {
    await pumpPage(tester);

    await tester.enterText(nameField(), 'A');
    await tester.tap(find.byKey(const ValueKey('editProfile.save')));
    await tester.pumpAndSettle();

    expect(find.text('Name must be at least 3 characters'), findsOneWidget);
    expect(requests, isEmpty);
  });

  testWidgets('a failed save shows the error and keeps the edits', (
    tester,
  ) async {
    await pumpPage(tester);
    online = false;

    await tester.enterText(nameField(), 'Asha Edited');
    await tester.tap(find.byKey(const ValueKey('editProfile.save')));
    await tester.pumpAndSettle();

    expect(
      find.text(
        "Can't reach the Nyaya server. Check your connection and try again.",
      ),
      findsOneWidget,
    );
    expect(
      tester.widget<TextFormField>(nameField()).controller!.text,
      'Asha Edited',
    );
    expect(find.byType(EditProfilePage), findsOneWidget);
  });

  testWidgets('a photo from the gallery uploads', (tester) async {
    final sources = <PhotoSource>[];
    await pumpPage(
      tester,
      pickPhoto: (source) async {
        sources.add(source);
        return const PickedPhoto(bytes: [1, 2], filename: 'me.jpg');
      },
    );

    await tester.tap(find.byKey(const ValueKey('editProfile.photo')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose from gallery'));
    await tester.pumpAndSettle();

    expect(sources, [PhotoSource.gallery]);
    expect(requests.single.url.path, endsWith('/users/me/avatar'));
    expect(changes, 1);
    expect(find.text('Photo updated'), findsOneWidget);
  });

  testWidgets('cancelling the picker uploads nothing', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.byKey(const ValueKey('editProfile.photo')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Take a photo'));
    await tester.pumpAndSettle();

    expect(requests, isEmpty);
  });

  testWidgets('strings are in Hindi', (tester) async {
    await pumpPage(tester, locale: const Locale('hi'));

    expect(find.text('बदलाव सहेजें'), findsOneWidget);
  });
}
