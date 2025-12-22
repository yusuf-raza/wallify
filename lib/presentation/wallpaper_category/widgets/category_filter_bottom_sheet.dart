import 'package:flutter/material.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/wallpaper_category/controllers/wallpaper_category_view_model.dart';

class CategoryFilterBottomSheet extends StatelessWidget {
  const CategoryFilterBottomSheet({super.key, required this.viewModel});

  final CategoryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController controller) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[AppColors.purple, AppColors.pink, AppColors.orange],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: ListView(
                controller: controller,
                children: <Widget>[
                  Text(
                    AppStrings.categories,
                    style: TextStyle(
                      fontSize: 18.w,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: viewModel.filters.map((CategoryFilter filter) {
                      final bool isSelected = filter == viewModel.selectedFilter;
                      return ChoiceChip(
                        label: Text(filter.label, style: const TextStyle(color: Colors.white)),
                        selected: isSelected,
                        selectedColor: Colors.white.withOpacity(0.2),
                        backgroundColor: Colors.white.withOpacity(0.1),
                        onSelected: (_) {
                          viewModel.selectCategory(filter);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
