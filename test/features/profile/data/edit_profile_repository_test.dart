import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/profile/data/profile_repository.dart';

void main() {
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
      bytes: [1, 2, 3],
      filename: 'me.jpg',
    );

    expect(sent.method, 'POST');
    expect(sent.url.path, '/api/v1/users/me/avatar');
    expect(sent.headers['content-type'], startsWith('multipart/form-data'));
    expect(latin1.decode(sent.bodyBytes), contains('name="avatar"'));
    expect(latin1.decode(sent.bodyBytes), contains('filename="me.jpg"'));
    expect(profile.avatarUrl, endsWith('/uploads/7.jpg'));
  });
}
