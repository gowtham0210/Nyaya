/// The Profile screen's "My Statistics" tile values — assembled from three
/// real backend endpoints (GET /users/me/progress, /users/me/streak,
/// /users/me/categories-explored). No invented numbers: a user who hasn't
/// taken any quizzes yet genuinely sees zeros here.
class ProfileStats {
  const ProfileStats({
    required this.categoriesExplored,
    required this.topicsCompleted,
    required this.pointsEarned,
    required this.dayStreak,
  });

  final int categoriesExplored;
  final int topicsCompleted;
  final int pointsEarned;
  final int dayStreak;
}
