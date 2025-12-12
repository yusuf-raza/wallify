import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/utils/color_util.dart';

class FullScreenImageScreen extends StatelessWidget {
  const FullScreenImageScreen({super.key, required this.wallpaper});

  final WallhavenWallpaper wallpaper;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = fromHex(wallpaper.colors![0]);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Blurred background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(wallpaper.path!),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ),

          // Foreground image
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: Hero(
                tag: wallpaper.path!,
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4,
                  child: CachedNetworkImage(
                    imageUrl: wallpaper.path!,
                    fit: BoxFit.contain,
                    progressIndicatorBuilder:
                        (
                          BuildContext context,
                          String url,
                          DownloadProgress downloadProgress,
                        ) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(value: downloadProgress.progress),
                            const SizedBox(height: 10),
                            if (downloadProgress.progress != 1.0)
                              Material(
                                child: Text(
                                  'Fetching full resolution wallpaper... ${((downloadProgress.progress ?? 0) * 100).toStringAsFixed(0)}%',
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                          ],
                        ),
                    errorWidget: (BuildContext context, String url, Object error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 60,
            left: 10,
            child: IconButton.filled(
              //color: AppColors.white,
              style: IconButton.styleFrom(backgroundColor: primaryColor),

              onPressed: () => context.pop(),
              icon: const Icon(Icons.keyboard_backspace, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
