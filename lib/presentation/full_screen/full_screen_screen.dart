import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wallify/infrastructure/common/custom_circular_progress_indicator.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/utils/color_util.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/full_screen/controllers/full_screen_view_model.dart';
import 'package:wallify/presentation/full_screen/widgets/full_screen_action_bar.dart';

class FullScreenImageScreen extends StatefulWidget {
  const FullScreenImageScreen({super.key});

  @override
  State<FullScreenImageScreen> createState() => _FullScreenImageScreenState();
}

class _FullScreenImageScreenState extends State<FullScreenImageScreen>
    with SingleTickerProviderStateMixin {
  late final FullScreenVM _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<FullScreenVM>(context, listen: false);
    _viewModel.init(this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FullScreenVM>(
      builder: (BuildContext context, FullScreenVM viewModel, Widget? child) {
        final Color primaryColor = fromHex(viewModel.wallpaper.colors![0]);
        final String fullResUrl = viewModel.wallpaper.path ?? '';
        final String fallbackUrl =
            viewModel.wallpaper.thumbs?.large ?? fullResUrl;
        const double backgroundOpacity = 0.2;
        final bool isDesktop = context.isDesktop;

        return Scaffold(
          body: Stack(
            children: <Widget>[
              // Blurred background
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(fallbackUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(color: Colors.black.withOpacity(backgroundOpacity)),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Hero(
                  tag: viewModel.heroTag ??
                      viewModel.wallpaper.path ??
                      viewModel.wallpaper.id ??
                      'wallpaper-hero',
                  child: InteractiveViewer(
                    transformationController: viewModel.transformationController,
                    minScale: 1,
                    maxScale: 4,
                    panEnabled: true,
                    scaleEnabled: true,
                    boundaryMargin: EdgeInsets.all(isDesktop ? 0 : 200),
                    onInteractionEnd: viewModel.handleInteractionEnd,
                    child: RepaintBoundary(
                      key: viewModel.imageKey,
                      child: SizedBox.expand(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: viewModel.useHiRes,
                          builder: (BuildContext context, bool useHiRes, Widget? child) {
                            return CachedNetworkImage(
                              imageUrl: isDesktop
                                  ? (fullResUrl.isNotEmpty ? fullResUrl : fallbackUrl)
                                  : (useHiRes ? viewModel.wallpaper.path! : fallbackUrl),
                              fit: isDesktop ? BoxFit.cover : BoxFit.contain,
                              progressIndicatorBuilder:
                                  (BuildContext context, String url, DownloadProgress progress) =>
                                      const Center(
                                        child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: CustomProgressIndicator.CustomProgressIndicator(),
                                        ),
                                      ),
                              errorWidget: (BuildContext context, String url, Object error) =>
                                  const Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: isDesktop ? 24 : 60,
                left: isDesktop ? 24 : 10,
                child: IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.keyboard_backspace, color: AppColors.white),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: isDesktop ? 36 : 24,
                child: ResponsiveContent(
                  maxWidth: isDesktop ? 820 : context.contentMaxWidth,
                  child: FullScreenActionBar(
                    viewModel: viewModel,
                    primaryColor: primaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
