import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/banner_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/search_provider.dart';
import '../../utils/page_transitions.dart';
import '../../widgets/animated_product_card.dart';
import '../../widgets/banner_shimmer.dart';
import '../../widgets/banner_slider.dart';
import '../../widgets/category_card.dart';
import '../../widgets/category_shimmer.dart';
import '../../widgets/common_app_bar.dart';
import '../products/products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerCtrl;
  late Animation<double> _headerFade;

  int _getCrossAxisCount(double width) {
    if (width >= 1200) return 5;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  double _getAspectRatio(int crossAxisCount) {
    if (crossAxisCount >= 5) return 0.68;
    if (crossAxisCount >= 4) return 0.65;
    if (crossAxisCount >= 3) return 0.62;
    return 0.58;
  }

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _headerCtrl.forward();

    Future.microtask(() {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      productProvider.addListener(() {
        if (!productProvider.isLoading && mounted) {
          Provider.of<SearchProvider>(context, listen: false)
              .setProducts(productProvider.products);
        }
      });
    });
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final bannerProvider = context.watch<BannerProvider>();

    final featured = productProvider.featuredProducts;
    final allProducts = productProvider.products;
    final categories = categoryProvider.categories;

    return Scaffold(
      appBar: const CommonAppBar(title: 'GlowSpace'),
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () async {
          productProvider.loadProducts();
          categoryProvider.loadCategories();
          bannerProvider.loadBanners();
          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              FadeTransition(
                opacity: _headerFade,
                child: bannerProvider.isLoading
                    ? const BannerShimmer()
                    : BannerSlider(banners: bannerProvider.banners),
              ),

              FadeTransition(
                opacity: _headerFade,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 110,
                child: categoryProvider.isLoading
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: 6,
                        itemBuilder: (context, index) =>
                            const CategoryShimmer(),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(right: 12),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration:
                                Duration(milliseconds: 350 + index * 50),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 12 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: CategoryCard(category: category),
                          );
                        },
                      ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Text(
                  'Featured Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              SizedBox(
                height: 280,
                child: productProvider.isLoading
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: 5,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: SizedBox(
                            width: 160,
                            child: AnimatedProductCard(
                              isLoading: true,
                              index: index,
                            ),
                          ),
                        ),
                      )
                    : featured.isEmpty
                        ? const Center(child: Text('No featured products'))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: featured.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: SizedBox(
                                width: 160,
                                child: AnimatedProductCard(
                                  product: featured[index],
                                  index: index,
                                ),
                              ),
                            ),
                          ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Products',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        pushFade(
                          context,
                          const ProductsScreen(title: 'All Products'),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),

              productProvider.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : allProducts.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(child: Text('No products available')),
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final crossAxisCount =
                                _getCrossAxisCount(constraints.maxWidth);
                            final aspectRatio =
                                _getAspectRatio(crossAxisCount);
                            final previewCount = allProducts.length > 8
                                ? 8
                                : allProducts.length;

                            return GridView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 32),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: previewCount,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: aspectRatio,
                              ),
                              itemBuilder: (context, index) {
                                return AnimatedProductCard(
                                  product: allProducts[index],
                                  index: index,
                                  delay: const Duration(milliseconds: 80),
                                );
                              },
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
