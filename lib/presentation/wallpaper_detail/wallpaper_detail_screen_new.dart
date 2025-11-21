import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallify/infrastructure/navigation/app_router.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';

class WallpaperDetailScreenNew extends StatelessWidget {
  const WallpaperDetailScreenNew({
    super.key,
    required this.imgUrl,
    required this.category,
    required this.dimensionX,
    required this.dimensionY,

    required this.size,
    required this.colors,
  });

  final String imgUrl;
  final String category;
  final int dimensionX;
  final int dimensionY;
  final List<dynamic> colors;
  final int size;

  @override
  Widget build(BuildContext context) {
    LoggerService.logInfo('colors ${colors[1]}');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go(AppRouter.base),
          icon: const Icon(Icons.keyboard_backspace),
        ),
        backgroundColor: Color(int.parse('0xFF${colors[1].replaceFirst('#', '')}')),
      ),
      backgroundColor: Color(int.parse('0xFF${colors[1].replaceFirst('#', '')}')),

      body: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: .circular(20),
            child: SizedBox(
              height: 300.h,
              width: 300.w,
              child: CachedNetworkImage(imageUrl: imgUrl, fit: BoxFit.cover),
            ),
          ),

          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Row(children: <Widget>[const Icon(Icons.category), Text(category)]),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.photo_size_select_actual_outlined),
                      Text(dimensionX.toString() + ' x ' + dimensionY.toString()),
                    ],
                  ),
                ],
              ),

              Row(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(Icons.folder),
                      Text('${(size / (1024 * 1024)).toStringAsFixed(2)} MB'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
