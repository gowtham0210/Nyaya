import 'package:image_picker/image_picker.dart';

/// Where the learner takes a profile photo from.
enum PhotoSource { camera, gallery }

/// A picked photo, ready to upload.
class PickedPhoto {
  const PickedPhoto({required this.bytes, required this.filename});

  final List<int> bytes;
  final String filename;
}

/// Picks a photo, or null when the learner cancels. Tests pass a fake.
typedef PhotoPicker = Future<PickedPhoto?> Function(PhotoSource source);

/// The device picker, resized for an avatar.
Future<PickedPhoto?> pickWithImagePicker(PhotoSource source) async {
  final file = await ImagePicker().pickImage(
    source: source == PhotoSource.camera
        ? ImageSource.camera
        : ImageSource.gallery,
    maxWidth: 1024,
    maxHeight: 1024,
    imageQuality: 85,
  );
  if (file == null) {
    return null;
  }
  return PickedPhoto(bytes: await file.readAsBytes(), filename: file.name);
}
