import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/profile/data/photo_picker.dart';
import 'package:nyaya/features/profile/data/profile_repository.dart';
import 'package:nyaya/features/profile/presentation/edit_profile_view_model.dart';

const asha = UserProfile(fullName: 'Asha Rao', profession: 'Law Student');

EditProfileViewModel viewModelWith(
  Future<http.Response> Function(http.Request) handler, {
  void Function()? onChanged,
}) => EditProfileViewModel(
  repository: ProfileRepository(ApiClient(httpClient: MockClient(handler))),
  profile: asha,
  onChanged: onChanged ?? () {},
);

void main() {
  test('save stores the new profile and reports the change', () async {
    var changed = 0;
    final viewModel = viewModelWith(
      (_) async => http.Response(
        '{"fullName":"Asha R","profession":"Lawyer / Advocate"}',
        200,
      ),
      onChanged: () => changed++,
    );

    final saving = viewModel.save(
      fullName: '  Asha R ',
      profession: 'Lawyer / Advocate',
    );
    expect(viewModel.busy, isTrue);
    expect(await saving, isTrue);

    expect(viewModel.busy, isFalse);
    expect(viewModel.error, isNull);
    expect(viewModel.profile.fullName, 'Asha R');
    expect(changed, 1);
  });

  test('a failed save keeps the old profile and exposes the error', () async {
    var changed = 0;
    final viewModel = viewModelWith(
      (_) async => throw http.ClientException('offline'),
      onChanged: () => changed++,
    );

    expect(await viewModel.save(fullName: 'Asha R', profession: null), isFalse);

    expect(viewModel.error, isA<ApiOfflineException>());
    expect(viewModel.profile.fullName, 'Asha Rao');
    expect(changed, 0);
  });

  test('uploading a photo updates the avatar', () async {
    final viewModel = viewModelWith(
      (_) async =>
          http.Response('{"fullName":"Asha Rao","avatarUrl":"/u/7.jpg"}', 200),
    );

    final ok = await viewModel.uploadPhoto(
      const PickedPhoto(bytes: [1], filename: 'me.jpg'),
    );

    expect(ok, isTrue);
    expect(viewModel.profile.avatarUrl, endsWith('/u/7.jpg'));
  });

  test('a new attempt clears the last error', () async {
    var fail = true;
    final viewModel = viewModelWith((_) async {
      if (fail) {
        throw http.ClientException('offline');
      }
      return http.Response('{"fullName":"Asha"}', 200);
    });

    await viewModel.save(fullName: 'Asha', profession: null);
    fail = false;
    await viewModel.save(fullName: 'Asha', profession: null);

    expect(viewModel.error, isNull);
  });
}
