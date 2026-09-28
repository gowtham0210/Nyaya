import '../../../core/presentation/load_state.dart';
import '../../../core/presentation/load_state_notifier.dart';
import '../data/help_resources_repository.dart';

export '../data/help_resources_repository.dart'
    show HelpCategory, HelpOptions, HelpResource, IndianState;

/// Help resources (spec 032): pick a state and a kind of help, see the
/// matching contacts. [state] holds the filter options.
class HelpResourcesViewModel extends LoadStateNotifier<HelpOptions> {
  HelpResourcesViewModel({required HelpResourcesRepository repository})
    : _repository = repository;

  final HelpResourcesRepository _repository;
  var _resourcesLoadId = 0;

  IndianState? get selectedState => _selectedState;
  IndianState? _selectedState;

  HelpCategory? get selectedCategory => _selectedCategory;
  HelpCategory? _selectedCategory;

  /// Contacts for the current filter.
  LoadState<List<HelpResource>> get resources => _resources;
  LoadState<List<HelpResource>> _resources = const Loading();

  @override
  Future<HelpOptions> fetch() => _repository.fetchOptions();

  @override
  bool isEmpty(HelpOptions options) =>
      options.states.isEmpty || options.categories.isEmpty;

  /// Loads the options, then contacts for the first state and category
  /// (or the ones already picked).
  @override
  Future<void> load() async {
    await super.load();
    final options = state;
    if (options is! Loaded<HelpOptions>) {
      return;
    }
    _selectedState ??= options.data.states.first;
    _selectedCategory ??= options.data.categories.first;
    await _loadResources();
  }

  Future<void> selectState(IndianState state) {
    _selectedState = state;
    return _loadResources();
  }

  Future<void> selectCategory(HelpCategory category) {
    _selectedCategory = category;
    return _loadResources();
  }

  /// Reloads contacts; only the latest request's result is kept.
  Future<void> reloadResources() => _loadResources();

  Future<void> _loadResources() async {
    final stateCode = _selectedState?.code;
    final categorySlug = _selectedCategory?.slug;
    if (stateCode == null || categorySlug == null) {
      return;
    }
    final loadId = ++_resourcesLoadId;
    _resources = const Loading();
    notifyIfActive();
    final result = await LoadState.run(
      () =>
          _repository.fetchResources(state: stateCode, category: categorySlug),
      isEmpty: (resources) => resources.isEmpty,
    );
    if (loadId == _resourcesLoadId) {
      _resources = result;
      notifyIfActive();
    }
  }
}
