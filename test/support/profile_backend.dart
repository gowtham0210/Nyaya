/// Canned backend routes for a signed-in learner's profile and stats.
Map<String, Object> profileRoutes({
  String fullName = 'Asha Rao',
  String? profession = 'Law Student',
  String? avatarUrl,
  int streak = 4,
}) => {
  '/users/me': {
    'id': 7,
    'fullName': fullName,
    'email': 'asha@example.com',
    'phone': '+919800000000',
    'profession': ?profession,
    'avatarUrl': ?avatarUrl,
    'status': 'active',
  },
  '/users/me/progress': {
    'totalQuizzesAttempted': 12,
    'totalQuizzesCompleted': 9,
    'totalPoints': 320,
    'accuracyPercentage': 80,
  },
  '/users/me/streak': {'currentStreak': streak, 'maxStreak': 6},
  '/users/me/categories-explored': {'categoriesExplored': 3},
  '/users/me/security': {'activeSessions': 2},
  '/users/me/logout-all': <String, Object>{},
};
