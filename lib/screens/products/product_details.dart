import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../widgets/common_app_bar.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _currentImage = 0;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final bool hasDiscount =
        product.discountPrice > 0 &&
            product.discountPrice < product.price;

    final double finalPrice =
    hasDiscount ? product.discountPrice : product.price;

    return Scaffold(
      appBar: const CommonAppBar(
        title: 'GlowSpace',
        showBackButton: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGE SLIDER
            SizedBox(
              height: 350,
              child: Stack(
                children: [

                  PageView.builder(
                    itemCount: product.imageUrls.length,

                    onPageChanged: (index) {
                      setState(() {
                        _currentImage = index;
                      });
                    },

                    itemBuilder: (context, index) {
                      return Image.network(
                        product.imageUrls[index],

                        width: double.infinity,

                        fit: BoxFit.contain,

                        errorBuilder:
                            (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 60,
                            ),
                          );
                        },
                      );
                    },
                  ),

                  // IMAGE INDICATORS
                  if (product.imageUrls.length > 1)
                    Positioned(
                      bottom: 15,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: List.generate(
                          product.imageUrls.length,
                              (index) {
                            return Container(
                              margin:
                              const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              width: _currentImage == index
                                  ? 20
                                  : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color:
                                _currentImage == index
                                    ? Colors.black
                                    : Colors.grey,
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // PRODUCT DETAILS
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  // NAME
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // PRICE
                  Row(
                    children: [

                      Text(
                        'Rs. ${finalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      if (hasDiscount) ...[
                        const SizedBox(width: 10),

                        Text(
                          'Rs. ${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            decoration:
                            TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          '${(((product.price - product.discountPrice) / product.price) * 100).round()}% OFF',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 15),

                  // STOCK
                  Row(
                    children: [

                      const Text(
                        'Availability: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Text(
                        product.stock > 0
                            ? 'In Stock'
                            : 'Out of Stock',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: product.stock > 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Divider(),

                  const SizedBox(height: 15),

                  // DESCRIPTION
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // QUANTITY
                  const Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [

                            IconButton(
                              onPressed: _quantity > 1
                                  ? () {
                                setState(() {
                                  _quantity--;
                                });
                              }
                                  : null,
                              icon: const Icon(
                                Icons.remove,
                              ),
                            ),

                            Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            IconButton(
                              onPressed:
                              _quantity < product.stock
                                  ? () {
                                setState(() {
                                  _quantity++;
                                });
                              }
                                  : null,
                              icon: const Icon(
                                Icons.add,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ADD TO CART
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: product.stock > 0
                          ? () {
                        // Cart logic - next step
                      }
                          : null,
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // BUY NOW
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: product.stock > 0
                          ? () {
                        // Buy now - later
                      }
                          : null,
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}