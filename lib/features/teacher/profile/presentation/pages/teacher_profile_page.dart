import "package:draya_mobile/core/helpers/app_dialog_helper.dart";
import "package:draya_mobile/core/helpers/app_loading.dart";
import "package:draya_mobile/core/helpers/app_navigator.dart";
import "package:draya_mobile/core/router/app_routes.dart";
import "package:draya_mobile/core/theme/app_sizes.dart";
import "package:draya_mobile/core/validation/phone_validator.dart";
import "package:draya_mobile/core/validation/validation_result.dart";
import "package:draya_mobile/core/view_models/drawer_model.dart";
import "package:draya_mobile/core/widgets/app_custom_loading.dart";
import "package:draya_mobile/core/widgets/app_drawer.dart";
import "package:draya_mobile/core/widgets/app_elevated_button.dart";
import "package:draya_mobile/core/widgets/app_error_dialog.dart";
import "package:draya_mobile/core/widgets/app_label.dart";
import "package:draya_mobile/core/widgets/app_text_form_field.dart";
import "package:draya_mobile/core/widgets/custom_app_bar.dart";
import "package:draya_mobile/core/widgets/fade_in_up_animation.dart";
import "package:draya_mobile/core/widgets/profile_avatar_picker.dart";
import "package:draya_mobile/features/teacher/payments/data/models/payment_webview_model.dart";
import "package:draya_mobile/features/teacher/profile/data/models/teacher_model.dart";
import "package:draya_mobile/features/teacher/profile/data/models/update_teacher_request_model.dart";
import "package:draya_mobile/features/teacher/profile/presentation/cubit/teacher_profile_cubit.dart";
import "package:draya_mobile/features/teacher/profile/presentation/cubit/teacher_profile_state.dart";
import "package:draya_mobile/features/teacher/profile/presentation/widgets/payout_account_bottom_sheet.dart";
import "package:draya_mobile/features/teacher/profile/presentation/widgets/teacher_top_up_card.dart";
import "package:draya_mobile/features/teacher/profile/presentation/widgets/teacher_wallet_actions_row.dart";
import "package:draya_mobile/features/teacher/profile/presentation/widgets/teacher_wallet_card.dart";
import "package:draya_mobile/features/teacher/profile/presentation/widgets/teacher_wallet_tabs_section.dart";
import "package:draya_mobile/features/teacher/profile/presentation/widgets/teacher_withdraw_bottom_sheet.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/top_up_request_model.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/payout_accounts_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/payout_accounts_state.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/top_up_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/top_up_state.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/transactions_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/wallet_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/withdrawals_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/theme/app_colors.dart";
import "package:draya_mobile/core/theme/app_text_styles.dart";

class TeacherProfilePage extends StatefulWidget {
  const TeacherProfilePage({super.key});

  @override
  State<TeacherProfilePage> createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  late final TextEditingController _textEditingControllerName;
  late final TextEditingController _textEditingControllerEmail;
  late final TextEditingController _textEditingControllerPhoneNumber;
  late final TextEditingController _textEditingControllerSpecialization;
  late final TextEditingController _textEditingControllerDescription;
  late final TextEditingController _textEditingControllerTopUpAmount;
  late final GlobalKey<FormState> _formKey;
  String? _topUpAmountError;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _textEditingControllerName = TextEditingController();
    _textEditingControllerEmail = TextEditingController();
    _textEditingControllerPhoneNumber = TextEditingController();
    _textEditingControllerSpecialization = TextEditingController();
    _textEditingControllerDescription = TextEditingController();
    _textEditingControllerTopUpAmount = TextEditingController();

    _loadData();
  }

  @override
  void dispose() {
    _textEditingControllerName.dispose();
    _textEditingControllerEmail.dispose();
    _textEditingControllerPhoneNumber.dispose();
    _textEditingControllerSpecialization.dispose();
    _textEditingControllerDescription.dispose();
    _textEditingControllerTopUpAmount.dispose();
    super.dispose();
  }

  void _loadData() {
    context.read<TeacherProfileCubit>().getTeacherProfile();
    context.read<WalletCubit>().getTeacherBalance();
    context.read<TransactionsCubit>().getTransactions(isRefresh: true);
    context.read<WithdrawalsCubit>().getWithdrawals(isRefresh: true);
    context.read<PayoutAccountsCubit>().getPayoutAccounts();
  }

  void _editTeacherProfile() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      context.read<TeacherProfileCubit>().updateTeacherProfile(
        updateTeacherRequestModel: UpdateTeacherRequestModel(
          fullName: _textEditingControllerName.text,
          phone: _textEditingControllerPhoneNumber.text,
          specialization: _textEditingControllerSpecialization.text,
          description: _textEditingControllerDescription.text,
        ),
      );
    }
  }

  void _topUpBalance() {
    final amountText = _textEditingControllerTopUpAmount.text.trim();
    final amount = double.tryParse(amountText);

    setState(() {
      if (amountText.isEmpty) {
        _topUpAmountError = "من فضلك أدخل مبلغ الشحن";
        return;
      }

      if (amount == null || amount <= 0) {
        _topUpAmountError = "يجب أن يكون مبلغ الشحن أكبر من صفر";
        return;
      }

      _topUpAmountError = null;
    });

    if (_topUpAmountError != null) {
      return;
    }

    FocusScope.of(context).unfocus();
    context.read<TopUpCubit>().topUp(
      topUpRequestModel: TopUpRequestModel(amount: amount!),
    );
  }

  void _openWithdrawBottomSheet() {
    final available =
        context
            .read<WalletCubit>()
            .state
            .teacherBalance
            ?.availableEarnedBalance ??
        0.0;

    TeacherWithdrawBottomSheet.show(context, availableBalance: available);
  }

  void _openAddPayoutAccountBottomSheet() async {
    final created = await PayoutAccountBottomSheet.show(context);
    if (created == true && mounted) {
      await context.read<PayoutAccountsCubit>().getPayoutAccounts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TeacherProfileCubit, TeacherProfileState>(
          // listenWhen: (previous, current) {
          //   return previous.status != current.status ||
          //       (previous.apiErrorModel != current.apiErrorModel &&
          //           current.apiErrorModel != null);
          // },
          listener: (BuildContext context, TeacherProfileState state) {
            if (state.getTeacherProfileStatus == CubitStatus.loading ||
                state.updateTeacherProfileStatus == CubitStatus.loading) {
              AppLoading.show();
            }

            if (state.getTeacherProfileStatus == CubitStatus.error) {
              AppLoading.hide();
              AppDialogHelper.display(
                context,
                AppErrorDialog(
                  apiErrorModel: state.apiErrorModel!,
                  onRetry: () =>
                      context.read<TeacherProfileCubit>().getTeacherProfile(),
                ),
              );
            }

            if (state.updateTeacherProfileStatus == CubitStatus.error) {
              AppLoading.hide();
              AppDialogHelper.display(
                context,
                AppErrorDialog(
                  apiErrorModel: state.apiErrorModel!,
                ),
              );
            }

            if (state.getTeacherProfileStatus == CubitStatus.success) {
              AppLoading.hide();

              final TeacherModel? teacher = state.teacher;

              if (teacher != null) {
                _textEditingControllerName.text = teacher.fullName;
                _textEditingControllerEmail.text = teacher.email;
                _textEditingControllerPhoneNumber.text = teacher.phone;
                _textEditingControllerSpecialization.text =
                    teacher.specialization ?? "";
                _textEditingControllerDescription.text =
                    teacher.description ?? "";
              }
            }

            if (state.updateTeacherProfileStatus == CubitStatus.success) {
              AppLoading.hide();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text("تم حفظ التعديلات بنجاح"),
                    ],
                  ),
                  backgroundColor: AppColors.primary700,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<TopUpCubit, TopUpState>(
          listenWhen: (previous, current) {
            return previous.status != current.status;
          },
          listener: (context, state) async {
            switch (state.status) {
              case CubitStatus.initial:
                break;
              case CubitStatus.loading:
                AppDialogHelper.display(context, const AppCustomLoading());
                break;
              case CubitStatus.success:
                AppNavigator.pop(context: context);
                final response = state.topUpResponseModel;

                if (response == null) {
                  return;
                }

                await AppNavigator.push(
                  context: context,
                  path: AppRoutes.paymentWebViewPage,
                  extra: PaymentWebviewModel(
                    appBarTitle: "شحن رصيد",
                    url: response.checkoutUrl,
                    transactionId: response.transactionId,
                  ),
                );

                if (context.mounted) {
                  await context.read<WalletCubit>().getTeacherBalance();
                  if (context.mounted) {
                    await context.read<TransactionsCubit>().getTransactions(
                      isRefresh: true,
                    );
                  }
                }

                break;
              case CubitStatus.error:
                AppNavigator.pop(context: context);
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
        ),
        BlocListener<PayoutAccountsCubit, PayoutAccountsState>(
          listenWhen: (previous, current) =>
              previous.actionSuccessMessage != current.actionSuccessMessage &&
              current.actionSuccessMessage != null,
          listener: (context, state) {
            if (state.actionSuccessMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(state.actionSuccessMessage!),
                    ],
                  ),
                  backgroundColor: AppColors.primary700,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(
          title: "الملف الشخصي",
        ),
        drawer: AppDrawer(
          drawerItemsList: getTeacherDrawerItemsList(),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              _loadData();
            },
            color: AppColors.primary700,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.s20,
                vertical: AppSizes.s16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Profile Header with Avatar & Badge
                  FadeInUp(
                    delay: 0,
                    child: _buildProfileHeader(context),
                  ),

                  const SizedBox(height: AppSizes.s20),

                  // 2. Personal Information Card
                  FadeInUp(
                    delay: 100,
                    child: _buildPersonalInfoCard(context),
                  ),

                  const SizedBox(height: AppSizes.s24),

                  // 3. Wallet Section Header
                  FadeInUp(
                    delay: 150,
                    child: _buildSectionTitle(
                      context,
                      icon: Icons.account_balance_wallet_rounded,
                      title: "المحفظة والعمليات المالية",
                      subtitle:
                          "متابعة الرصيد المالي وإجراء عمليات السحب والشحن",
                    ),
                  ),

                  const SizedBox(height: AppSizes.s12),

                  // 4. Wallet Card (Fintech Card with Live Balance)
                  FadeInUp(
                    delay: 200,
                    child: TeacherWalletCard(
                      onRefresh: () {
                        context.read<WalletCubit>().getTeacherBalance();
                      },
                    ),
                  ),

                  const SizedBox(height: AppSizes.s14),

                  // 5. Quick Wallet Actions (Withdraw & Payout Accounts)
                  FadeInUp(
                    delay: 230,
                    child: TeacherWalletActionsRow(
                      onWithdraw: _openWithdrawBottomSheet,
                      onAddPayoutAccount: _openAddPayoutAccountBottomSheet,
                    ),
                  ),

                  const SizedBox(height: AppSizes.s16),

                  // 6. Quick Top-Up Action Card
                  FadeInUp(
                    delay: 260,
                    child: BlocBuilder<TopUpCubit, TopUpState>(
                      builder: (context, topUpState) {
                        return TeacherTopUpCard(
                          controller: _textEditingControllerTopUpAmount,
                          errorText: _topUpAmountError,
                          isLoading: topUpState.status == CubitStatus.loading,
                          onTopUp: _topUpBalance,
                          onAmountChanged: (value) {
                            if (_topUpAmountError != null) {
                              setState(() => _topUpAmountError = null);
                            }
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: AppSizes.s20),

                  // 7. Wallet Tabs Section (Transactions, Withdrawals with Admin Confirmation, Payout Accounts)
                  FadeInUp(
                    delay: 300,
                    child: TeacherWalletTabsSection(
                      onRequestWithdrawal: _openWithdrawBottomSheet,
                    ),
                  ),

                  const SizedBox(height: AppSizes.s32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return BlocBuilder<TeacherProfileCubit, TeacherProfileState>(
      builder: (context, state) {
        final teacher = state.teacher;
        final name = _textEditingControllerName.text.trim().isNotEmpty
            ? _textEditingControllerName.text.trim()
            : (teacher?.fullName ?? "");

        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.s20,
            horizontal: AppSizes.s16,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ProfileAvatarPicker(
                imageUrl: teacher?.profilePictureUrl,
                name: name,
                isUploading: state.isUploadingPicture,
                onImagePicked: (file) {
                  context.read<TeacherProfileCubit>().uploadProfilePicture(
                    file: file,
                  );
                },
              ),
              const SizedBox(height: AppSizes.s12),
              Text(
                name.isNotEmpty ? name : "المعلم",
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.s4),
              // Role & Verification Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          size: 15,
                          color: AppColors.primary700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "معلم معتمد",
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.primary800,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.s20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.s8),
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primary700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSizes.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "البيانات الأساسية",
                        style: AppTextStyles.h4.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        "قم بتعديل بيانات حسابك الشخصي",
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.s20),

            const AppLabel(label: "الاسم الكامل"),
            const SizedBox(height: AppSizes.s8),
            AppTextFormField(
              controller: _textEditingControllerName,
              hintText: "أدخل اسمك الكامل",
              prefixIcon: Icons.badge_outlined,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "الاسم الكامل مطلوب";
                }
                if (value.trim().length < 3) {
                  return "الاسم الكامل يجب ان يكون اكثر من 3 حروف";
                }
                return null;
              },
            ),

            const SizedBox(height: AppSizes.s16),

            const AppLabel(label: "البريد الإلكتروني"),
            const SizedBox(height: AppSizes.s8),
            AppTextFormField(
              isReadOnly: true,
              controller: _textEditingControllerEmail,
              hintText: "name@example.com",
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.email_outlined,
            ),

            const SizedBox(height: AppSizes.s16),

            const AppLabel(label: "رقم الهاتف"),
            const SizedBox(height: AppSizes.s8),
            AppTextFormField(
              controller: _textEditingControllerPhoneNumber,
              hintText: "010xxxxxxx / 011xxxxxxx / 012xxxxxxx",
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              prefixIcon: Icons.phone_outlined,
              validator: (value) {
                final result = PhoneValidator.validate(phone: value);
                if (result is Invalid) {
                  return result.message;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.s16),

            const AppLabel(label: "التخصص"),
            const SizedBox(height: AppSizes.s8),
            AppTextFormField(
              controller: _textEditingControllerSpecialization,
              hintText: "أدخل التخصص",
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.school_outlined,
            ),

            const SizedBox(height: AppSizes.s16),

            const AppLabel(label: "الوصف"),
            const SizedBox(height: AppSizes.s8),
            AppTextFormField(
              controller: _textEditingControllerDescription,
              hintText: "أدخل الوصف",
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.description_outlined,
            ),
            const SizedBox(height: AppSizes.s20),
            AppElevatedButton(
              onPressed: _editTeacherProfile,
              label: "حفظ التغييرات",
              icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.primary700,
            ),
          ),
          const SizedBox(width: AppSizes.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
