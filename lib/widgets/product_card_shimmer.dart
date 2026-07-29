import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ProductCardShimmer extends StatelessWidget {

  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {

    return Shimmer.fromColors(

      baseColor: Colors.grey.shade300,

      highlightColor: Colors.grey.shade100,


      child: Container(

        width: 170,

        margin: const EdgeInsets.all(8),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius: BorderRadius.circular(15),

        ),


        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [


            Container(

              height: 130,

              width: double.infinity,

              decoration: const BoxDecoration(

                color: Colors.white,

                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),

              ),

            ),



            Padding(

              padding: const EdgeInsets.all(10),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [


                  Container(

                    height: 15,

                    width: 130,

                    color: Colors.white,

                  ),



                  const SizedBox(height: 10),



                  Container(

                    height: 15,

                    width: 80,

                    color: Colors.white,

                  ),



                  const SizedBox(height: 8),



                  Container(

                    height: 12,

                    width: 60,

                    color: Colors.white,

                  ),


                ],

              ),

            )

          ],

        ),

      ),

    );

  }

}