import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:json_annotation/json_annotation.dart";
import "package:draya_mobile/core/theme/app_colors.dart";

part "transaction_model.g.dart";

enum TransactionType {
  topUp(0, "شحن رصيد"),
  withdrawal(1, "سحب رصيد"),
  earning(2, "أرباح مبيعات"),
  refund(3, "استرداد مالي"),
  unknown(-1, "معاملة مالية");

  final int value;
  final String label;
  const TransactionType(this.value, this.label);

  static TransactionType fromInt(int value) {
    return TransactionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TransactionType.unknown,
    );
  }
}

enum BalanceType {
  purchased(0, "رصيد مشحون"),
  earned(1, "رصيد مكتسب"),
  unknown(-1, "رصيد");

  final int value;
  final String label;
  const BalanceType(this.value, this.label);

  static BalanceType fromInt(int value) {
    return BalanceType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BalanceType.unknown,
    );
  }
}

@JsonSerializable()
class TransactionModel {
  final String id;
  final int type;
  final double amount;
  final int balanceType;
  final String? referenceId;
  final String? description;
  final String createdAt;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceType,
    this.referenceId,
    this.description,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  TransactionType get transactionType => TransactionType.fromInt(type);
  BalanceType get balanceTypeEnum => BalanceType.fromInt(balanceType);

  bool get isCredit => transactionType != TransactionType.withdrawal;

  String get typeName => transactionType.label;

  String get balanceTypeName => balanceTypeEnum.label;

  String get formattedAmount {
    final prefix = isCredit ? "+" : "-";
    return "$prefix${amount.abs().toStringAsFixed(2)} ج.م";
  }

  String get formattedDate {
    try {
      final date = DateTime.parse(createdAt).toLocal();
      return DateFormat("yyyy/MM/dd - hh:mm a", "ar").format(date);
    } catch (_) {
      return createdAt;
    }
  }

  IconData get iconData {
    switch (transactionType) {
      case TransactionType.topUp:
        return Icons.add_circle_outline_rounded;
      case TransactionType.withdrawal:
        return Icons.arrow_outward_rounded;
      case TransactionType.earning:
        return Icons.monetization_on_outlined;
      case TransactionType.refund:
        return Icons.replay_rounded;
      case TransactionType.unknown:
        return Icons.swap_horiz_rounded;
    }
  }

  Color get color {
    switch (transactionType) {
      case TransactionType.topUp:
      case TransactionType.earning:
        return const Color(0xFF16A34A); // Emerald green
      case TransactionType.withdrawal:
        return const Color(0xFFDC2626); // Crimson red
      case TransactionType.refund:
        return const Color(0xFFD97706); // Amber
      case TransactionType.unknown:
        return AppColors.primary700;
    }
  }

  Color get backgroundColor {
    return color.withValues(alpha: 0.12);
  }
}
