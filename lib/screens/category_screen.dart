import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meals/models/category.dart';
import 'package:meals/screens/meals.dart';
import '../models/meal.dart';
import '../widgets/category_grid_item.dart';
import '../data/dummy_data.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    Key? key,
    required this.availableMeals,
  }) : super(key: key);

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<Category> availableCategories = [];

  void fetchCategories() async {
    List<Category> cats = [];
    const url = 'http://127.0.0.1:3000/categories';
    var dio = Dio();
    var response;
    try {
      response = await dio.get(url);

      if (response.statusCode == 200) {
        for (var data in response.data) {
          cats.add(Category.fromJson(data));
        }
      }
    } catch (e) {
      print(e.toString());
    }

    if (cats.isNotEmpty) {
      setState(() {
        availableCategories = cats;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _selectedCategory(BuildContext context, Category category) {
    final specific = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id));
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
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animationController,
        child: GridView(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          //children: availableCats
          children: availableCategories
              .map(
                (category) => CategoryGridItem(
                  category: category,
                  onSelectCategory: () {
                    _selectedCategory(context, category);
                  },
                ),
              )
              .toList(),
        ),
        builder: (context, child) => SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.3),
            end: const Offset(0, 0),
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        ),
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
