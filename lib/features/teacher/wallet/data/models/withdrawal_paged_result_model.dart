import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_model.dart";
import "package:json_annotation/json_annotation.dart";

part "withdrawal_paged_result_model.g.dart";

@JsonSerializable()
class WithdrawalPagedResultModel {
  final List<WithdrawalModel> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const WithdrawalPagedResultModel({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory WithdrawalPagedResultModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalPagedResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawalPagedResultModelToJson(this);
}
