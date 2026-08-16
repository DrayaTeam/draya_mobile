import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/theme/app_text_styles.dart';
import 'package:draya_mobile/core/widgets/app_custom_loading.dart';
import 'package:draya_mobile/core/widgets/app_error_dialog.dart';
import 'package:draya_mobile/core/widgets/app_text_form_field.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/features/student/teachers/data/models/teacher_model.dart';
import 'package:draya_mobile/features/student/teachers/presentation/cubit/teacher_cubit.dart';
import 'package:draya_mobile/features/student/teachers/presentation/cubit/teacher_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'teacher_card_item.dart';

class BrowseTeachersBody extends StatefulWidget {
  const BrowseTeachersBody({super.key});

  @override
  State<BrowseTeachersBody> createState() => _BrowseTeachersBodyState();
}

class _BrowseTeachersBodyState extends State<BrowseTeachersBody> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialization = 'كل التخصصات';

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
          'كل التخصصات',
          ...teachers
              .where((teacher) => teacher.specialization != null)
              .map((teacher) => teacher.specialization!)
              .toSet(),
        ];
        final filteredTeachers = _filterTeachers(teachers);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s20,
              vertical: AppSizes.s16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'المعلمون',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.s12,
                        vertical: AppSizes.s8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.primary200,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${teachers.length} معلم',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.primary700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.s8),
                Text(
                  'تصفح المعلمين المتاحين حسب الاسم أو التخصص، ثم تواصل معهم مباشرة عبر البريد أو الهاتف.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSizes.s20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.s16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.s20),
                    border: Border.all(color: AppColors.border, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(17, 24, 39, 0.04),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextFormField(
                        controller: _searchController,
                        hintText: 'ابحث باسم المعلم أو البريد أو التخصص...',
                        prefixIcon: Icons.search,
                        onChanged: _onSearchChanged,
                      ),
                      const SizedBox(height: AppSizes.s16),
                      SizedBox(
                        height: 42,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: specializations.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(width: AppSizes.s8),
                          itemBuilder: (context, index) {
                            final specialization = specializations[index];
                            final isSelected =
                                specialization == _selectedSpecialization;
                            return GestureDetector(
                              onTap: () =>
                                  _onSpecializationSelected(specialization),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.s12,
                                  vertical: AppSizes.s8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary700
                                      : AppColors.backgroundMuted,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary700
                                        : AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  specialization,
                                  style: AppTextStyles.label.copyWith(
                                    color: isSelected
                                        ? AppColors.surface
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
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
                const SizedBox(height: AppSizes.s20),
                Expanded(
                  child: state.status == CubitStatus.loading && teachers.isEmpty
                      ? const Center(
                          child: AppCustomLoading(
                            text: 'جاري تحميل المعلمين...',
                          ),
                        )
                      : state.status == CubitStatus.error && teachers.isEmpty
                      ? Center(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSizes.s20),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppSizes.s20,
                              ),
                              border: Border.all(
                                color: AppColors.border,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  color: AppColors.error,
                                  size: 32,
                                ),
                                const SizedBox(height: AppSizes.s12),
                                Text(
                                  'تعذر تحميل المعلمين في الوقت الحالي.',
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : filteredTeachers.isEmpty
                      ? Center(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSizes.s20),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppSizes.s20,
                              ),
                              border: Border.all(
                                color: AppColors.border,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.search_off_rounded,
                                  color: AppColors.textSecondary,
                                  size: 32,
                                ),
                                const SizedBox(height: AppSizes.s12),
                                Text(
                                  'لا يوجد معلمين مطابقين.',
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredTeachers.length,
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final teacher = filteredTeachers[index];
                            return TeacherCardItem(
                              fullName: teacher.fullName ?? 'N/A',
                              email: teacher.email ?? 'N/A',
                              phone: teacher.phone ?? 'N/A',
                              specialization: teacher.specialization ?? 'N/A',
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
                          },
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
      final matchesQuery =
          query.isEmpty || teacher.fullName!.toLowerCase().contains(query);
      final matchesSpecialization =
          _selectedSpecialization == 'كل التخصصات' ||
          teacher.specialization == _selectedSpecialization;
      return matchesQuery && matchesSpecialization;
    }).toList();
  }
}
