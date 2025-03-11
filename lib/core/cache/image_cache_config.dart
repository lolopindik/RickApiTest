// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rick_test/config/theme/app_theme.dart';
import 'package:rick_test/core/cache/cache_manager.dart';

class ImageCacheConfig {
  static Widget getNetworkImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(
          color: RickAndMortyColors.secondaryColor,
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      cacheManager: AppCacheManager().imageCacheManager,
      maxHeightDiskCache: 1080,
      memCacheHeight: 1080,
    );
  }
} 