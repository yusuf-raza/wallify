import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/common/custom_circular_progress_indicator.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';

class SliderItem extends StatelessWidget {
  const SliderItem({super.key, required this.index, required this.imgList});

  final int index;
  final List<String> imgList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: imgList[index],
              progressIndicatorBuilder:
                  (BuildContext context, String url, DownloadProgress downloadProgress) =>
                      const Center(
                        child: CustomProgressIndicator.CustomProgressIndicator(
                          color: AppColors.white,
                        ),
                      ),
              errorWidget: (BuildContext context, String url, Object error) =>
                  const Icon(Icons.error),
            ),
            Image.network(imgList[index], fit: BoxFit.cover, width: 1000.0, height: 600.0),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[AppColors.black.withOpacity(0.8), AppColors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  'No. $index image',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
