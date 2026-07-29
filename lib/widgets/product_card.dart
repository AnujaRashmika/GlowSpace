import 'package:flutter/material.dart';

import '../models/product.dart';
import 'product_card_shimmer.dart';


class ProductCard extends StatelessWidget {

  final Product? product;
  final bool isLoading;


  const ProductCard({
    super.key,
    this.product,
    this.isLoading = false,
  });


  @override
  Widget build(BuildContext context) {


    // SHOW SHIMMER WHILE LOADING
    if (isLoading) {

      return const ProductCardShimmer();

    }


    return Container(

      width: 170,

      margin: const EdgeInsets.all(8),


      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(15),


        boxShadow: const [

          BoxShadow(

            color: Colors.black12,

            blurRadius: 8,

            offset: Offset(0, 3),

          )

        ],

      ),


      child: Column(

        mainAxisSize: MainAxisSize.min,

        crossAxisAlignment: CrossAxisAlignment.start,


        children: [


          // PRODUCT IMAGE

          ClipRRect(

            borderRadius: const BorderRadius.vertical(

              top: Radius.circular(15),

            ),


            child: SizedBox(

              height: 130,

              width: double.infinity,


              child: Image.network(

                product!.imageUrls.first,


                fit: BoxFit.cover,


                loadingBuilder: (context, child, loadingProgress) {


                  if (loadingProgress == null) {

                    return child;

                  }


                  return Container(

                    color: Colors.grey.shade200,

                    child: const Center(

                      child: CircularProgressIndicator(

                        strokeWidth: 2,

                      ),

                    ),

                  );

                },


                errorBuilder: (context, error, stackTrace) {


                  return Container(

                    color: Colors.grey.shade200,


                    child: const Center(

                      child: Icon(

                        Icons.image_not_supported,

                        color: Colors.grey,

                      ),

                    ),

                  );

                },

              ),

            ),

          ),



          // PRODUCT DETAILS

          Padding(

            padding: const EdgeInsets.all(10),


            child: Column(

              mainAxisSize: MainAxisSize.min,


              crossAxisAlignment: CrossAxisAlignment.start,


              children: [



                Text(

                  product!.name,


                  maxLines: 2,


                  overflow: TextOverflow.ellipsis,


                  style: const TextStyle(

                    fontSize: 14,

                    fontWeight: FontWeight.w600,

                  ),

                ),



                const SizedBox(height: 6),



                Text(

                  "\$${product!.discountPrice}",


                  style: const TextStyle(

                    fontSize: 16,

                    fontWeight: FontWeight.bold,

                  ),

                ),



                const SizedBox(height: 3),



                Text(

                  "\$${product!.price}",


                  style: const TextStyle(

                    fontSize: 13,

                    color: Colors.grey,

                    decoration: TextDecoration.lineThrough,

                  ),

                ),


              ],

            ),

          ),


        ],

      ),

    );

  }

}