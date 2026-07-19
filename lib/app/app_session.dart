import 'package:shared_preferences/shared_preferences.dart';

/// Locally persisted session: whether the user finished sign-up and which
/// goal they chose. Stands in until a real auth backend exists.
class AppSession {
  AppSession._();

  static const _signedInKey = 'session.signedIn';
  static const _goalIdKey = 'session.goalId';

  static bool signedIn = false;
  static String? selectedGoalId;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    signedIn = prefs.getBool(_signedInKey) ?? false;
    selectedGoalId = prefs.getString(_goalIdKey);
  }

  static Future<void> saveSignedIn() async {
    signedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_signedInKey, true);
  }

  static Future<void> saveGoal(String goalId) async {
    selectedGoalId = goalId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_goalIdKey, goalId);
  }

  static Future<void> clear() async {
    signedIn = false;
    selectedGoalId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_signedInKey);
    await prefs.remove(_goalIdKey);
  }

  /// The user lands on home directly when both steps are complete.
  static bool get isOnboarded => signedIn && selectedGoalId != null;
}
