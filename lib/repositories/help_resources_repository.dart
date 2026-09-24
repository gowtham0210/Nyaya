import '../models/help_resource.dart';
import '../services/api_exceptions.dart';
import '../services/auth_storage.dart';
import '../services/help_resources_api_service.dart';

/// Source of truth for the Help & Resources screen, backed entirely by the
/// backend directory — never returns invented contacts.
class HelpResourcesRepository {
  HelpResourcesRepository({HelpResourcesApiService? api, AuthStorage? authStorage})
      : _api = api ?? HelpResourcesApiService(),
        _authStorage = authStorage ?? AuthStorage();

  final HelpResourcesApiService _api;
  final AuthStorage _authStorage;

  Future<String> _token() async {
    final token = await _authStorage.readToken();
    if (token == null) throw UnauthenticatedException();
    return token;
  }

  Future<List<IndianState>> getStates() async => _api.fetchStates(await _token());

  Future<List<SupportCategory>> getCategories() async => _api.fetchCategories(await _token());

  Future<List<HelpResource>> getResources({required String stateCode, required String categorySlug}) async =>
      _api.fetchResources(await _token(), stateCode: stateCode, categorySlug: categorySlug);
}
