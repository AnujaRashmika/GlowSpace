import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/colors.dart';
import '../../models/product.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/product_card.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _qty = 1;
  int _imgIndex = 0;
  final _pageCtrl = PageController();

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 900;
    final all = context.watch<ProductProvider>().products;
    final similar = all
        .where((x) =>
            x.categoryId == p.categoryId && x.id != p.id && x.active)
        .take(8)
        .toList();

    return Scaffold(
      appBar: CommonAppBar(title: p.name, showBack: true),
      body: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: [
                        _imageSection(p),
                        if (similar.isNotEmpty) _similarSection(similar),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _infoSection(p),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _imageSection(p),
                  _infoSection(p),
                  if (similar.isNotEmpty) _similarSection(similar),
                  const SizedBox(height: 88),
                ],
              ),
            ),
      bottomNavigationBar: isWide
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: _addToCartButton(p),
              ),
            ),
    );
  }

  Widget _imageSection(Product p) {
    final images = p.imageUrls.isEmpty ? <String>[''] : p.imageUrls;
    return Column(
      children: [
        SizedBox(
          height: 340,
          child: PageView.builder(
            controller: _pageCtrl,
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _imgIndex = i),
            itemBuilder: (context, i) {
              return Container(
                color: AppColors.lightGrey,
                child: AppNetworkImage(
                  imageUrl: images[i],
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 340,
                ),
              );
            },
          ),
        ),
        if (images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _imgIndex == i ? 18 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _imgIndex == i
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
        if (images.length > 1)
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = _imgIndex == i;
                return GestureDetector(
                  onTap: () {
                    _pageCtrl.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Container(
                    width: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.lightGrey,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: AppNetworkImage(
                        imageUrl: images[i],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _infoSection(Product p) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (p.hasDiscount) ...[
                Text(
                  'Rs ${p.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                'Rs ${p.finalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              if (p.hasDiscount) ...[
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.discount.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${p.discountPercent}% OFF',
                    style: const TextStyle(
                      color: AppColors.discount,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: (p.stock > 0 ? AppColors.success : AppColors.error)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              p.stock > 0 ? 'In Stock (${p.stock})' : 'Out of Stock',
              style: TextStyle(
                color: p.stock > 0 ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            p.description.isEmpty ? 'No description available.' : p.description,
            style: const TextStyle(color: AppColors.grey, height: 1.55),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Text('Quantity',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed:
                          _qty > 1 ? () => setState(() => _qty--) : null,
                    ),
                    Text(
                      '$_qty',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: _qty < p.stock
                          ? () => setState(() => _qty++)
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (MediaQuery.sizeOf(context).width >= 900) _addToCartButton(p),
          const SizedBox(height: 12),
          Consumer2<AuthProvider, WishlistProvider>(
            builder: (context, auth, wishlist, _) {
              final isFav = wishlist.contains(p.id);
              return OutlinedButton.icon(
                onPressed: () {
                  if (!auth.isLoggedIn) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please login to use wishlist')),
                    );
                    return;
                  }
                  wishlist.toggle(auth.user!.uid, p.id);
                },
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: AppColors.primary,
                ),
                label:
                    Text(isFav ? 'Remove from Wishlist' : 'Add to Wishlist'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: AppColors.primary),
                  foregroundColor: AppColors.primary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _similarSection(List<Product> similar) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Text(
            'Similar Products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: similar.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 160,
                  child: ProductCard(product: similar[i]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _addToCartButton(Product p) {
    return ElevatedButton(
      onPressed: p.stock > 0
          ? () {
              context.read<CartProvider>().addToCart(p, quantity: _qty);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${p.name} added to cart'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          : null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(p.stock > 0 ? 'Add to Cart' : 'Out of Stock'),
    );
  }
}
