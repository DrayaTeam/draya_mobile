import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/validation/email_validator.dart";
import "package:draya_mobile/core/validation/validation_result.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_custom_loading.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/app_label.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/profile_avatar_picker.dart";
import "package:draya_mobile/features/student/profile/data/models/update_student_profile_request_model.dart";
import "package:draya_mobile/features/student/profile/presentation/cubit/student_profile_cubit.dart";
import "package:draya_mobile/features/student/profile/presentation/cubit/student_profile_state.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _fullNameController;
  late final TextEditingController _parentGuardianEmailController;
  late final TextEditingController _dateOfBirthController;
  DateTime? _dateOfBirth;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _fullNameController = TextEditingController();
    _parentGuardianEmailController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    context.read<StudentProfileCubit>().getStudentProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _parentGuardianEmailController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _dateOfBirth = pickedDate;
      _dateOfBirthController.text = DateFormat("yyyy-MM-dd").format(pickedDate);
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await context.read<StudentProfileCubit>().updateStudentProfile(
      request: UpdateStudentProfileRequestModel(
        fullName: _fullNameController.text.trim(),
        parentGuardianEmail: _parentGuardianEmailController.text.trim(),
        dateOfBirth: _dateOfBirth,
      ),
    );
  }

  void _dismissLoadingDialogIfVisible(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentProfileCubit, StudentProfileState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          (previous.apiErrorModel != current.apiErrorModel &&
              current.apiErrorModel != null),
      listener: (context, state) {
        switch (state.status) {
          case CubitStatus.loading:
            AppDialogHelper.display(context, const AppCustomLoading());
            break;
          case CubitStatus.success:
            _dismissLoadingDialogIfVisible(context);
            final studentProfile = state.studentProfile;
            if (studentProfile == null) return;
            _fullNameController.text = studentProfile.fullName ?? "";
            _parentGuardianEmailController.text =
                studentProfile.parentGuardianEmail ?? "";
            if (studentProfile.dateOfBirth != null) {
              _dateOfBirth = studentProfile.dateOfBirth;
              _dateOfBirthController.text = DateFormat(
                "yyyy-MM-dd",
              ).format(studentProfile.dateOfBirth!);
            }
            break;
          case CubitStatus.error:
            _dismissLoadingDialogIfVisible(context);
            if (state.apiErrorModel != null) {
              AppDialogHelper.display(
                context,
                AppErrorDialog(
                  apiErrorModel: state.apiErrorModel!,
                  onRetry: () =>
                      context.read<StudentProfileCubit>().getStudentProfile(),
                ),
              );
            }
            break;
          case CubitStatus.initial:
            break;
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: "الملف الشخصي"),
        drawer: AppDrawer(drawerItemsList: getStudentDrawerItemsList()),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.s24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BlocBuilder<StudentProfileCubit, StudentProfileState>(
                    builder: (context, state) {
                      final studentProfile = state.studentProfile;
                      final name = _fullNameController.text.trim().isNotEmpty
                          ? _fullNameController.text.trim()
                          : (studentProfile?.fullName ?? "");

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.s24),
                        child: ProfileAvatarPicker(
                          imageUrl: studentProfile?.profilePictureUrl,
                          name: name,
                          isUploading: state.isUploadingPicture,
                          onImagePicked: (file) {
                            context
                                .read<StudentProfileCubit>()
                                .uploadProfilePicture(file: file);
                          },
                        ),
                      );
                    },
                  ),
                  Text(
                    "معلومات الطالب",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSizes.s24),
                  const AppLabel(label: "الاسم الكامل"),
                  const SizedBox(height: AppSizes.s8),
                  AppTextFormField(
                    controller: _fullNameController,
                    hintText: "أدخل اسمك",
                    prefixIcon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "الاسم الكامل مطلوب";
                      }
                      if (value.trim().length < 3) {
                        return "يجب أن يكون الاسم أكثر من حرفين";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSizes.s20),
                  const AppLabel(label: "البريد الإلكتروني للوالد/الوصي"),
                  const SizedBox(height: AppSizes.s8),
                  AppTextFormField(
                    controller: _parentGuardianEmailController,
                    hintText: "name@example.com",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      final result = EmailValidator.validate(email: value);
                      if (result is Invalid) {
                        return result.message;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSizes.s20),
                  const AppLabel(label: "تاريخ الميلاد"),
                  const SizedBox(height: AppSizes.s8),
                  AppTextFormField(
                    controller: _dateOfBirthController,
                    hintText: "YYYY-MM-DD",
                    prefixIcon: Icons.calendar_month_outlined,
                    isEnabled: false,
                    onTap: _pickDateOfBirth,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "تاريخ الميلاد مطلوب";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSizes.s24),
                  AppElevatedButton(
                    onPressed: _saveProfile,
                    label: "حفظ التغييرات",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
