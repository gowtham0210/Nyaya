import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/profile/data/photo_picker.dart';
import 'package:nyaya/features/profile/data/profile_repository.dart';

import '../../../support/fake_backend.dart';
import '../../../support/profile_backend.dart';

void main() {
  test('AC-001 maps the profile and its stats', () async {
    final repository = ProfileRepository(
      fakeBackend(profileRoutes(avatarUrl: '/uploads/7.png')),
    );

    final overview = await repository.fetchOverview();

    expect(overview.profile.fullName, 'Asha Rao');
    expect(overview.profile.profession, 'Law Student');
    expect(overview.profile.phone, '+919800000000');
    expect(overview.profile.avatarUrl, endsWith(':5000/uploads/7.png'));
    expect(overview.stats.streak, 4);
    expect(overview.stats.categoriesExplored, 3);
    expect(overview.stats.quizzesCompleted, 9);
    expect(overview.stats.points, 320);
  });

  test('AC-001 no photo or profession is null', () async {
    final repository = ProfileRepository(
      fakeBackend(profileRoutes(profession: null)),
    );

    final profile = (await repository.fetchOverview()).profile;

    expect(profile.avatarUrl, isNull);
    expect(profile.profession, isNull);
  });

  test('AC-001 any failing endpoint fails the load', () async {
    final routes = profileRoutes()
      ..['/users/me/streak'] = http.Response('{"message":"boom"}', 500);
    final repository = ProfileRepository(fakeBackend(routes));

    expect(repository.fetchOverview(), throwsA(isA<ApiServerException>()));
  });

  test('AC-001 photo paths resolve with or without a slash', () async {
    for (final path in ['/uploads/7.png', 'uploads/7.png']) {
      final repository = ProfileRepository(
        fakeBackend(profileRoutes(avatarUrl: path)),
      );

      final url = (await repository.fetchOverview()).profile.avatarUrl;

      expect(url, endsWith(':5000/uploads/7.png'), reason: path);
    }
    final absolute = ProfileRepository(
      fakeBackend(profileRoutes(avatarUrl: 'https://cdn.example/7.png')),
    );
    expect(
      (await absolute.fetchOverview()).profile.avatarUrl,
      'https://cdn.example/7.png',
    );
  });

  test('updateProfile PATCHes name and profession', () async {
    late http.Request sent;
    final repository = ProfileRepository(
      ApiClient(
        httpClient: MockClient((request) async {
          sent = request;
          return http.Response(
            '{"id":7,"fullName":"Asha R","profession":"Lawyer / Advocate"}',
            200,
          );
        }),
      ),
    );

    final profile = await repository.updateProfile(
      fullName: 'Asha R',
      profession: 'Lawyer / Advocate',
    );

    expect(sent.method, 'PATCH');
    expect(sent.url.path, '/api/v1/users/me');
    expect(jsonDecode(sent.body), {
      'fullName': 'Asha R',
      'profession': 'Lawyer / Advocate',
    });
    expect(profile.fullName, 'Asha R');
    expect(profile.profession, 'Lawyer / Advocate');
  });

  test('uploadAvatar posts the photo as multipart "avatar"', () async {
    late http.Request sent;
    final repository = ProfileRepository(
      ApiClient(
        httpClient: MockClient((request) async {
          sent = request;
          return http.Response(
            '{"id":7,"fullName":"Asha","avatarUrl":"/uploads/7.jpg"}',
            200,
          );
        }),
      ),
    );

    final profile = await repository.uploadAvatar(
      const PickedPhoto(bytes: [1, 2, 3], filename: 'me.jpg'),
    );

    expect(sent.method, 'POST');
    expect(sent.url.path, '/api/v1/users/me/avatar');
    expect(sent.headers['content-type'], startsWith('multipart/form-data'));
    expect(latin1.decode(sent.bodyBytes), contains('name="avatar"'));
    expect(latin1.decode(sent.bodyBytes), contains('filename="me.jpg"'));
    expect(profile.avatarUrl, endsWith('/uploads/7.jpg'));
  });
}
