import "package:draya_mobile/features/teacher/wallet/data/models/transaction_model.dart";
import "package:json_annotation/json_annotation.dart";

part "transaction_paged_result_model.g.dart";

@JsonSerializable()
class TransactionPagedResultModel {
  final List<TransactionModel> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const TransactionPagedResultModel({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory TransactionPagedResultModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionPagedResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionPagedResultModelToJson(this);
}
