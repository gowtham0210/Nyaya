import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/core/presentation/load_state.dart';
import 'package:nyaya/core/presentation/load_state_notifier.dart';

class _Counter extends LoadStateNotifier<int> {
  var fetches = 0;

  @override
  Future<int> fetch() async => ++fetches;

  @override
  bool isEmpty(int data) => false;
}

void main() {
  test('ensureLoaded fetches once', () async {
    final notifier = _Counter();

    await notifier.ensureLoaded();
    await notifier.ensureLoaded();

    expect(notifier.fetches, 1);
  });

  test('reloadIfStarted skips a notifier that never loaded', () async {
    final notifier = _Counter();

    await notifier.reloadIfStarted();

    expect(notifier.fetches, 0);
    expect(notifier.state, isA<Loading<int>>());
  });

  test('reloadIfStarted refetches a loaded notifier', () async {
    final notifier = _Counter();
    await notifier.ensureLoaded();

    await notifier.reloadIfStarted();

    expect(notifier.fetches, 2);
    expect((notifier.state as Loaded<int>).data, 2);
  });
}
