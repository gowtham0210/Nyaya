import '../network/api_client.dart';

/// What a data screen shows: loading, the data, nothing, or a failure
/// (ADR 0002). View models expose one; `LoadStateView` renders it.
sealed class LoadState<T> {
  const LoadState();

  /// Runs [fetch] and turns its result into [Loaded], [Empty] (when
  /// [isEmpty] says so) or [Failed]. Any error fails the load, so an
  /// unexpected response never leaves a screen stuck on [Loading].
  static Future<LoadState<T>> run<T>(
    Future<T> Function() fetch, {
    required bool Function(T data) isEmpty,
  }) async {
    try {
      final data = await fetch();
      return isEmpty(data) ? Empty<T>() : Loaded<T>(data);
    } catch (error) {
      return Failed<T>(error);
    }
  }
}

final class Loading<T> extends LoadState<T> {
  const Loading();
}

final class Loaded<T> extends LoadState<T> {
  const Loaded(this.data);

  final T data;
}

final class Empty<T> extends LoadState<T> {
  const Empty();
}

final class Failed<T> extends LoadState<T> {
  const Failed(this.error);

  /// Usually an [ApiException]; anything else is an unexpected response.
  final Object error;
}
