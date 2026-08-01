import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/banner_model.dart';

class BannerSlider extends StatelessWidget {
  final List<BannerModel> banners;

  const BannerSlider({
    super.key,
    required this.banners,
  });

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return CarouselSlider(
      items: banners.map((banner) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CachedNetworkImage(
                imageUrl: banner.image,
                width: double.infinity,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 300),
                // Loading වෙනකොට pink background එකක් + progress
                placeholder: (context, url) => Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFBC7CE), // light pink
                        Color(0xFFF4A7B0), // slightly deeper pink
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
                // Error unath ekama pink background eka
                errorWidget: (context, url, error) => Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
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
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 350,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.92,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 700),
        autoPlayCurve: Curves.easeInOutCubic,
      ),
    );
  }
}