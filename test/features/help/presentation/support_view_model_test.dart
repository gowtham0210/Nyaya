import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/core/presentation/load_state.dart';
import 'package:nyaya/features/help/data/support_repository.dart';
import 'package:nyaya/features/help/presentation/support_view_model.dart';

import '../../../support/support_backend.dart';

void main() {
  test('no requests is the empty state', () async {
    final backend = FakeSupportBackend();
    final viewModel = SupportViewModel(
      repository: SupportRepository(backend.client),
    );

    await viewModel.load();

    expect(viewModel.state, isA<Empty<List<SupportRequest>>>());
  });

  test('sending adds the request to the list', () async {
    final backend = FakeSupportBackend();
    final viewModel = SupportViewModel(
      repository: SupportRepository(backend.client),
    );
    await viewModel.load();

    final sending = viewModel.send(
      subject: ' Help ',
      message: ' Stuck on OTP ',
    );
    expect(viewModel.sending, isTrue);
    expect(await sending, isTrue);

    expect(viewModel.sending, isFalse);
    final list = (viewModel.state as Loaded<List<SupportRequest>>).data;
    expect(list.single.subject, 'Help');
    expect(list.single.message, 'Stuck on OTP');
  });

  test('a failed send keeps the list and exposes the error', () async {
    final backend = FakeSupportBackend();
    final viewModel = SupportViewModel(
      repository: SupportRepository(backend.client),
    );
    await viewModel.load();
    backend.online = false;

    expect(await viewModel.send(subject: 'Help', message: 'Stuck'), isFalse);

    expect(viewModel.sendError, isA<ApiOfflineException>());
    expect(viewModel.state, isA<Empty<List<SupportRequest>>>());
  });
}
