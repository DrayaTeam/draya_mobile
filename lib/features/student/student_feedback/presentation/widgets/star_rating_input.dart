import "package:draya_mobile/core/theme/app_colors.dart";
import "package:flutter/material.dart";

class StarRatingInput extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;
  final double size;

  const StarRatingInput({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "تقييم بالنجوم",
      value: "$rating من 5",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final starValue = index + 1;
          final isSelected = starValue <= rating;

          return GestureDetector(
            onTap: () => onRatingChanged(starValue),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              scale: isSelected ? 1.15 : 1.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  isSelected
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color:
                      isSelected ? AppColors.amber : AppColors.borderStrong,
                  size: size,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
