// home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_app_test/enter_app_options.dart';
import 'about_us.dart';
import 'data_classes/user_data.dart';
import 'login_page.dart';
import 'recipe.dart';
import 'recipe_data.dart';
import 'recipe_detail_page.dart';
import 'search_results_page.dart';
import 'tag_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedTags = {}; // Stores selected tags for filtering
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

  // Function to handle search when the Enter key is pressed in the search bar
  void _handleSearch(String query) {
    final List<Recipe> filteredRecipes = RecipeData.recipes
        .where(
            (recipe) => recipe.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    _navigateToSearchResults(query, filteredRecipes);

    // Clear the search box after search
    _searchController.clear();
  }

  // Function to handle filter confirmation
  void _applyFilters() {
    final List<Recipe> filteredRecipes = _selectedTags.isEmpty
        ? RecipeData.recipes
        : RecipeData.recipes
            .where((recipe) =>
                _selectedTags.every((tag) => recipe.tags.contains(tag)))
            .toList();

    _navigateToSearchResults("Filtered", filteredRecipes);

    // Clear selected tags after search
    _selectedTags.clear();
  }

  void _clearFilters() {
    setState(() {
      _selectedTags.clear(); // Clear selected tags
    });
  }

  void _navigateToSearchResults(String searchQuery, List<Recipe> results) {
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

  // Show filter dialog with all tags sorted by frequency
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filter by Tags',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _sortedTags.length,
                      itemBuilder: (context, index) {
                        final tag = _sortedTags[index];
                        return CheckboxListTile(
                          title: Text(tag),
                          value: _selectedTags.contains(tag),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedTags.add(tag);
                              } else {
                                _selectedTags.remove(tag);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _clearFilters();
                          Navigator.pop(context); // Close the filter dialog
                        },
                        child: const Text('Clear'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog first
                          _applyFilters(); // Apply filters after dialog is closed
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent back navigation
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recipes'),
          automaticallyImplyLeading: false, // Remove the back arrow
          actions: [
            if (UserData.instance.isLoggedIn)
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.info),
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
        endDrawer: Drawer(
          child: Column(
            children: [
              if (UserData.instance.isLoggedIn) ...[
                // Menu items for logged-in users
                ListTile(
                  leading: const Icon(Icons.bookmark_border),
                  title: const Text('Bookmarks'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Create Recipe'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list_alt),
                  title: const Text('My Recipes'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Spacer(),
                const Divider(),
                ListTile(
                  title: const Text('About Us'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log Out'),
                  onTap: () {
                    Navigator.pop(context);
                    UserData.instance.isLoggedIn = false;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                          (route) => false,
                    );
                  },
                ),
              ] else ...[
                // Menu for users who are not logged in
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Information'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUsPage()),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onSubmitted: _handleSearch, // Call _handleSearch on Enter
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _showFilterDialog,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: RecipeData.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = RecipeData.recipes[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: Image.network(
                          recipe.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          recipe.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Wrap(
                          spacing: 8.0,
                          children: recipe.tags
                              .map((tag) => TagWidget(text: tag))
                              .toList(),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailPage(recipe: recipe),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
