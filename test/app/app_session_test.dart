import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/app_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppSession.clear();
  });

  test('a fresh install is not onboarded', () async {
    await AppSession.load();

    expect(AppSession.signedIn, isFalse);
    expect(AppSession.selectedGoalId, isNull);
    expect(AppSession.isOnboarded, isFalse);
  });

  test('sign-up alone is not enough to skip onboarding', () async {
    await AppSession.saveSignedIn();

    expect(AppSession.isOnboarded, isFalse);
  });

  test('sign-up plus a saved goal survives a reload', () async {
    await AppSession.saveSignedIn();
    await AppSession.saveGoal('learn-law-for-life');

    AppSession.signedIn = false;
    AppSession.selectedGoalId = null;
    await AppSession.load();

    expect(AppSession.signedIn, isTrue);
    expect(AppSession.selectedGoalId, 'learn-law-for-life');
    expect(AppSession.isOnboarded, isTrue);
  });

  test('clear resets the session', () async {
    await AppSession.saveSignedIn();
    await AppSession.saveGoal('study-law');

    await AppSession.clear();
    await AppSession.load();

    expect(AppSession.isOnboarded, isFalse);
  });
}
