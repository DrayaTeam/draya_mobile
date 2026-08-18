import 'package:draya_mobile/core/helpers/app_dialog_helper.dart';
import 'package:draya_mobile/core/helpers/app_extensions.dart';
import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/validation/email_validator.dart';
import 'package:draya_mobile/core/validation/phone_validator.dart';
import 'package:draya_mobile/core/validation/validation_result.dart';
import 'package:draya_mobile/core/view_models/drawer_model.dart';
import 'package:draya_mobile/core/widgets/app_custom_loading.dart';
import 'package:draya_mobile/core/widgets/app_drawer.dart';
import 'package:draya_mobile/core/widgets/app_elevated_button.dart';
import 'package:draya_mobile/core/widgets/app_error_dialog.dart';
import 'package:draya_mobile/core/widgets/app_label.dart';
import 'package:draya_mobile/core/widgets/app_text_form_field.dart';
import 'package:draya_mobile/core/widgets/custom_app_bar.dart';
import 'package:draya_mobile/features/teacher/payments/data/models/payment_webview_model.dart';
import 'package:draya_mobile/features/teacher/profile/data/models/teacher_model.dart';
import 'package:draya_mobile/features/teacher/profile/presentation/cubit/teacher_profile_cubit.dart';
import 'package:draya_mobile/features/teacher/profile/presentation/cubit/teacher_profile_state.dart';
import 'package:draya_mobile/features/teacher/wallet/data/models/top_up_request_model.dart';
import 'package:draya_mobile/features/teacher/wallet/presentation/cubit/top_up_cubit.dart';
import 'package:draya_mobile/features/teacher/wallet/presentation/cubit/top_up_state.dart';
import 'package:draya_mobile/features/teacher/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:draya_mobile/features/teacher/wallet/presentation/cubit/wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:draya_mobile/core/enums/cubit_status.dart';

class TeacherProfilePage extends StatefulWidget {
  const TeacherProfilePage({super.key});

  @override
  State<TeacherProfilePage> createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  late final TextEditingController _textEditingControllerName;
  late final TextEditingController _textEditingControllerEmail;
  late final TextEditingController _textEditingControllerPhoneNumber;
  late final TextEditingController _textEditingControllerTopUpAmount;
  late final GlobalKey<FormState> _formKey;
  String? _topUpAmountError;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _textEditingControllerName = TextEditingController();
    _textEditingControllerEmail = TextEditingController();
    _textEditingControllerPhoneNumber = TextEditingController();
    _textEditingControllerTopUpAmount = TextEditingController();

    context.read<TeacherProfileCubit>().getTeacherProfile();
    context.read<WalletCubit>().getTeacherBalance();
  }

  @override
  void dispose() {
    _textEditingControllerName.dispose();
    _textEditingControllerEmail.dispose();
    _textEditingControllerPhoneNumber.dispose();
    _textEditingControllerTopUpAmount.dispose();
    super.dispose();
  }

  void _editTeacherProfile() {
    if (_formKey.currentState!.validate()) {}
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

    // proceed with paymob url
    context.read<TopUpCubit>().topUp(
      topUpRequestModel: TopUpRequestModel(amount: amount!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TeacherProfileCubit, TeacherProfileState>(
          listenWhen: (previous, current) {
            return previous.status != current.status;
          },
          listener: (BuildContext context, TeacherProfileState state) {
            switch (state.status) {
              case CubitStatus.initial:
                break;
              case CubitStatus.loading:
                AppDialogHelper.display(context, const AppCustomLoading());
                break;
              case CubitStatus.success:
                final TeacherModel? teacher = state.teacher;

                if (teacher != null) {
                  _textEditingControllerName.text = teacher.fullName;
                  _textEditingControllerEmail.text = teacher.email;
                  _textEditingControllerPhoneNumber.text = teacher.phone;
                }

                AppNavigator.pop(context: context);
                break;
              case CubitStatus.error:
                // AppNavigator.pop(context: context);
                AppDialogHelper.display(
                  context,
                  AppErrorDialog(
                    apiErrorModel: state.apiErrorModel!,
                  ),
                );
                break;
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
        ),
      ],

      child: Scaffold(
        appBar: const CustomAppBar(
          title: "الصفحة الشخصية",
        ),
        drawer: AppDrawer(
          drawerItemsList: getTeacherDrawerItemsList(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.s24),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "الصفحة الشخصية للمعلم",
                        style: context.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppSizes.s32),
                      const AppLabel(label: "الاسم"),
                      const SizedBox(height: AppSizes.s8),
                      AppTextFormField(
                        controller: _textEditingControllerName,
                        hintText: "أدخل اسمك",
                        prefixIcon: Icons.person_outline,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "الاسم الكامل مطلوب";
                          }
                          if (value.length < 3) {
                            return "الاسم الكامل يجب ان يكون اكثر من 3 حروف";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.s20),
                      const AppLabel(label: "البريد الإلكتروني"),
                      const SizedBox(height: AppSizes.s8),
                      AppTextFormField(
                        controller: _textEditingControllerEmail,
                        hintText: "name@example.com",
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icons.email_outlined,
                        validator: (value) {
                          final result = EmailValidator.validate(email: value);

                          if (result is Invalid) {
                            return result.message;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.s20),
                      const AppLabel(label: "رقم الهاتف"),
                      const SizedBox(height: AppSizes.s8),
                      AppTextFormField(
                        controller: _textEditingControllerPhoneNumber,
                        hintText:
                            "010xxxxxxx / 011xxxxxxx / 012xxxxxxx / 015xxxxxxx",
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icons.phone_outlined,
                        validator: (value) {
                          final result = PhoneValidator.validate(phone: value);

                          if (result is Invalid) {
                            return result.message;
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.s20),
                      AppElevatedButton(
                        onPressed: () {
                          _editTeacherProfile();
                        },
                        label: "حفظ التغييرات",
                      ),
                      const SizedBox(height: AppSizes.s12),
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(height: AppSizes.s12),
                BlocBuilder<WalletCubit, WalletState>(
                  builder: (context, state) {
                    final balance = state.teacherBalance;

                    if (state.status == CubitStatus.loading) {
                      return const Center(
                        child: AppCustomLoading(),
                      );
                    }

                    if (balance == null) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "المحفظة",
                          style: context.textTheme.headlineLarge,
                        ),

                        const SizedBox(height: AppSizes.s8),

                        Row(
                          children: [
                            Text(
                              "الرصيد المكتسب:",
                              style: context.textTheme.titleLarge,
                            ),
                            const SizedBox(width: AppSizes.s12),
                            Text(
                              "${balance.earnedBalance}",
                              style: context.textTheme.headlineMedium,
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Text(
                              "الرصيد المشتري:",
                              style: context.textTheme.titleLarge,
                            ),
                            const SizedBox(width: AppSizes.s12),
                            Text(
                              "${balance.purchasedBalance}",
                              style: context.textTheme.headlineMedium,
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Text(
                              "الرصيد المكتسب المتاح:",
                              style: context.textTheme.titleLarge,
                            ),
                            const SizedBox(width: AppSizes.s12),
                            Text(
                              "${balance.availableEarnedBalance}",
                              style: context.textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSizes.s12),
                const Divider(),
                const SizedBox(height: AppSizes.s12),
                Row(
                  children: [
                    Expanded(
                      child: AppTextFormField(
                        controller: _textEditingControllerTopUpAmount,
                        hintText: "المبلغ",
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        errorText: _topUpAmountError,
                      ),
                    ),
                    const SizedBox(width: AppSizes.s12),
                    Expanded(
                      child: AppElevatedButton(
                        onPressed: () {
                          _topUpBalance();
                        },
                        label: "شحن رصيد",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
