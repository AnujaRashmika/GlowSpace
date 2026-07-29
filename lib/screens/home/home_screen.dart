import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
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

    });

  }



  @override
  Widget build(BuildContext context) {


    final productProvider =
    Provider.of<ProductProvider>(context);



    final featuredProducts =
        productProvider.featuredProducts;



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


                  itemCount: 5,



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