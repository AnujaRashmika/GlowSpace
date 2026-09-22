import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/product_card.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;

  const SearchResultScreen({super.key, required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SearchProvider>().search(widget.query);
  }

  int _crossAxis(double w) {
    if (w >= 1200) return 5;
    if (w >= 900) return 4;
    if (w >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final results = context.watch<SearchProvider>().results;

    return Scaffold(
      appBar: CommonAppBar(
        title: 'Results for "${widget.query}"',
        showBack: true,
      ),
      body: results.isEmpty
          ? const Center(child: Text('No products found'))
          : LayoutBuilder(
              builder: (context, constraints) {
                final count = _crossAxis(constraints.maxWidth);
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: count,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.58,
                  ),
                  itemBuilder: (_, i) => ProductCard(product: results[i]),
                );
              },
            ),
    );
  }
}
