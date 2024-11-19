import 'package:flutter/material.dart';
import '../recipe/recipe_detail_page.dart';
import 'bookmark_manager.dart';
import '../auxiliary/tag_widget.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.orange.withOpacity(0.19),
        appBar: AppBar(
          backgroundColor: Colors.orange.withOpacity(0.01),
          title: const Text(
            'Bookmarks',
            style: TextStyle(
              color: Color(0xFFC08019),
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          automaticallyImplyLeading: false, // Remove the back arrow
          scrolledUnderElevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BookmarkManager().bookmarks.isEmpty
              ? const Center(
            child: Text(
              "No recipes bookmarked yet.",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF885B0E),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : ListView.builder(
            itemCount: BookmarkManager().bookmarks.length,
            itemBuilder: (context, index) {
              final recipe = BookmarkManager().bookmarks[index];
              return Card(
                color: const Color(0xFFFFD095), // Matching recipe list card color
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      recipe.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF885B0E),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0), // Add spacing to the top
                      Wrap(
                        spacing: 4.0,
                        children: recipe.tags
                            .map((tag) => TagWidget(text: tag))
                            .toList(),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: const Color(0xFF885B0E),
                    onPressed: () {
                      setState(() {
                        BookmarkManager().removeBookmark(recipe);
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(recipe: recipe),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
