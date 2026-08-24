import "dart:io";

import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/create_question_request_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/create_reply_request_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/question_details_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/question_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/question_paged_result_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/models/reply_model.dart";
import "package:draya_mobile/features/teacher/teacher_channel/data/source/teacher_channel_remote_data_source.dart";
import "package:draya_mobile/features/teacher/teacher_channel/domain/repos/teacher_channel_repo.dart";

class TeacherChannelRepoImpl implements TeacherChannelRepo {
  final TeacherChannelRemoteDataSource _remoteDataSource;

  static const int _maxImageSizeBytes = 5 * 1024 * 1024;
  static const List<String> _allowedImageExtensions = [
    "jpg",
    "jpeg",
    "png",
    "webp",
    "gif",
  ];

  TeacherChannelRepoImpl(this._remoteDataSource);

  @override
  Future<ApiResult<QuestionPagedResultModel>> getQuestions(
    String classroomId, {
    int page = 1,
    int pageSize = 20,
    String sortBy = "recent",
    String filterBy = "all",
  }) => _guard(
    () => _remoteDataSource.getQuestions(
      classroomId,
      page,
      pageSize,
      sortBy,
      filterBy,
    ),
  );

  @override
  Future<ApiResult<QuestionModel>> createQuestion(
    String classroomId,
    CreateQuestionRequestModel request,
  ) => _guard(() => _remoteDataSource.createQuestion(classroomId, request));

  @override
  Future<ApiResult<QuestionModel>> createQuestionWithPhoto(
    String classroomId,
    String content,
    File image,
  ) async {
    final filePart = await _toMultipartFile(image);
    if (filePart.isFailure) {
      return ApiResult.failure(filePart.error!);
    }
    return _guard(() => _remoteDataSource.createQuestionWithPhoto(
          classroomId,
          content.trim(),
          filePart.file!,
        ));
  }

  @override
  Future<ApiResult<QuestionDetailsModel>> getQuestionDetails(
    String classroomId,
    String questionId,
  ) => _guard(
    () => _remoteDataSource.getQuestionDetails(classroomId, questionId),
  );

  @override
  Future<ApiResult<ReplyModel>> createReply(
    String classroomId,
    String questionId,
    CreateReplyRequestModel request,
  ) => _guard(
    () => _remoteDataSource.createReply(classroomId, questionId, request),
  );

  @override
  Future<ApiResult<ReplyModel>> createReplyWithPhoto(
    String classroomId,
    String questionId,
    String content,
    File image,
  ) async {
    final filePart = await _toMultipartFile(image);
    if (filePart.isFailure) {
      return ApiResult.failure(filePart.error!);
    }
    return _guard(() => _remoteDataSource.createReplyWithPhoto(
          classroomId,
          questionId,
          content.trim(),
          filePart.file!,
        ));
  }

  @override
  Future<ApiResult<void>> voteQuestion(
    String classroomId,
    String questionId,
  ) => _guard(() => _remoteDataSource.voteQuestion(classroomId, questionId));

  @override
  Future<ApiResult<void>> unvoteQuestion(
    String classroomId,
    String questionId,
  ) => _guard(() => _remoteDataSource.unvoteQuestion(classroomId, questionId));

  Future<_ImagePartResult> _toMultipartFile(File image) async {
    if (!await image.exists()) {
      return _ImagePartResult.failure("الملف المرفق غير موجود");
    }
    final extension = image.path.split(".").last.toLowerCase();
    if (!_allowedImageExtensions.contains(extension)) {
      return _ImagePartResult.failure(
        "صيغة الصورة غير مدعومة. المسموح: JPG و PNG و WEBP و GIF",
      );
    }
    final imageSize = await image.length();
    if (imageSize > _maxImageSizeBytes) {
      return _ImagePartResult.failure("حجم الصورة يجب ألا يتجاوز 5 ميجابايت");
    }
    try {
      final file = await MultipartFile.fromFile(
        image.path,
        filename:
            "channel_image_${DateTime.now().millisecondsSinceEpoch}.$extension",
        contentType: DioMediaType("image", extension == "jpg"
            ? "jpeg"
            : extension),
      );
      return _ImagePartResult.success(file);
    } catch (_) {
      return _ImagePartResult.failure("تعذر قراءة الصورة، حاول مجدداً");
    }
  }

  Future<ApiResult<T>> _guard<T>(Future<T> Function() request) async {
    try {
      return ApiResult.success(await request());
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}

class _ImagePartResult {
  final MultipartFile? file;
  final ApiErrorModel? error;

  const _ImagePartResult._(this.file, this.error);

  bool get isFailure => file == null;

  factory _ImagePartResult.success(MultipartFile file) =>
      _ImagePartResult._(file, null);

  factory _ImagePartResult.failure(String message) => _ImagePartResult._(
        null,
        ApiErrorModel(
          retry: false,
          error: ErrorModel(message: message),
        ),
      );
}
