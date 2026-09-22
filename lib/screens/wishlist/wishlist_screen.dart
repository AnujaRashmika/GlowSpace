import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/product_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    final uid = context.read<AuthProvider>().user?.uid;
    context.read<WishlistProvider>().listen(uid);
  }

  int _crossAxis(double w) {
    if (w >= 1200) return 5;
    if (w >= 900) return 4;
    if (w >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final products = context.watch<ProductProvider>().products;
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) {
      return Scaffold(
        appBar: const CommonAppBar(title: 'Wishlist', showBack: true),
        body: const Center(child: Text('Please login to view wishlist')),
      );
    }

    final wishProducts =
        products.where((p) => wishlist.contains(p.id)).toList();

    return Scaffold(
      appBar: const CommonAppBar(title: 'Wishlist', showBack: true),
      body: wishlist.isLoading
          ? const Center(child: CircularProgressIndicator())
          : wishProducts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border,
                          size: 64, color: AppColors.grey.withValues(alpha: 0.5)),
                      const SizedBox(height: 12),
                      const Text('Your wishlist is empty',
                          style: TextStyle(color: AppColors.grey)),
                    ],
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final count = _crossAxis(constraints.maxWidth);
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: wishProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: count,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.58,
                      ),
                      itemBuilder: (_, i) =>
                          ProductCard(product: wishProducts[i]),
                    );
                  },
                ),
    );
  }
}
