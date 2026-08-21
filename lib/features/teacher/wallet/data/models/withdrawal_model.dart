import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:json_annotation/json_annotation.dart";

part "withdrawal_model.g.dart";

enum WithdrawalStatus {
  pending(0, "قيد مراجعة الإدارة", Icons.hourglass_top_rounded, Color(0xFFF59E0B)),
  approved(1, "تم التحويل بنجاح", Icons.check_circle_rounded, Color(0xFF16A34A)),
  rejected(2, "تم رفض الطلب", Icons.cancel_rounded, Color(0xFFDC2626)),
  cancelled(3, "ملغي", Icons.block_rounded, Color(0xFF6B7280)),
  unknown(-1, "غير محدد", Icons.help_outline_rounded, Color(0xFF6B7280));

  final int value;
  final String label;
  final IconData icon;
  final Color color;

  const WithdrawalStatus(this.value, this.label, this.icon, this.color);

  static WithdrawalStatus fromInt(int value) {
    return WithdrawalStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WithdrawalStatus.unknown,
    );
  }
}

@JsonSerializable()
class WithdrawalModel {
  final String id;
  final String? teacherId;
  final double amount;
  final int status;
  final String requestedAt;
  final String? processedAt;
  final String? adminNote;
  final String? rejectionReason;

  const WithdrawalModel({
    required this.id,
    this.teacherId,
    required this.amount,
    required this.status,
    required this.requestedAt,
    this.processedAt,
    this.adminNote,
    this.rejectionReason,
  });

  factory WithdrawalModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalModelFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawalModelToJson(this);

  WithdrawalStatus get statusEnum => WithdrawalStatus.fromInt(status);

  String get statusLabel => statusEnum.label;

  IconData get statusIcon => statusEnum.icon;

  Color get statusColor => statusEnum.color;

  String get formattedAmount => "${amount.toStringAsFixed(2)} ج.م";

  String get formattedRequestedDate {
    try {
      final date = DateTime.parse(requestedAt).toLocal();
      return DateFormat("yyyy/MM/dd - hh:mm a", "ar").format(date);
    } catch (_) {
      return requestedAt;
    }
  }

  String? get formattedProcessedDate {
    if (processedAt == null) return null;
    try {
      final date = DateTime.parse(processedAt!).toLocal();
      return DateFormat("yyyy/MM/dd - hh:mm a", "ar").format(date);
    } catch (_) {
      return processedAt;
    }
  }
}
