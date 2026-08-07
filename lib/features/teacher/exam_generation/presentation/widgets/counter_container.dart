import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';

class CounterContainer extends StatefulWidget {
  final int counter;
  final VoidCallback increase;
  final VoidCallback decrease;
  const CounterContainer({
    super.key,
    required this.counter,
    required this.increase,
    required this.decrease,
  });

  @override
  State<CounterContainer> createState() => _CounterContainerState();
}

class _CounterContainerState extends State<CounterContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppSizes.s64),
        border: Border.all(
          color: AppColors.primary200,
          width: AppSizes.s1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: AppSizes.s4,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: widget.decrease,
            icon: const Icon(Icons.remove),
          ),
          Text(widget.counter.toString()),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: widget.increase,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
