import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../models/banner_model.dart';
import 'app_network_image.dart';

class BannerSlider extends StatefulWidget {
  final List<BannerModel> banners;

  const BannerSlider({
    super.key,
    required this.banners,
  });

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _current = 0;

  double _bannerHeight(double width) {
    if (width >= 1200) return 420;
    if (width >= 900) return 360;
    if (width >= 600) return 280;
    return 180;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = _bannerHeight(width);
        final isMobile = width < 600;

        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: widget.banners.length,
              itemBuilder: (context, index, realIndex) {
                final banner = widget.banners[index];
                return Padding(
                  key: ValueKey('banner_${banner.id}'),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 20,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                    child: ColoredBox(
                      color: const Color(0xFFFBC7CE),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AppNetworkImage(
                            imageUrl: banner.image,
                            width: double.infinity,
                            height: height,
                            fit: BoxFit.cover,
                            placeholder: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFBC7CE),
                                    Color(0xFFF4A7B0),
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            errorWidget: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFBC7CE),
                                    Color(0xFFF4A7B0),
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                          if (banner.title != null &&
                              banner.title!.isNotEmpty)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.55),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Text(
                                  banner.title!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 14 : 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: height,
                autoPlay: true,
                enlargeCenterPage: !isMobile,
                viewportFraction: isMobile ? 1.0 : 0.88,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration:
                    const Duration(milliseconds: 700),
                autoPlayCurve: Curves.easeInOutCubic,
                pauseAutoPlayOnTouch: true,
                enableInfiniteScroll: widget.banners.length > 1,
                onPageChanged: (index, reason) {
                  setState(() => _current = index);
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.banners.asMap().entries.map((entry) {
                final isActive = _current == entry.key;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: isActive ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: isActive
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.3),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
