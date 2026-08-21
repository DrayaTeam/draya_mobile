import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:json_annotation/json_annotation.dart";
import "package:draya_mobile/core/theme/app_colors.dart";

part "payout_account_model.g.dart";

enum PayoutAccountType {
  bankAccount(0, "حساب بنكي", Icons.account_balance_rounded, "رقم الحساب / IBAN"),
  vodafoneCash(1, "محفظة إلكترونية", Icons.phone_android_rounded, "رقم المحفظة (الهاتف)"),
  instaPay(2, "إنستاباي (InstaPay)", Icons.flash_on_rounded, "عنوان الدفع اللحظي (IPA) أو رقم الهاتف"),
  other(3, "أخرى", Icons.credit_card_rounded, "المعرف المالي");

  final int value;
  final String label;
  final IconData icon;
  final String identifierHint;

  const PayoutAccountType(this.value, this.label, this.icon, this.identifierHint);

  Color get color {
    switch (this) {
      case PayoutAccountType.bankAccount:
        return const Color(0xFF2563EB); // Royal Blue
      case PayoutAccountType.vodafoneCash:
        return const Color(0xFFE11D48); // Rose / Red
      case PayoutAccountType.instaPay:
        return const Color(0xFF7C3AED); // Purple / Violet
      case PayoutAccountType.other:
        return AppColors.primary700;
    }
  }

  static PayoutAccountType fromInt(int value) {
    return PayoutAccountType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PayoutAccountType.other,
    );
  }
}

@JsonSerializable()
class PayoutAccountModel {
  final String id;
  final String? teacherId;
  final int accountType;
  final String accountName;
  final String accountIdentifier;
  final bool isDefault;
  final String? createdAt;

  const PayoutAccountModel({
    required this.id,
    this.teacherId,
    required this.accountType,
    required this.accountName,
    required this.accountIdentifier,
    required this.isDefault,
    this.createdAt,
  });

  factory PayoutAccountModel.fromJson(Map<String, dynamic> json) =>
      _$PayoutAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayoutAccountModelToJson(this);

  PayoutAccountType get typeEnum => PayoutAccountType.fromInt(accountType);

  String get typeName => typeEnum.label;

  IconData get iconData => typeEnum.icon;

  String get formattedDate {
    if (createdAt == null) return "";
    try {
      final date = DateTime.parse(createdAt!).toLocal();
      return DateFormat("yyyy/MM/dd", "ar").format(date);
    } catch (_) {
      return createdAt!;
    }
  }

  Color get color {
    switch (typeEnum) {
      case PayoutAccountType.bankAccount:
        return const Color(0xFF2563EB); // Royal Blue
      case PayoutAccountType.vodafoneCash:
        return const Color(0xFFE11D48); // Rose / Red
      case PayoutAccountType.instaPay:
        return const Color(0xFF7C3AED); // Purple / Violet
      case PayoutAccountType.other:
        return AppColors.primary700;
    }
  }
}
