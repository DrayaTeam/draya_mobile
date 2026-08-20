import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/features/student/teachers/data/models/teacher_model.dart";
import "package:draya_mobile/features/student/teachers/presentation/cubit/teacher_cubit.dart";
import "package:draya_mobile/features/student/teachers/presentation/cubit/teacher_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "teacher_card_item.dart";

class BrowseTeachersBody extends StatefulWidget {
  const BrowseTeachersBody({super.key});

  @override
  State<BrowseTeachersBody> createState() => _BrowseTeachersBodyState();
}

class _BrowseTeachersBodyState extends State<BrowseTeachersBody> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialization = "كل التخصصات";

  @override
  void initState() {
    super.initState();
    context.read<TeacherCubit>().getTeachers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSpecializationSelected(String specialization) {
    setState(() {
      _selectedSpecialization = specialization;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == CubitStatus.error,
      listener: (context, state) {
        if (state.apiErrorModel != null) {
          showDialog(
            context: context,
            builder: (_) => AppErrorDialog(
              apiErrorModel: state.apiErrorModel!,
              onRetry: () => context.read<TeacherCubit>().getTeachers(),
            ),
          );
        }
      },
      builder: (context, state) {
        final teachers = state.teachers;
        final specializations = [
          "كل التخصصات",
          ...teachers
              .where((teacher) => teacher.specialization != null)
              .map((teacher) => teacher.specialization!)
              .toSet(),
        ];
        final filteredTeachers = _filterTeachers(teachers);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s16,
              vertical: AppSizes.s12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "المعلمون المتاحون",
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary200,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "${teachers.length} معلم",
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "تصفح المعلمين المتاحين واكتشف فصولهم الدراسية للتسجيل بها.",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextFormField(
                        controller: _searchController,
                        hintText: "ابحث باسم المعلم أو التخصص...",
                        prefixIcon: Icons.search_rounded,
                        onChanged: _onSearchChanged,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: specializations.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final specialization = specializations[index];
                            final isSelected =
                                specialization == _selectedSpecialization;
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () =>
                                    _onSpecializationSelected(specialization),
                                borderRadius: BorderRadius.circular(20),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.backgroundSecondary,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.border,
                                      width: 1,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.2),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      specialization,
                                      style: AppTextStyles.label.copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.foregroundMuted,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: state.status == CubitStatus.loading && teachers.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : state.status == CubitStatus.error && teachers.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.error_outline_rounded,
                                    color: AppColors.error,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  "تعذر تحميل قائمة المعلمين",
                                  style: AppTextStyles.h5.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "يرجى التحقق من اتصالك والمحاولة مرة أخرى.",
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () => context
                                      .read<TeacherCubit>()
                                      .getTeachers(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.refresh_rounded, size: 18),
                                  label: Text(
                                    "إعادة المحاولة",
                                    style: AppTextStyles.button.copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : filteredTeachers.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person_search_rounded,
                                    color: AppColors.primary,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  "لا يوجد معلمون مطابقون للبحث",
                                  style: AppTextStyles.h5.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "جرب البحث باسم آخر أو تغيير فلتر التخصص.",
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: () =>
                              context.read<TeacherCubit>().getTeachers(),
                          child: ListView.builder(
                            itemCount: filteredTeachers.length,
                            padding: const EdgeInsets.only(bottom: 24),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final teacher = filteredTeachers[index];
                              final card = TeacherCardItem(
                                fullName: teacher.fullName ?? "غير معروف",
                                email: teacher.email ?? "",
                                phone: teacher.phone ?? "",
                                specialization:
                                    teacher.specialization ?? "عام",
                                imageUrl: teacher.profilePictureUrl,
                                onViewClassrooms: () {
                                  final teacherId = teacher.userId;
                                  if (teacherId == null ||
                                      teacherId.trim().isEmpty) {
                                    return;
                                  }

                                  context.push(
                                    AppRoutes.teacherClassroomsPage(
                                      teacherId,
                                    ),
                                    extra: teacher,
                                  );
                                },
                              );

                              if (index < 6) {
                                return FadeInUp(
                                  delay: index * 50,
                                  child: card,
                                );
                              }
                              return card;
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<TeacherModel> _filterTeachers(List<TeacherModel> teachers) {
    final query = _searchController.text.trim().toLowerCase();
    return teachers.where((teacher) {
      final name = (teacher.fullName ?? "").toLowerCase();
      final spec = (teacher.specialization ?? "").toLowerCase();
      final matchesQuery =
          query.isEmpty || name.contains(query) || spec.contains(query);
      final matchesSpecialization =
          _selectedSpecialization == "كل التخصصات" ||
          teacher.specialization == _selectedSpecialization;
      return matchesQuery && matchesSpecialization;
    }).toList();
  }
}
