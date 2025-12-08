import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerGridItem extends StatelessWidget {
  const ShimmerGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        // Using a common aspect ratio for shimmer placeholders.
        // In a real app, you might want to vary this or derive it from expected content.
        aspectRatio: 16 / 9, 
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.white, // The color of the shimmering area
          ),
        ),
      ),
    );
  }
}
