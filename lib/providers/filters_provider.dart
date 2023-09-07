import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_provider.dart';

import '../screens/filters.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  // change data immutably
  void setFilter(Filter filter, bool isActive) {
    //state[filter] = isActive --> not allowed ... mutating state
    state = {
      ...state, // copies the key-value pairs into this new map
      filter: isActive, // overrides this one key-value pair
    };
  }

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }
}

// the provider below returns an instance of FiltersNotifier
// add generic type annotations to get better typing support
// in the places where we use the provider.
// the notifier will refer to the FiltersProvider,
// which will inturn resolve to a map of Filters and boolean values.
final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
        (ref) => FiltersNotifier());

// create provide that depends on both meals provider and filers provider
final filteredMealsProvider = Provider((ref) {
  // set up a watcher for meals provider
  // this will ensure this function is re-executed whenever the
  // meals provider value changes.
  // also any widgets that depend on this will also be updated.
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
