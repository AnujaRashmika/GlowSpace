import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/search_provider.dart';
import '../products/products_screen.dart';
import 'search_result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        titleSpacing: 0,

        title: TextField(

          controller: _controller,

          autofocus: true,

          onChanged: (value){

            context.read<SearchProvider>()
                .searchSuggestions(value);

          },

          onSubmitted: (value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductsScreen(
                  title: "Search Results",
                  query: value,
                ),
              ),

            );
          },

          decoration: InputDecoration(

            hintText: "Search products",

            prefixIcon: const Icon(Icons.search),

            filled: true,

            fillColor: Colors.grey.shade200,

            border: OutlineInputBorder(

              borderRadius: BorderRadius.circular(30),

              borderSide: BorderSide.none,

            ),

          ),

        ),

      ),

      body: Consumer<SearchProvider>(

        builder: (context, provider, child){

          return ListView.builder(

            itemCount: provider.suggestions.length,

            itemBuilder: (context,index){

              final product =
              provider.suggestions[index];

              return ListTile(

                leading: CircleAvatar(

                  backgroundImage:
                  NetworkImage(
                    product.imageUrls.first,
                  ),

                ),

                title: Text(product.name),

                trailing:
                const Icon(Icons.north_west),

                onTap: (){

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_)=>SearchResultScreen(
                        query: product.name,
                      ),

                    ),

                  );

                },

              );

            },

          );

        },

      ),

    );

  }

}