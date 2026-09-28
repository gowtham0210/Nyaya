import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/show_message.dart';
import '../../../core/presentation/widgets/initials_avatar.dart';
import '../../../core/presentation/widgets/load_state_view.dart';
import '../../auth/presentation/name_validation.dart';
import '../../auth/presentation/profession.dart';
import '../data/photo_picker.dart';
import 'edit_profile_view_model.dart';

const _pageBackground = Color(0xFFF8F6F2);
const _navy = Color(0xFF11233B);
const _danger = Color(0xFFD64545);

/// Edit name, profession and photo (spec 027). Saving closes the page;
/// a failure keeps the edits and shows why.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.viewModel,
    required this.pickPhoto,
  });

  final EditProfileViewModel viewModel;
  final PhotoPicker pickPhoto;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: widget.viewModel.profile.fullName,
  );
  late Profession? _profession = Profession.fromValue(
    widget.viewModel.profile.profession,
  );

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final saved = await widget.viewModel.save(
      fullName: _nameController.text,
      profession: _profession?.value,
    );
    // The learner may have left while saving.
    if (saved && mounted) {
      navigator.pop();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.editProfileSaved)));
    }
  }

  Future<void> _changePhoto() async {
    final l10n = context.l10n;
    final source = await showModalBottomSheet<PhotoSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.editProfileCamera),
              onTap: () => Navigator.of(sheetContext).pop(PhotoSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.editProfileGallery),
              onTap: () => Navigator.of(sheetContext).pop(PhotoSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) {
      return;
    }
    final PickedPhoto? photo;
    try {
      photo = await widget.pickPhoto(source);
    } catch (_) {
      // Usually a denied camera or photos permission.
      if (mounted) {
        showMessage(context, l10n.editProfilePhotoFailed);
      }
      return;
    }
    if (photo == null || !mounted) {
      return;
    }
    if (await widget.viewModel.uploadPhoto(photo) && mounted) {
      showMessage(context, l10n.editProfilePhotoUpdated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        backgroundColor: _pageBackground,
        foregroundColor: _navy,
        surfaceTintColor: Colors.transparent,
        title: Text(l10n.profileEdit),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          final viewModel = widget.viewModel;
          final profile = viewModel.profile;
          final error = viewModel.error;
          final phone = profile.phone;
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      InitialsAvatar(
                        name: profile.fullName,
                        avatarUrl: profile.avatarUrl,
                        size: 96,
                      ),
                      if (viewModel.uploading)
                        const CircularProgressIndicator(
                          key: ValueKey('editProfile.uploading'),
                        ),
                    ],
                  ),
                ),
                Center(
                  child: TextButton.icon(
                    key: const ValueKey('editProfile.photo'),
                    onPressed: viewModel.busy ? null : _changePhoto,
                    icon: const Icon(Icons.photo_camera_outlined, size: 18),
                    label: Text(l10n.editProfileChangePhoto),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const ValueKey('editProfile.name'),
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.fieldFullNameLabel,
                  ),
                  validator: (value) => validateFullName(l10n, value),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Profession>(
                  key: const ValueKey('editProfile.profession'),
                  initialValue: _profession,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: l10n.fieldProfessionLabel,
                  ),
                  items: [
                    for (final profession in Profession.values)
                      DropdownMenuItem(
                        value: profession,
                        child: Text(profession.label(l10n)),
                      ),
                  ],
                  onChanged: (value) => setState(() => _profession = value),
                ),
                if (phone != null) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: phone,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: l10n.fieldPhoneLabel,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                if (error != null) ...[
                  Text(
                    failureMessage(l10n, error),
                    key: const ValueKey('editProfile.error'),
                    style: const TextStyle(color: _danger, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                ],
                FilledButton(
                  key: const ValueKey('editProfile.save'),
                  onPressed: viewModel.busy ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: _navy,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: viewModel.saving
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.editProfileSave),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
