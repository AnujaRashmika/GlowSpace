import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/product_card.dart';

class SearchResultScreen extends StatelessWidget {
  final String query;

  const SearchResultScreen({
    super.key,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    final results = provider.searchResult(query);

    return Scaffold(
      appBar: CommonAppBar(
        title: query,
        showBackButton: true,
      ),
      body: results.isEmpty
          ? const Center(
        child: Text("No products found"),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: results.length,
        gridDelegate:
        const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 190,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.58,
        ),
        itemBuilder: (context, index) {
          return ProductCard(
            product: results[index],
          );
        },
      ),
    );
  }
}