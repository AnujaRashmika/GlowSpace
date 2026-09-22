import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../config/colors.dart';

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  double _height(double width) {
    if (width >= 1200) return 420;
    if (width >= 900) return 360;
    if (width >= 600) return 280;
    return 180;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = _height(constraints.maxWidth);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Shimmer.fromColors(
            baseColor: AppColors.secondary.withValues(alpha: 0.4),
            highlightColor: AppColors.white,
            child: Container(
              height: h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
    );
  }
}
