import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/banner_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/banner_shimmer.dart';
import '../../widgets/banner_slider.dart';
import '../../widgets/category_card.dart';
import '../../widgets/category_shimmer.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/product_card.dart';
import '../products/products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Screen width එකට අනුව column count එක
  int _getCrossAxisCount(double width) {
    if (width >= 1200) return 6; // Large desktop
    if (width >= 900) return 5; // Small desktop / laptop
    if (width >= 600) return 4; // Tablet
    return 2; // Mobile
  }

  // Column ගණන අනුව card shape එක
  double _getAspectRatio(int crossAxisCount) {
    if (crossAxisCount >= 6) return 0.72;
    if (crossAxisCount >= 5) return 0.70;
    if (crossAxisCount >= 4) return 0.68;
    return 0.56; // Mobile
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );

      await productProvider.loadProducts();

      Provider.of<SearchProvider>(
        context,
        listen: false,
      ).setProducts(productProvider.products);

      Provider.of<CategoryProvider>(
        context,
        listen: false,
      ).loadCategories();

      Provider.of<BannerProvider>(
        context,
        listen: false,
      ).loadBanners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    final featuredProducts = productProvider.featuredProducts;
    final allProducts = productProvider.products;

    final categoryProvider = Provider.of<CategoryProvider>(context);
    final bannerProvider = Provider.of<BannerProvider>(context);

    return Scaffold(
      appBar: const CommonAppBar(
        title: "GlowSpace",
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bannerProvider.isLoading
                ? const BannerShimmer()
                : BannerSlider(
              banners: bannerProvider.banners,
            ),

            // CATEGORIES
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Categories",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: categoryProvider.isLoading
                    ? ListView.builder(
                  key: const ValueKey("categoryShimmer"),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const CategoryShimmer();
                  },
                )
                    : ListView.builder(
                  key: const ValueKey("categories"),
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      category: categoryProvider.categories[index],
                    );
                  },
                ),
              ),
            ),

            // FEATURED PRODUCTS
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Featured Products",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 270,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: productProvider.isLoading
                    ? ListView.builder(
                  key: const ValueKey("shimmer"),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: const SizedBox(
                        width: 170,
                        child: ProductCard(
                          isLoading: true,
                        ),
                      ),
                    );
                  },
                )
                    : featuredProducts.isEmpty
                    ? const Center(
                  key: ValueKey("empty"),
                  child: Text(
                    "No featured products available",
                  ),
                )
                    : ListView.builder(
                  key: const ValueKey("products"),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: featuredProducts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: 170,
                        child: ProductCard(
                          product: featuredProducts[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ALL PRODUCTS HEADER + VIEW ALL
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "All Products",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductsScreen(
                            title: "All Products",
                          ),
                        ),
                      );
                    },
                    child: const Text("View All"),
                  ),
                ],
              ),
            ),

            // ALL PRODUCTS GRID (responsive preview)
            productProvider.isLoading
                ? const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
                : allProducts.isEmpty
                ? const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text("No products available"),
              ),
            )
                : LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount =
                _getCrossAxisCount(constraints.maxWidth);
                final aspectRatio =
                _getAspectRatio(crossAxisCount);

                final previewCount = allProducts.length > 6
                    ? 6
                    : allProducts.length;

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: previewCount,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: aspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: allProducts[index],
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}