import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/colors.dart';
import '../../providers/product_provider.dart';
import '../../providers/search_provider.dart';
import '../../utils/page_transitions.dart';
import '../../widgets/app_network_image.dart';
import '../products/product_details.dart';
import 'search_result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    final products = context.read<ProductProvider>().products;
    context.read<SearchProvider>().setProducts(products);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _ctrl,
          focusNode: _focus,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
          ),
          onChanged: (q) {
            search.search(q);
            setState(() {});
          },
          onSubmitted: (q) {
            if (q.trim().isNotEmpty) {
              pushFade(context, SearchResultScreen(query: q.trim()));
            }
          },
        ),
        actions: [
          if (_ctrl.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _ctrl.clear();
                search.clear();
                setState(() {});
              },
            ),
        ],
      ),
      body: search.query.isEmpty
          ? const Center(
              child: Text(
                'Type to search products',
                style: TextStyle(color: AppColors.grey),
              ),
            )
          : search.suggestions.isEmpty
              ? const Center(child: Text('No results found'))
              : ListView.separated(
                  itemCount: search.suggestions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final p = search.suggestions[i];
                    final img =
                        p.imageUrls.isNotEmpty ? p.imageUrls.first : '';
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: AppNetworkImage(
                            imageUrl: img,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        p.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'Rs ${p.finalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(color: AppColors.primary),
                      ),
                      trailing: const Icon(Icons.north_west, size: 16),
                      onTap: () {
                        pushFade(context, ProductDetailsScreen(product: p));
                      },
                    );
                  },
                ),
    );
  }
}
