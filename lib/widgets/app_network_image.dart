import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../config/colors.dart';

/// Cross-platform network image. On web uses Image.network (avoids black frames
/// that sometimes happen with CachedNetworkImage + memCache on Flutter web).
class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  });

  Widget get _placeholder =>
      placeholder ??
      Container(
        width: width,
        height: height,
        color: AppColors.lightGrey,
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );

  Widget get _error =>
      errorWidget ??
      Container(
        width: width,
        height: height,
        color: AppColors.lightGrey,
        child: const Icon(Icons.image_not_supported_outlined,
            color: AppColors.grey),
      );

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return _error;

    if (kIsWeb) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        gaplessPlayback: true,
        filterQuality: FilterQuality.medium,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _placeholder;
        },
        errorBuilder: (context, error, stack) => _error,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: Duration.zero,
      placeholder: (_, __) => _placeholder,
      errorWidget: (_, __, ___) => _error,
    );
  }
}
