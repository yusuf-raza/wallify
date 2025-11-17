import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallify/infrastructure/common/custom_app_bar.dart';
import 'package:wallify/presentation/favourite/controllers/favourite_view_model.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final FavouriteViewModel favouriteController = Provider.of<FavouriteViewModel>(context);
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Center(child: Text('FavouriteScreen is working', style: TextStyle(fontSize: 20))),
    );
  }
}
