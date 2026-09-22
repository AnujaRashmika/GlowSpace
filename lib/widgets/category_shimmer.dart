import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../config/colors.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(left: 12),
      child: Shimmer.fromColors(
        baseColor: AppColors.secondary.withValues(alpha: 0.3),
        highlightColor: AppColors.white,
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 10,
              width: 50,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
