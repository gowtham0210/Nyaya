import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:nyaya/core/presentation/load_state.dart';
import 'package:nyaya/features/profile/data/profile_repository.dart';
import 'package:nyaya/features/profile/presentation/profile_view_model.dart';

import '../../../support/fake_backend.dart';
import '../../../support/profile_backend.dart';

void main() {
  test('AC-002 loading then loaded', () async {
    final viewModel = ProfileViewModel(
      repository: ProfileRepository(fakeBackend(profileRoutes())),
    );

    final loading = viewModel.load();
    expect(viewModel.state, isA<Loading<ProfileOverview>>());
    await loading;

    final overview = (viewModel.state as Loaded<ProfileOverview>).data;
    expect(overview.profile.fullName, 'Asha Rao');
  });

  test('AC-002 a failure is the error state and load() recovers', () async {
    final routes = profileRoutes()
      ..['/users/me'] = http.Response('{"message":"boom"}', 500);
    final viewModel = ProfileViewModel(
      repository: ProfileRepository(fakeBackend(routes)),
    );

    await viewModel.load();
    expect(viewModel.state, isA<Failed<ProfileOverview>>());

    routes.addAll(profileRoutes());
    await viewModel.load();
    expect(viewModel.state, isA<Loaded<ProfileOverview>>());
  });
}
