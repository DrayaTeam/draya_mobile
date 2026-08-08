import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/helpers/app_dialog_helper.dart';
import 'package:draya_mobile/core/helpers/app_extensions.dart';
import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/view_models/drawer_model.dart';
import 'package:draya_mobile/core/widgets/app_card_container_empty.dart';
import 'package:draya_mobile/core/widgets/app_custom_loading.dart';
import 'package:draya_mobile/core/widgets/app_drawer.dart';
import 'package:draya_mobile/core/widgets/app_elevated_button.dart';
import 'package:draya_mobile/core/widgets/app_error_dialog.dart';
import 'package:draya_mobile/core/widgets/app_text_form_field.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/features/teacher/subjects/data/models/add_subject_request_model.dart';
import 'package:draya_mobile/features/teacher/subjects/data/models/subject_model.dart';
import 'package:draya_mobile/features/teacher/subjects/presentation/cubit/subject_cubit.dart';
import 'package:draya_mobile/features/teacher/subjects/presentation/cubit/subject_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateSubjectPage extends StatefulWidget {
  const CreateSubjectPage({super.key});

  @override
  State<CreateSubjectPage> createState() => _CreateSubjectPageState();
}

class _CreateSubjectPageState extends State<CreateSubjectPage> {
  late final TextEditingController _textEditingControllerNewSubject;

  @override
  void initState() {
    super.initState();
    _textEditingControllerNewSubject = TextEditingController();

    context.read<SubjectCubit>().getSubjects();
  }

  @override
  void dispose() {
    _textEditingControllerNewSubject.dispose();
    super.dispose();
  }

  void _addSubject() {
    final String subjectName = _textEditingControllerNewSubject.text.trim();

    if (subjectName.isEmpty) return;

    context.read<SubjectCubit>().addSubject(
      addSubjectRequestModel: AddSubjectRequestModel(name: subjectName),
    );
    _textEditingControllerNewSubject.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubjectCubit, SubjectState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: (BuildContext context, SubjectState state) {
        switch (state.status) {
          case CubitStatus.initial:
            break;
          case CubitStatus.loading:
            AppDialogHelper.display(context, const AppCustomLoading());
            break;
          case CubitStatus.success:
            AppNavigator.pop(context: context);
            break;
          case CubitStatus.error:
            // AppNavigator.pop(context: context);
            AppDialogHelper.display(
              context,
              AppErrorDialog(
                apiErrorModel: state.apiErrorModel!,
                onRetry: () {},
              ),
            );
            break;
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "المواد الدراسية",
        ),
        drawer: AppDrawer(
          drawerItemsList: getTeacherDrawerItemsList(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "انشاء مادة دراسية جديدة",
                  style: context.textTheme.labelLarge,
                ),
                const SizedBox(height: AppSizes.s12),
                AppTextFormField(
                  controller: _textEditingControllerNewSubject,
                  hintText: "اكتب اسم المادة الجديدة",
                ),
                const SizedBox(height: AppSizes.s12),
                AppElevatedButton(
                  onPressed: () {
                    _addSubject();
                  },
                  label: "انشاء المادة",
                ),
                const SizedBox(height: AppSizes.s8),
                const Divider(),
                const SizedBox(height: AppSizes.s8),
                Text(
                  "المواد الدراسية الموجودة",
                  style: context.textTheme.labelLarge,
                ),
                const SizedBox(height: AppSizes.s12),
                BlocBuilder<SubjectCubit, SubjectState>(
                  builder: (BuildContext context, SubjectState state) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final SubjectModel subject = state.subjects[index];
                        return AppCardContainerEmpty(
                          children: [
                            Text(
                              subject.name,
                              style: context.textTheme.labelLarge,
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: AppSizes.s8);
                      },
                      itemCount: state.subjects.length,
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
