import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallify/data/models/wallhaven_wallpaper.dart';
import 'package:wallify/infrastructure/common/custom_app_bar.dart';
import 'package:wallify/infrastructure/common/custom_circular_progress_indicator.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/favourite/controllers/favourite_view_model.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Consumer<FavouriteViewModel>(
        builder: (BuildContext context, FavouriteViewModel favouriteViewModel, Widget? child) {
          if (favouriteViewModel.isLoading) {
            return const Center(child: CustomCircularProgressIndicator());
          }
          if (favouriteViewModel.favouriteWallpapers.isEmpty) {
            return Center(
              child: Text('No favourite wallpapers yet!', style: TextStyle(fontSize: 20.px)),
            );
          }
          return CarouselSlider.builder(
            itemCount: favouriteViewModel.favouriteWallpapers.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              final WallhavenWallpaper wallpaper = favouriteViewModel.favouriteWallpapers[index];
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: wallpaper.path!,
                      fit: BoxFit.cover,
                      width: 1000.0,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      alignment: Alignment.centerRight,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.1),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          favouriteViewModel.addOrRemoveFavourite(wallpaper);
                        },
                        icon: Icon(
                          favouriteViewModel.isFavourite(wallpaper)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.8,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
            ),
          );
        },
      ),
    );
  }
}
