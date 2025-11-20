import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';

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
      appBar: AppBar(),
      backgroundColor: Color(int.parse('0xFF${colors[0].replaceFirst('#', '')}')),

      body: Column(
        children: <Widget>[
          CachedNetworkImage(imageUrl: imgUrl, fit: BoxFit.cover),

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
