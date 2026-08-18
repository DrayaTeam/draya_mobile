import 'package:json_annotation/json_annotation.dart';

part 'payment_status_model.g.dart';

@JsonSerializable()
class PaymentStatusModel {
  final String paymentTransactionId;
  final String status;
  final double grossAmount;
  final String purpose;
  final String? classroomId;
  final bool isEnrolled;

  const PaymentStatusModel({
    required this.paymentTransactionId,
    required this.status,
    required this.grossAmount,
    required this.purpose,
    this.classroomId,
    required this.isEnrolled,
  });

  factory PaymentStatusModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentStatusModelToJson(this);

  bool get isCompleted => status == 'Completed' && isEnrolled;
  bool get isPending => status == 'Pending';
  bool get isFailed => status == 'Failed';
}
