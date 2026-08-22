import "package:draya_mobile/core/theme/app_colors.dart";
import "package:flutter/material.dart";

class StarRatingDisplay extends StatelessWidget {
  final int rating;
  final double size;

  const StarRatingDisplay({
    super.key,
    required this.rating,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          color: index < rating ? AppColors.amber : AppColors.borderStrong,
          size: size,
        );
      }),
    );
  }
}
