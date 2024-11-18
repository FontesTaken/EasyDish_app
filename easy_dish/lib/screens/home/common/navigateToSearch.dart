import 'package:flutter/material.dart';
import '../../../data_classes/recipe.dart';
import '../../search/search_results_page.dart';

void navigateToSearchResults(BuildContext context, String searchQuery, List<Recipe> results) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SearchResultsPage(
        filteredRecipes: results,
        searchQuery: searchQuery,
      ),
    ),
  );
}