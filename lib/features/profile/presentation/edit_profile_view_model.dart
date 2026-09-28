import 'package:flutter/foundation.dart';

import '../data/photo_picker.dart';
import '../data/profile_repository.dart';

/// Edit profile (spec 027): saves name and profession, uploads a photo.
class EditProfileViewModel extends ChangeNotifier {
  EditProfileViewModel({
    required ProfileRepository repository,
    required UserProfile profile,
    required VoidCallback onChanged,
  }) : _repository = repository,
       _profile = profile,
       _onChanged = onChanged;

  final ProfileRepository _repository;
  final VoidCallback _onChanged;
  var _disposed = false;

  /// The saved profile; updates after each successful save or upload.
  UserProfile get profile => _profile;
  UserProfile _profile;

  /// True while saving or uploading.
  bool get busy => _busy;
  var _busy = false;

  /// The last failure, cleared when the next attempt starts.
  Object? get error => _error;
  Object? _error;

  /// Saves; true on success. On failure [error] is set and the learner's
  /// edits stay in the form.
  Future<bool> save({required String fullName, required String? profession}) =>
      _run(
        () => _repository.updateProfile(
          fullName: fullName.trim(),
          profession: profession,
        ),
      );

  /// Uploads [photo]; true on success.
  Future<bool> uploadPhoto(PickedPhoto photo) => _run(
    () =>
        _repository.uploadAvatar(bytes: photo.bytes, filename: photo.filename),
  );

  Future<bool> _run(Future<UserProfile> Function() call) async {
    _busy = true;
    _error = null;
    notifyListeners();
    try {
      _profile = await call();
      _onChanged();
      return true;
    } catch (error) {
      _error = error;
      return false;
    } finally {
      _busy = false;
      // The page may close mid-request.
      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
