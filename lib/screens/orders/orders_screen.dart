import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/colors.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/common_app_bar.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    final uid = context.read<AuthProvider>().user?.uid;
    context.read<OrderProvider>().listen(uid);
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) {
      return Scaffold(
        appBar: const CommonAppBar(title: 'My Orders', showBack: true),
        body: const Center(child: Text('Please login to view orders')),
      );
    }

    return Scaffold(
      appBar: const CommonAppBar(title: 'My Orders', showBack: true),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderProvider.orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_outlined,
                          size: 64, color: AppColors.grey.withValues(alpha: 0.5)),
                      const SizedBox(height: 12),
                      const Text('No orders yet',
                          style: TextStyle(color: AppColors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orderProvider.orders.length,
                  itemBuilder: (context, i) {
                    final order = orderProvider.orders[i];
                    return _OrderCard(
                      order: order,
                      statusColor: _statusColor(order.status),
                    );
                  },
                ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final Color statusColor;

  const _OrderCard({required this.order, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy, hh:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            dateFmt.format(order.createdAt),
            style: const TextStyle(fontSize: 12, color: AppColors.grey),
          ),
          const Divider(height: 20),
          ...order.items.take(3).map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item.name} x${item.quantity}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Text(
                      'Rs ${(item.price * item.quantity).toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              )),
          if (order.items.length > 3)
            Text(
              '+${order.items.length - 3} more items',
              style: const TextStyle(fontSize: 12, color: AppColors.grey),
            ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.items.length} item(s)',
                style: const TextStyle(color: AppColors.grey, fontSize: 13),
              ),
              Text(
                'Total: Rs ${order.total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${order.address}, ${order.city}',
            style: const TextStyle(fontSize: 12, color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
