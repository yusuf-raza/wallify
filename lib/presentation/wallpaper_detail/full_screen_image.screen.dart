import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/common/custom_circular_progress_indicator.dart';

class FullScreenImageScreen extends StatelessWidget {
  const FullScreenImageScreen({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (BuildContext context, String url) =>
                    const Center(child: CustomCircularProgressIndicator()),
                errorWidget: (BuildContext context, String url, Object error) =>
                    const Icon(Icons.error),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
