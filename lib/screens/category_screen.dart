import 'package:flutter/material.dart';
import 'package:meals/models/category.dart';
import 'package:meals/screens/meals.dart';
import '../models/meal.dart';
import '../widgets/category_grid_item.dart';
import '../data/dummy_data.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({
    Key? key,
    required this.availableMeals,
  }) : super(key: key);

  final List<Meal> availableMeals;

  void _selectedCategory(BuildContext context, Category category) {
    final specific =
        availableMeals.where((meal) => meal.categories.contains(category.id));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealScreen(
          title: category.title,
          meals: specific.toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: availableCats
            .map(
              (category) => CategoryGridItem(
                category: category,
                onSelectCategory: () {
                  _selectedCategory(context, category);
                },
              ),
            )
            .toList(),
      );
}

class Textt extends StatelessWidget {
  const Textt({super.key, required this.data});
  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }
}
