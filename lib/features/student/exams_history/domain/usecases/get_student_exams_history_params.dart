class GetStudentExamsHistoryParams {
  final int page;
  final int pageSize;

  const GetStudentExamsHistoryParams({
    required this.page,
    this.pageSize = 20,
  });
}
