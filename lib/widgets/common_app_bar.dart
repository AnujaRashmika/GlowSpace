import 'package:flutter/material.dart';

import '../screens/search/search_screen.dart';

class CommonAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final String title;
  final bool showBackButton;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {

    return AppBar(

      automaticallyImplyLeading: false,

      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      )
          : null,

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      actions: [

        GestureDetector(

          onTap: (){

            Navigator.push(

              context,

              MaterialPageRoute(
                builder: (_) => const SearchScreen(),
              ),

            );

          },

          child: Container(

            width: 220,

            margin: const EdgeInsets.symmetric(
              vertical: 10,
            ),

            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),

            decoration: BoxDecoration(

              color: Colors.grey.shade200,

              borderRadius: BorderRadius.circular(30),

            ),

            child: const Row(

              children: [

                Icon(
                  Icons.search,
                  color: Colors.grey,
                ),

                SizedBox(width: 10),

                Text(
                  "Search products...",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

              ],

            ),

          ),

        ),

        const SizedBox(width: 12),

        IconButton(

          onPressed: () {},

          icon: const Icon(Icons.shopping_cart_outlined),

        ),

        const SizedBox(width: 5),

      ],

    );

  }

}