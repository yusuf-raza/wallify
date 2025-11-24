import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallify/infrastructure/utils/color_util.dart';
import 'package:wallify/infrastructure/utils/logger_service.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/wallpaper_detail/controllers/wallpaper_detail_view_model.dart';

class WallpaperDetailScreenNew extends StatelessWidget {
  const WallpaperDetailScreenNew({
    super.key,
    required this.imgUrl,
    required this.category,
    required this.dimensionX,
    required this.dimensionY,
    required this.size,
    required this.colors,
    required this.purity,
  });

  final String imgUrl;
  final String category;
  final int dimensionX;
  final int dimensionY;
  final List<dynamic> colors;
  final int size;
  final String purity;

  @override
  Widget build(BuildContext context) {
    LoggerService.logInfo('colors ${colors[1]}');
    final Color primaryColor = fromHex(colors[0]);
    final Color secondaryColor = fromHex(colors[1]);

    return ChangeNotifierProvider<WallpaperDetailViewModel>(
      create: (_) => WallpaperDetailViewModel(),
      child: Consumer<WallpaperDetailViewModel>(
        builder: (BuildContext context, WallpaperDetailViewModel viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.keyboard_backspace, color: primaryColor),
              ),
              backgroundColor: secondaryColor,
            ),
            backgroundColor: secondaryColor,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: .circular(20),
                    child: Hero(
                      tag: imgUrl,
                      child: CachedNetworkImage(
                        height: 300.h,
                        width: 300.w,
                        imageUrl: imgUrl,
                        fit: BoxFit.cover,
                        placeholder: (BuildContext context, String url) => Shimmer.fromColors(
                          baseColor: secondaryColor,
                          highlightColor: primaryColor,
                          child: Container(
                            height: 300.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: .circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: <Widget>[
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.favorite_border, color: primaryColor),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: <Widget>[
                          _buildButton(
                            icon: Icons.save_alt,
                            label: 'Save',
                            color: primaryColor,
                            onTap: () => viewModel.saveWallpaper(imgUrl),
                            isDownloading: viewModel.isDownloading,
                          ),
                          _buildButton(
                            icon: Icons.image_outlined,
                            label: 'Set',
                            color: primaryColor,
                            onTap: () => viewModel.downloadAndSetWallpaper(imgUrl),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Column(
                    spacing: 3.h,
                    children: <Widget>[
                      _buildInfoRow(icon: Icons.category, text: category, color: primaryColor),
                      _buildInfoRow(
                        icon: Icons.photo_size_select_actual_outlined,
                        text: '$dimensionX x $dimensionY',
                        color: primaryColor,
                      ),
                      _buildInfoRow(
                        icon: Icons.folder,
                        text: '${(size / (1024 * 1024)).toStringAsFixed(2)} MB',
                        color: primaryColor,
                      ),
                      _buildInfoRow(
                        icon: Icons.privacy_tip_outlined,
                        text: purity,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isDownloading = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(30.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: .circular(30.r),
            border: Border.all(color: color, width: 2.w),
          ),
          child: isDownloading
              ? const CircularProgressIndicator()
              : Row(
                  spacing: 3.w,
                  children: <Widget>[
                    Icon(icon, color: color),
                    Text(label, style: TextStyle(color: color)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text, required Color color}) {
    return Row(
      spacing: 3.w,
      children: <Widget>[
        Icon(icon, color: color),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}
