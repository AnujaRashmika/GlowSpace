import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_card.dart';

/// Product card with entrance animation (stagger-friendly)
class AnimatedProductCard extends StatefulWidget {
  final Product? product;
  final bool isLoading;
  final int index;
  final Duration delay;

  const AnimatedProductCard({
    super.key,
    this.product,
    this.isLoading = false,
    this.index = 0,
    this.delay = Duration.zero,
  });

  @override
  State<AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<AnimatedProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _fade = Tween<double>(begin: 0, end: 1).animate(curve);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(curve);
    _scale = Tween<double>(begin: 0.94, end: 1.0).animate(curve);

    Future.delayed(widget.delay + Duration(milliseconds: widget.index * 45), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          child: ProductCard(
            product: widget.product,
            isLoading: widget.isLoading,
          ),
        ),
      ),
    );
  }
}
