import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/student/student_materials/domain/entity/classroom_section.dart";
import "package:draya_mobile/features/student/student_materials/domain/entity/student_material.dart";

class StudentMaterialsState {
  final CubitStatus materialsStatus;
  final CubitStatus sectionsStatus;
  final CubitStatus openingStatus;
  final List<StudentMaterial> materials;
  final List<ClassroomSection> sections;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;
  final String? openingMaterialId;
  final String? openUrl;
  final ApiErrorModel? apiErrorModel;

  const StudentMaterialsState({
    this.materialsStatus = CubitStatus.initial,
    this.sectionsStatus = CubitStatus.initial,
    this.openingStatus = CubitStatus.initial,
    this.materials = const [],
    this.sections = const [],
    this.pageNumber = 1,
    this.pageSize = 20,
    this.totalCount = 0,
    this.totalPages = 0,
    this.hasNextPage = false,
    this.openingMaterialId,
    this.openUrl,
    this.apiErrorModel,
  });

  StudentMaterialsState copyWith({
    CubitStatus? materialsStatus,
    CubitStatus? sectionsStatus,
    CubitStatus? openingStatus,
    List<StudentMaterial>? materials,
    List<ClassroomSection>? sections,
    int? pageNumber,
    int? pageSize,
    int? totalCount,
    int? totalPages,
    bool? hasNextPage,
    String? openingMaterialId,
    String? openUrl,
    ApiErrorModel? apiErrorModel,
    bool clearOpeningMaterialId = false,
    bool clearOpenUrl = false,
    bool clearError = false,
  }) {
    return StudentMaterialsState(
      materialsStatus: materialsStatus ?? this.materialsStatus,
      sectionsStatus: sectionsStatus ?? this.sectionsStatus,
      openingStatus: openingStatus ?? this.openingStatus,
      materials: materials ?? this.materials,
      sections: sections ?? this.sections,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      openingMaterialId: clearOpeningMaterialId
          ? null
          : openingMaterialId ?? this.openingMaterialId,
      openUrl: clearOpenUrl ? null : openUrl ?? this.openUrl,
      apiErrorModel: clearError ? null : apiErrorModel ?? this.apiErrorModel,
    );
  }
}
