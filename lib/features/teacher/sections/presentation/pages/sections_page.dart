import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/helpers/app_extensions.dart";
import "package:draya_mobile/core/helpers/app_loading.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/widgets/app_card_container_empty.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/create_section_request_model.dart";
import "package:draya_mobile/features/teacher/sections/presentation/cubit/section_cubit.dart";
import "package:draya_mobile/features/teacher/sections/presentation/cubit/section_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class SectionsPage extends StatefulWidget {
  final ClassroomModel _classroomModel;
  const SectionsPage(this._classroomModel, {super.key});

  @override
  State<SectionsPage> createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage> {
  late final TextEditingController _textEditingControllerTitle;
  late final TextEditingController _textEditingControllerDescription;

  @override
  void initState() {
    super.initState();

    _textEditingControllerTitle = TextEditingController(text: "قسم 1");
    _textEditingControllerDescription = TextEditingController();

    context.read<SectionCubit>().getSections(
      classroomId: widget._classroomModel.classroomId,
    );
  }

  @override
  void dispose() {
    _textEditingControllerTitle.dispose();
    _textEditingControllerDescription.dispose();

    super.dispose();
  }

  Future<CreateSectionRequestModel?> _showBottomSheet() async {
    return await showModalBottomSheet<CreateSectionRequestModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              left: AppSizes.s20,
              right: AppSizes.s20,
              top: AppSizes.s12,
              bottom:
                  MediaQuery.of(bottomSheetContext).viewInsets.bottom +
                  AppSizes.s20,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "انشاء قسم جديد",
                  style: context.textTheme.headlineSmall,
                ),

                const SizedBox(height: AppSizes.s20),

                AppTextFormField(
                  controller: _textEditingControllerTitle,
                  hintText: "اسم القسم",
                ),

                const SizedBox(height: AppSizes.s12),

                AppTextFormField(
                  controller: _textEditingControllerDescription,
                  hintText: "وصف القسم",
                ),

                const SizedBox(height: AppSizes.s20),

                AppElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      bottomSheetContext,
                      CreateSectionRequestModel(
                        title: _textEditingControllerTitle.text.trim(),
                        description: _textEditingControllerDescription.text
                            .trim(),
                      ),
                    );
                  },
                  label: "انشاء قسم",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _createSection() async {
    final createSectionRequestModel = await _showBottomSheet();

    if (createSectionRequestModel == null || !mounted) {
      return;
    }

    await context.read<SectionCubit>().createSection(
      classroomId: widget._classroomModel.classroomId,
      createSectionRequestModel: createSectionRequestModel,
    );
  }

  Future<void> _confirmDeleteSection({
    required String sectionId,
  }) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("حذف القسم"),
          content: const Text("هل أنت متأكد من حذف القسم"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("إلغاء"),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.surface,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text("حذف"),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    await context.read<SectionCubit>().deleteSection(sectionId: sectionId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SectionCubit, SectionState>(
      listener: (BuildContext context, SectionState state) {
        if (state.getSectionsStatus == CubitStatus.loading ||
            state.createSectionStatus == CubitStatus.loading ||
            state.deleteSectionStatus == CubitStatus.loading) {
          AppLoading.show();
        }

        if (state.getSectionsStatus == CubitStatus.error ||
            state.createSectionStatus == CubitStatus.error ||
            state.deleteSectionStatus == CubitStatus.error) {
          AppLoading.hide();
          AppDialogHelper.display(
            context,
            AppErrorDialog(apiErrorModel: state.apiErrorModel!),
          );
        }

        if (state.createSectionStatus == CubitStatus.success) {
          AppLoading.hide();

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text("تم انشاء القسم"),
              ),
            );

          context.read<SectionCubit>().getSections(
            classroomId: widget._classroomModel.classroomId,
          );
        }

        if (state.deleteSectionStatus == CubitStatus.success) {
          AppLoading.hide();

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text("تم مسح القسم"),
              ),
            );

          context.read<SectionCubit>().getSections(
            classroomId: widget._classroomModel.classroomId,
          );
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: "الاقسام"),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "اسم الفصل الدراسي:",
                  style: context.textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSizes.s8),
                Text(
                  widget._classroomModel.name,
                  style: context.textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSizes.s20),
                AppElevatedButton(
                  onPressed: () {
                    _createSection();
                  },
                  label: "انشاء قسم جديد",
                ),
                const SizedBox(height: AppSizes.s12),
                const Divider(),
                const SizedBox(height: AppSizes.s12),
                BlocBuilder<SectionCubit, SectionState>(
                  builder: (context, state) {
                    final sections = state.sections;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "جميع الاقسام",
                          style: context.textTheme.labelLarge,
                        ),

                        const SizedBox(height: AppSizes.s12),

                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final section = sections[index];
                            return InkWell(
                              onTap: () {
                                AppNavigator.push(
                                  context: context,
                                  path: AppRoutes.materialsPage,
                                  pathParameters: {
                                    "classroomId":
                                        widget._classroomModel.classroomId,
                                  },
                                  extra: section,
                                );
                              },
                              borderRadius: BorderRadius.circular(AppSizes.s20),
                              child: AppCardContainerEmpty(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              section.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  context.textTheme.titleLarge,
                                            ),
                                            const SizedBox(height: AppSizes.s8),
                                            Text(
                                              section.description,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  context.textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _confirmDeleteSection(
                                            sectionId: section.id,
                                          );
                                        },
                                        style: IconButton.styleFrom(
                                          foregroundColor: Colors.red.shade400,
                                          backgroundColor: Colors.red
                                              .withValues(
                                                alpha: 0.08,
                                              ),
                                        ),
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 21,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: AppSizes.s8);
                          },
                          itemCount: sections.length,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
