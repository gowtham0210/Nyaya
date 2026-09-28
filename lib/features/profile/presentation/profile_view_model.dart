import '../../../core/presentation/load_state_notifier.dart';
import '../data/profile_repository.dart';

export '../data/profile_repository.dart'
    show ProfileOverview, ProfileStats, UserProfile;

/// The Profile tab (spec 021). A profile is never empty.
class ProfileViewModel extends LoadStateNotifier<ProfileOverview> {
  ProfileViewModel({required ProfileRepository repository})
    : _repository = repository;

  final ProfileRepository _repository;

  @override
  Future<ProfileOverview> fetch() => _repository.fetchOverview();

  @override
  bool isEmpty(ProfileOverview overview) => false;
}
