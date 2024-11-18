// bookmark_manager.dart
import '../../data_classes/recipe.dart';

class BookmarkManager {
  static final BookmarkManager _instance = BookmarkManager._internal();
  factory BookmarkManager() => _instance;

  BookmarkManager._internal();

  final List<Recipe> _bookmarks = [];

  List<Recipe> get bookmarks => _bookmarks;

  void addBookmark(Recipe recipe) {
    if (!_bookmarks.contains(recipe)) {
      _bookmarks.add(recipe);
    }
  }

  void removeBookmark(Recipe recipe) {
    _bookmarks.remove(recipe);
  }

  bool isBookmarked(Recipe recipe) {
    return _bookmarks.contains(recipe);
  }
}
