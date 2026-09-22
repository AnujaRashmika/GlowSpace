import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  final String title;
  final String? categoryId;

  const ProductsScreen({
    super.key,
    required this.title,
    this.categoryId,
  });

  int _crossAxis(double w) {
    if (w >= 1200) return 5;
    if (w >= 900) return 4;
    if (w >= 600) return 3;
    return 2;
  }

  double _ratio(int c) {
    if (c >= 5) return 0.68;
    if (c >= 4) return 0.65;
    if (c >= 3) return 0.62;
    return 0.58;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final products = categoryId != null
        ? provider.getByCategory(categoryId!)
        : provider.products;

    return Scaffold(
      appBar: CommonAppBar(title: title, showBack: true),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(
                  child: Text(
                    categoryId != null
                        ? 'No products in this category'
                        : 'No products found',
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final count = _crossAxis(constraints.maxWidth);
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: count,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: _ratio(count),
                      ),
                      itemBuilder: (_, i) =>
                          ProductCard(product: products[i]),
                    );
                  },
                ),
    );
  }
}
