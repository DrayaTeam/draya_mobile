import 'package:dio/dio.dart';
import 'package:draya_mobile/core/networking/api_constants.dart';
import 'package:draya_mobile/features/teacher/subjects/data/models/add_subject_request_model.dart';
import 'package:draya_mobile/features/teacher/subjects/data/models/subject_model.dart';
import 'package:draya_mobile/features/teacher/subjects/data/source/subject_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part "subject_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class SubjectApiService {
  factory SubjectApiService(Dio dio) = _SubjectApiService;

  @GET(SubjectApiConstants.subjects)
  Future<List<SubjectModel>> getSubjects();

  @POST(SubjectApiConstants.subjects)
  Future<SubjectModel> addSubject(
    @Body() AddSubjectRequestModel addSubjectRequestModel,
  );
}
