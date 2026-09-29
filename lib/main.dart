import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/app_session.dart';
import 'app/leaderboard_progress_store.dart';
import 'app/notifications_store.dart';
import 'app/quiz_history_store.dart';
import 'app/quiz_progress_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSession.load();
  await QuizProgressStore.load();
  await QuizHistoryStore.load();
  await NotificationsStore.load();
  await LeaderboardProgressStore.load();

  runApp(const NyayaApp());
}
