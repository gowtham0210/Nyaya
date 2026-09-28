import 'package:flutter/foundation.dart';

import 'load_state.dart';

/// A view model that loads one [LoadState] (ADR 0002). Subclasses say how
/// to [fetch] and when the result [isEmpty]; pages call [load] and listen.
abstract class LoadStateNotifier<T> extends ChangeNotifier {
  var _disposed = false;
  var _loadId = 0;
  Future<void>? _firstLoad;
  var _started = false;

  LoadState<T> get state => _state;
  LoadState<T> _state = const Loading();

  @protected
  Future<T> fetch();

  @protected
  bool isEmpty(T data);

  /// Loads once for screens that share this view model; later calls reuse
  /// the first load. Use [load] to refresh or retry.
  Future<void> ensureLoaded() => _firstLoad ??= load();

  /// Reloads only if something has loaded before, e.g. after the language
  /// changes; screens not opened yet load fresh when they open.
  Future<void> reloadIfStarted() async {
    if (_started) {
      await load();
    }
  }

  /// Loads the data. When loads overlap (Retry during a load), only the
  /// latest one's result is kept.
  Future<void> load() async {
    _started = true;
    final loadId = ++_loadId;
    _setState(const Loading());
    final result = await LoadState.run(fetch, isEmpty: isEmpty);
    if (loadId == _loadId) {
      _setState(result);
    }
  }

  void _setState(LoadState<T> state) {
    if (_disposed) {
      return;
    }
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
