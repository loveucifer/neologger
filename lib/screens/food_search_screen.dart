import 'package:flutter/material.dart';
import 'package:neologger/constants.dart';
import 'package:neologger/models/food.dart';
import 'package:neologger/providers/food_provider.dart';
import 'package:neologger/screens/food_detail_screen.dart';
import 'package:neologger/widgets/neologger_card.dart';
import 'package:neologger/widgets/neologger_search_bar.dart';
import 'package:neologger/widgets/fade_in_animation.dart';
import 'package:provider/provider.dart';

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load all foods when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FoodProvider>(context, listen: false).loadFoods();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    Provider.of<FoodProvider>(context, listen: false)
        .searchFoods(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Food Search',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppFonts.headline3,
                fontWeight: AppFonts.semiBold,
              ),
            ),
            pinned: true,
            backgroundColor: AppColors.background,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  NeologgerSearchBar(
                    controller: _searchController,
                    onSearch: _performSearch,
                    hintText: 'Search for Indian foods...',
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          if (foodProvider.isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_searchController.text.isEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return FadeInAnimation(
                    delay: Duration(milliseconds: 100 + (index * 50)),
                    child: _FoodListItem(
                      food: foodProvider.foods[index],
                      onTap: () {
                        // For meal logging, return the selected food
                        if (ModalRoute.of(context)?.settings.name == null) {
                          Navigator.of(context).pop(foodProvider.foods[index]);
                        } else {
                          // For regular navigation, go to detail screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodDetailScreen(
                                food: foodProvider.foods[index],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
                childCount: foodProvider.foods.length,
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return FadeInAnimation(
                    delay: Duration(milliseconds: 100 + (index * 50)),
                    child: _FoodListItem(
                      food: foodProvider.foods[index],
                      onTap: () {
                        // For meal logging, return the selected food
                        if (ModalRoute.of(context)?.settings.name == null) {
                          Navigator.of(context).pop(foodProvider.foods[index]);
                        } else {
                          // For regular navigation, go to detail screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodDetailScreen(
                                food: foodProvider.foods[index],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
                childCount: foodProvider.foods.length,
              ),
            ),
        ],
      ),
    );
  }
}

class _FoodListItem extends StatelessWidget {
  final Food food;
  final VoidCallback onTap;

  const _FoodListItem({
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeologgerCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Food icon placeholder
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.fastfood,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: TextStyle(
                      fontSize: AppFonts.bodyLarge,
                      fontWeight: AppFonts.semiBold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    food.groupName,
                    style: TextStyle(
                      fontSize: AppFonts.bodySmall,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Nutrition badges in a scrollable row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _NutritionBadge(
                          label: 'Cal',
                          value: food.energyKcal.toStringAsFixed(0),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _NutritionBadge(
                          label: 'Protein',
                          value: '${food.proteinG.toStringAsFixed(1)}g',
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _NutritionBadge(
                          label: 'Carbs',
                          value: '${food.carbohydratesG.toStringAsFixed(1)}g',
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        _NutritionBadge(
                          label: 'Fat',
                          value: '${food.fatG.toStringAsFixed(1)}g',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionBadge extends StatelessWidget {
  final String label;
  final String value;

  const _NutritionBadge({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundSecondary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: AppFonts.caption,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}