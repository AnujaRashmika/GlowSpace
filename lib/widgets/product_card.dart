import 'package:flutter/material.dart';

import '../models/product.dart';


class ProductCard extends StatelessWidget {

  final Product product;


  const ProductCard({
    super.key,
    required this.product,
  });


  @override
  Widget build(BuildContext context) {

    return Container(

      width: 170,

      margin: const EdgeInsets.all(8),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(15),

        boxShadow: [

          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          )

        ],

      ),


      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [


          ClipRRect(

            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(15),
            ),

            child: Image.network(

              product.imageUrls.isNotEmpty
                  ? product.imageUrls.first
                  : "https://via.placeholder.com/150",

              height: 150,

              width: double.infinity,

              fit: BoxFit.cover,

            ),

          ),



          Padding(

            padding: const EdgeInsets.all(10),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [


                Text(

                  product.name,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(

                    fontWeight: FontWeight.bold,

                    fontSize: 15,

                  ),

                ),


                const SizedBox(height: 8),


                Text(

                  "\$${product.discountPrice}",

                  style: const TextStyle(

                    fontSize: 16,

                    fontWeight: FontWeight.bold,

                  ),

                ),


                Text(

                  "\$${product.price}",

                  style: const TextStyle(

                    decoration: TextDecoration.lineThrough,

                    color: Colors.grey,

                  ),

                ),


              ],

            ),

          )

        ],

      ),

    );

  }

}