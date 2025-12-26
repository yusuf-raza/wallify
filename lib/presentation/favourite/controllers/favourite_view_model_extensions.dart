import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/presentation/favourite/controllers/favourite_view_model.dart';

extension FavouriteVMLabels on FavouriteVM {
  String get removeSelectionLabel => AppStrings.removeCount(selectedCount);
}
