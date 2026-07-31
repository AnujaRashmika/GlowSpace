import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/category_card.dart';
import '../../widgets/category_shimmer.dart';
import '../../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).loadProducts();

      Provider.of<CategoryProvider>(
        context,
        listen: false,
      ).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {

    final productProvider =
    Provider.of<ProductProvider>(context);

    final featuredProducts =
        productProvider.featuredProducts;

    final categoryProvider =
    Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "GlowSpace",
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                duration: const Duration(
                  milliseconds: 400,
                ),
                child: categoryProvider.isLoading
                    ?
                ListView.builder(
                  key: const ValueKey(
                    "categoryShimmer",
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context,index){
                    return const CategoryShimmer();
                  },
                )
                    :
                ListView.builder(
                  key: const ValueKey(
                    "categories",
                  ),

                  scrollDirection: Axis.horizontal,
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context,index){
                    return CategoryCard(
                      category: categoryProvider.categories[index],
                    );
                  },
                ),
              ),
            ),

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
                duration: const Duration(
                  milliseconds: 400,
                ),
                child: productProvider.isLoading
                    ?
                // SHIMMER
                ListView.builder(
                  key: const ValueKey(
                    "shimmer",
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context,index){

                    return const ProductCard(
                      isLoading: true,
                    );
                  },
                )
                    :
                featuredProducts.isEmpty
                    ?

                const Center(
                  key: ValueKey(
                    "empty",
                  ),

                  child: Text(
                    "No featured products available",
                  ),
                )
                    :

                ListView.builder(
                  key: const ValueKey(
                    "products",
                  ),

                  scrollDirection: Axis.horizontal,
                  itemCount: featuredProducts.length,
                  itemBuilder: (context,index){

                    return ProductCard(
                      product: featuredProducts[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}