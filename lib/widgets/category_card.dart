import 'app_network_image.dart';
import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../models/category.dart';
import '../screens/products/products_screen.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a, __) => ProductsScreen(
              title: category.name,
              categoryId: category.id,
            ),
            transitionsBuilder: (_, a, __, child) {
              final c = CurvedAnimation(parent: a, curve: Curves.easeOutCubic);
              return FadeTransition(
                opacity: c,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero).animate(c),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 320),
          ),
        );
      },
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(left: 12),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: AppNetworkImage(
                  imageUrl: category.imageUrl,
                  fit: BoxFit.cover,
                  width: 70,
                  height: 70,
                  placeholder: const Center(
                    child: Icon(Icons.spa, color: AppColors.primary),
                  ),
                  errorWidget: const Icon(
                    Icons.spa,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
