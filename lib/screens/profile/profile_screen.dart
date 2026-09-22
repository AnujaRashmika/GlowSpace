import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/common_app_bar.dart';
import '../orders/orders_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../../utils/page_transitions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    if (user == null) {
      return Scaffold(
        appBar: const CommonAppBar(title: 'Profile', showBack: true),
        body: const Center(child: Text('Not logged in')),
      );
    }

    return Scaffold(
      appBar: const CommonAppBar(title: 'My Profile', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              user.email,
              style: const TextStyle(color: AppColors.grey),
            ),
            if (user.phone != null && user.phone!.isNotEmpty)
              Text(user.phone!, style: const TextStyle(color: AppColors.grey)),
            const SizedBox(height: 28),
            _tile(
              icon: Icons.receipt_long_outlined,
              title: 'My Orders',
              onTap: () {
                pushFade(context, const OrdersScreen());
              },
            ),
            _tile(
              icon: Icons.favorite_border,
              title: 'Wishlist',
              onTap: () {
                pushFade(context, const WishlistScreen());
              },
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () async {
                context.read<WishlistProvider>().listen(null);
                context.read<OrderProvider>().listen(null);
                await auth.logout();
                if (context.mounted) {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                }
              },
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text('Logout',
                  style: TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
