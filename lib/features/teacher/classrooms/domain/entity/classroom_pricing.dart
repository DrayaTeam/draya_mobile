class ClassroomPricing {
  final String classroomId;
  final double price;
  final String currency;
  final bool isFree;
  final DateTime updatedAt;

  const ClassroomPricing({
    required this.classroomId,
    required this.price,
    required this.currency,
    required this.isFree,
    required this.updatedAt,
  });
}
