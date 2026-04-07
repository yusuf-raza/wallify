import 'package:easy_animated_indexed_stack/easy_animated_indexed_stack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:wallify/infrastructure/constants/app_strings.dart';
import 'package:wallify/infrastructure/theme/app_colors.dart';
import 'package:wallify/infrastructure/theme/theme_view_model.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';
import 'package:wallify/presentation/home/controllers/home_view_model.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeVM>(
      builder: (BuildContext context, HomeVM controller, Widget? child) {
        final bool isDesktop = context.isDesktop;

        return Scaffold(
          body: isDesktop
              ? Row(
                  children: <Widget>[
                    SafeArea(
                      child: Container(
                        width: 240,
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Theme.of(context).dividerColor.withOpacity(0.08),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                AppStrings.appTitle,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: NavigationRail(
                                selectedIndex: controller.currentIndex,
                                onDestinationSelected: controller.changeIndex,
                                extended: true,
                                backgroundColor: Colors.transparent,
                                indicatorColor: AppColors.purple.withOpacity(0.14),
                                destinations: <NavigationRailDestination>[
                                  NavigationRailDestination(
                                    icon: const Icon(Icons.home_outlined),
                                    selectedIcon: const Icon(Icons.home),
                                    label: Text(AppStrings.home),
                                  ),
                                  NavigationRailDestination(
                                    icon: const Icon(Icons.category_outlined),
                                    selectedIcon: const Icon(Icons.category),
                                    label: Text(AppStrings.category),
                                  ),
                                  NavigationRailDestination(
                                    icon: const Icon(Icons.favorite_border),
                                    selectedIcon: const Icon(Icons.favorite),
                                    label: Text(AppStrings.favourite),
                                  ),
                                ],
                              ),
                            ),
                            Consumer<ThemeViewModel>(
                              builder:
                                  (
                                    BuildContext context,
                                    ThemeViewModel themeViewModel,
                                    Widget? child,
                                  ) => Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                                    child: FilledButton.tonalIcon(
                                      onPressed: themeViewModel.toggleTheme,
                                      icon: Icon(
                                        themeViewModel.isDarkMode
                                            ? Icons.light_mode_outlined
                                            : Icons.dark_mode_outlined,
                                      ),
                                      label: Text(
                                        themeViewModel.isDarkMode ? 'Light mode' : 'Dark mode',
                                      ),
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: EasyAnimatedIndexedStack(
                        index: controller.currentIndex,
                        children: controller.screens,
                      ),
                    ),
                  ],
                )
              : EasyAnimatedIndexedStack(
                  index: controller.currentIndex,
                  children: controller.screens,
                ),
          bottomNavigationBar: isDesktop
              ? null
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double bottomPadding = MediaQuery.of(context).padding.bottom;
                    const double barHeight = 55;
                    final double totalHeight = barHeight + bottomPadding;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      height: controller.isBottomBarVisible ? totalHeight : 0,
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: controller.isBottomBarVisible ? 1 : 0,
                          child: SalomonBottomBar(
                            currentIndex: controller.currentIndex,
                            onTap: (int index) {
                              controller.changeIndex(index);
                            },
                            items: <SalomonBottomBarItem>[
                              SalomonBottomBarItem(
                                icon: const Icon(Icons.home),
                                title: Text(AppStrings.home),
                                selectedColor: AppColors.purple,
                              ),
                              SalomonBottomBarItem(
                                icon: const Icon(Icons.category),
                                title: Text(AppStrings.category),
                                selectedColor: AppColors.pink,
                              ),
                              SalomonBottomBarItem(
                                icon: const Icon(Icons.favorite),
                                title: Text(AppStrings.favourite),
                                selectedColor: AppColors.orange,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
