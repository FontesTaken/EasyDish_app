// home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app_test/screens/guest/enter_app_options.dart';
import 'package:flutter_app_test/screens/home/menu/menuDrawer.dart';
import 'package:flutter_app_test/screens/home/recipeList/recipeList.dart';
import 'package:flutter_app_test/screens/home/searchBar/searchBar.dart';
import '../aboutUs/about_us.dart';
import '../../data_classes/user_data.dart';
import '../../data_classes/recipe.dart';
import '../../data_classes/recipe_data.dart';
import '../recipe/recipe_detail_page.dart';
import '../search/search_results_page.dart';
import '../auxiliary/tag_widget.dart';
import 'filter/filterDialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<String> _sortedTags; // Sorted tags by frequency

  @override
  void initState() {
    super.initState();
    _sortedTags = _getSortedTagsByFrequency(); // Get sorted tags on init
  }

  // Collect and sort tags based on their frequency of occurrence
  List<String> _getSortedTagsByFrequency() {
    final Map<String, int> tagFrequency = {};

    // Count each tag occurrence across all recipes
    for (var recipe in RecipeData.recipes) {
      for (var tag in recipe.tags) {
        tagFrequency[tag] = (tagFrequency[tag] ?? 0) + 1;
      }
    }

    // Sort tags by frequency in descending order
    final sortedTags = tagFrequency.keys.toList();
    sortedTags.sort((a, b) => tagFrequency[b]!.compareTo(tagFrequency[a]!));

    return sortedTags;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent back navigation
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.orange.withOpacity(0.19),
        appBar: AppBar(
          backgroundColor: Colors.orange.withOpacity(0.01),
          title: const Text(
              'Recipes',
              style: TextStyle(
                color: Color(0xFFC08019),
                fontWeight: FontWeight.bold,
                fontSize: 28,
              )
          ),
          automaticallyImplyLeading: false, // Remove the back arrow
          scrolledUnderElevation: 0,
          actions: [
            if (UserData.instance.isLoggedIn)
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  color: const Color(0xFF885B0E),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.info),
                color: const Color(0xFF885B0E),
                onPressed: () {
                  // Navigate to the About Us page when not logged in
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutUsPage()),
                  );
                },
              ),
          ],
        ),
        endDrawer: menuDrawer(context),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
              children: [
                searchBar(context),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  color: const Color(0xFF885B0E),
                  onPressed: () => showFilterDialog(context, _sortedTags),
                ),
                const SizedBox(height: 16),
              ]),
              const SizedBox(height: 12),
              recipeList()
            ],
          ),
        ),
      ),
    );
  }
}
