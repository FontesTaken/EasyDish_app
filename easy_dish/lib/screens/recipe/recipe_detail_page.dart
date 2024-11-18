// recipe_detail_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../data_classes/recipe.dart';
import '../auxiliary/tag_widget.dart';
import '../bookmark/bookmark_manager.dart';
import '../../data_classes/comment.dart';
import 'comments_page.dart';
import 'rate_recipe_page.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  List<bool> stepCompletionStatus = [];
  List<int?> stepTimers = [];
  List<Timer?> activeTimers = [];
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    stepCompletionStatus = List.generate(widget.recipe.steps.length, (index) => false);
    stepTimers = widget.recipe.steps.map((step) => step.timer != null ? step.timer! * 60 : null).toList();
    activeTimers = List.generate(widget.recipe.steps.length, (index) => null);

    // Check if the recipe is already bookmarked
    isBookmarked = BookmarkManager().isBookmarked(widget.recipe);
  }

  @override
  void dispose() {
    for (var timer in activeTimers) {
      timer?.cancel();
    }
    super.dispose();
  }

  void toggleStepCompletion(int index) {
    setState(() {
      stepCompletionStatus[index] = !stepCompletionStatus[index];
    });
  }

  void toggleTimer(int index) {
    if (activeTimers[index] == null) {
      int secondsLeft = stepTimers[index]!;
      activeTimers[index] = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (secondsLeft > 0) {
            secondsLeft--;
            stepTimers[index] = secondsLeft;
          } else {
            timer.cancel();
            activeTimers[index] = null;
            stepTimers[index] = widget.recipe.steps[index].timer! * 60;
          }
        });
      });
    } else {
      activeTimers[index]?.cancel();
      activeTimers[index] = null;
      setState(() {
        stepTimers[index] = widget.recipe.steps[index].timer! * 60;
      });
    }
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  void toggleBookmark() {
    setState(() {
      if (isBookmarked) {
        BookmarkManager().removeBookmark(widget.recipe);
      } else {
        BookmarkManager().addBookmark(widget.recipe);
      }
      isBookmarked = !isBookmarked;
    });
  }

  void navigateToRateRecipe() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RateRecipePage(
          recipeName: widget.recipe.name,
          onSubmit: (comment) {
            setState(() {
              widget.recipe.comments.add(comment);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: toggleBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.comment),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentsPage(comments: widget.recipe.comments),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Image.network(
                widget.recipe.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.recipe.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.recipe.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              children: widget.recipe.tags.map((tag) => TagWidget(text: tag)).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Ingredients:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...widget.recipe.ingredients.map((ingredient) => Text('- ${ingredient.name}: ${ingredient.getAdjustedQuantity(widget.recipe.servings, widget.recipe.defaultServings)} ${ingredient.unit}')).toList(),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Servings:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      if (widget.recipe.servings > 1) {
                        widget.recipe.servings--;
                      }
                    });
                  },
                ),
                Text('${widget.recipe.servings}'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      widget.recipe.servings++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Steps:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...widget.recipe.steps.asMap().entries.map((entry) {
              int index = entry.key;
              RecipeStep step = entry.value;
              bool isCompleted = stepCompletionStatus[index];
              bool hasTimer = step.timer != null;
              bool isTimerActive = activeTimers[index] != null;

              return ListTile(
                leading: Checkbox(value: isCompleted, onChanged: (_) => toggleStepCompletion(index)),
                title: Text(
                  step.description,
                  style: TextStyle(decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none),
                ),
                subtitle: hasTimer
                    ? Row(
                        children: [
                          Text('Time left: ${formatTime(stepTimers[index] ?? 0)}'),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => toggleTimer(index),
                            child: Text(isTimerActive ? 'Stop Timer' : 'Start Timer'),
                          ),
                        ],
                      )
                    : null,
              );
            }).toList(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: navigateToRateRecipe,
              child: const Text('Rate Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
