abstract final class ReportsApiConstants {
  static const String studentId = "studentId";
  static const String performanceReports =
      "/students/{$studentId}/performance-reports/latest";
  static const String reportId = "reportId";
  static const String approveReport = "/Reports/{$reportId}/approve";
}
