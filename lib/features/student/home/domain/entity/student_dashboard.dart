class StudentDashboard {
  final double overallAverage;
  final int completedLessonsCount;
  final int subscribedPackagesCount;
  final List<String> urgentAlerts;
  final List<DailyLesson> dailyLessons;
  final List<UpcomingExam> upcomingExams;
  final List<PointNeedingFocus> pointsNeedingFocus;
  final DateTime? lastActivityDate;
  final int currentStreak;

  const StudentDashboard({
    required this.overallAverage,
    required this.completedLessonsCount,
    required this.subscribedPackagesCount,
    required this.urgentAlerts,
    required this.dailyLessons,
    required this.upcomingExams,
    required this.pointsNeedingFocus,
    this.lastActivityDate,
    required this.currentStreak,
  });
}

class DailyLesson {
  final String materialId;
  final String title;
  final int completedLectures;
  final int totalLectures;

  const DailyLesson({
    required this.materialId,
    required this.title,
    required this.completedLectures,
    required this.totalLectures,
  });

  double get progress =>
      totalLectures > 0 ? (completedLectures / totalLectures).clamp(0.0, 1.0) : 0.0;
}

class UpcomingExam {
  final String examId;
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;

  const UpcomingExam({
    required this.examId,
    required this.title,
    this.startDate,
    this.endDate,
  });
}

class PointNeedingFocus {
  final String topicName;
  final double proficiencyPercent;

  const PointNeedingFocus({
    required this.topicName,
    required this.proficiencyPercent,
  });
}
