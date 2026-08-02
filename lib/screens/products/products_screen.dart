import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  final String title;
  final String? query;

  const ProductsScreen({
    super.key,
    required this.title,
    this.query,
  });

  // Screen width එකට අනුව column count එක decide කරනවා
  int _getCrossAxisCount(double width) {
    if (width >= 1200) return 6; // Large desktop
    if (width >= 900) return 5; // Small desktop / laptop
    if (width >= 600) return 4; // Tablet
    return 2; // Mobile
  }

  // Column ගණන අනුව card එකේ shape එකත් adjust කරනවා
  double _getAspectRatio(int crossAxisCount) {
    if (crossAxisCount >= 6) return 0.72;
    if (crossAxisCount >= 5) return 0.70;
    if (crossAxisCount >= 4) return 0.68;
    return 0.62; // Mobile - card ටිකක් උස
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    final products = query == null
        ? provider.products
        : provider.searchResult(query!);

    return Scaffold(
      appBar: CommonAppBar(
        title: title,
        showBackButton: true,
      ),
      body: products.isEmpty
          ? const Center(
        child: Text("No products found"),
      )
          : LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount =
          _getCrossAxisCount(constraints.maxWidth);

          final aspectRatio =
          _getAspectRatio(crossAxisCount);

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
              );
            },
          );
        },
      ),
    );
  }
}