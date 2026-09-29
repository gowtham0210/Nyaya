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
  });

  test('a session with no access token is not onboarded', () async {
    // What a session stored before the app had real auth looks like: the
    // flags are set, but there is no token to call the backend with.
    await AppSession.saveSignedIn();
    await AppSession.saveGoal('learn-law-for-life');

    expect(AppSession.accessToken, isNull);
    expect(AppSession.isOnboarded, isFalse);
  });

  test('a signed-in session with a goal and a token is onboarded', () async {
    await AppSession.saveAuthSession(
      fullName: 'Asha Rao',
      email: 'asha@example.com',
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
    );
    await AppSession.saveGoal('learn-law-for-life');

    expect(AppSession.isOnboarded, isTrue);
  });

  test('clear resets the session', () async {
    await AppSession.saveSignedIn();
    await AppSession.saveGoal('study-law');

    await AppSession.clear();
    await AppSession.load();

    expect(AppSession.isOnboarded, isFalse);
  });

  test('a saved profile survives a reload', () async {
    await AppSession.saveProfile(
      fullName: 'Priya Sharma',
      email: 'priya@example.com',
    );

    AppSession.fullName = null;
    AppSession.email = null;
    await AppSession.load();

    expect(AppSession.fullName, 'Priya Sharma');
    expect(AppSession.email, 'priya@example.com');
  });

  test('clear resets the saved profile', () async {
    await AppSession.saveProfile(
      fullName: 'Priya Sharma',
      email: 'priya@example.com',
    );

    await AppSession.clear();
    await AppSession.load();

    expect(AppSession.fullName, isNull);
    expect(AppSession.email, isNull);
  });
}
