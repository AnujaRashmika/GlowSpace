import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/colors.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/common_app_bar.dart';
import '../orders/orders_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      _nameCtrl.text = user.name;
      _emailCtrl.text = user.email;
      _phoneCtrl.text = user.phone ?? '';
      _addressCtrl.text = user.address ?? '';
      _cityCtrl.text = user.city ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    final orderProvider = context.read<OrderProvider>();

    final items = cart.items
        .map((i) => OrderItem(
              productId: i.product.id,
              name: i.product.name,
              price: i.product.finalPrice,
              imageUrl:
                  i.product.imageUrls.isNotEmpty ? i.product.imageUrls.first : '',
              quantity: i.quantity,
            ))
        .toList();

    final order = OrderModel(
      id: '',
      userId: auth.user!.uid,
      customerName: _nameCtrl.text.trim(),
      customerPhone: _phoneCtrl.text.trim(),
      customerEmail: _emailCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      items: items,
      subtotal: cart.subtotal,
      discount: 0,
      total: cart.subtotal,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    final id = await orderProvider.placeOrder(order);
    if (!mounted) return;

    if (id != null) {
      cart.clearCart();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success, size: 28),
              SizedBox(width: 10),
              Text('Order Placed!'),
            ],
          ),
          content: Text('Your order #$id has been placed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((r) => r.isFirst);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OrdersScreen()),
                );
              },
              child: const Text('View Orders'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((r) => r.isFirst);
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(orderProvider.error ?? 'Failed to place order'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final isWide = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: const CommonAppBar(
        title: 'Checkout',
        showBack: true,
        showCart: false,
        showSearch: false,
      ),
      body: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _form()),
                Expanded(flex: 2, child: _summary(cart, orderProvider)),
              ],
            )
          : Column(
              children: [
                Expanded(child: _form()),
                _summary(cart, orderProvider),
              ],
            ),
    );
  }

  Widget _form() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Delivery Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name *'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone *'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email *'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Address *'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cityCtrl,
              decoration: const InputDecoration(labelText: 'City *'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteCtrl,
              maxLines: 2,
              decoration:
                  const InputDecoration(labelText: 'Order Note (optional)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary(CartProvider cart, OrderProvider orderProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Order Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...cart.items.map((i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${i.product.name} x${i.quantity}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Text(
                        'Rs ${i.total.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  'Rs ${cart.subtotal.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: orderProvider.isPlacing ? null : _placeOrder,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: orderProvider.isPlacing
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
