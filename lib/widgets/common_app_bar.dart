import 'package:flutter/material.dart';
import 'store_header.dart';

/// App-wide top bar. Login + Cart stay on the right end.
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final bool showSearch;
  final bool showCart;
  final List<Widget>? actions;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.showSearch = true,
    this.showCart = true,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    // Do not inject long product names into the header — keeps Login/Cart on the right.
    return StoreHeader(
      showBack: showBack,
      pageTitle: null,
      embedSearch: showSearch,
    );
  }
}
