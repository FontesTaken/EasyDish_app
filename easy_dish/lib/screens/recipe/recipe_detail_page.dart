// recipe_detail_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data_classes/recipe.dart';
import '../auxiliary/scheduleNotification.dart';
import '../auxiliary/sendNotification.dart';
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
  void initState() {
    super.initState();
    stepCompletionStatus =
        List.generate(widget.recipe.steps.length, (index) => false);
    activeTimers = List.generate(widget.recipe.steps.length, (index) => null);
    loadTimerState();

    // Check if the recipe is already bookmarked
    isBookmarked = BookmarkManager().isBookmarked(widget.recipe);
  }


  Future<void> loadTimerState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      stepTimers = widget.recipe.steps.asMap().entries.map((entry) {
        int index = entry.key;
        RecipeStep step = entry.value;

        int? savedTime = prefs.getInt('step ${widget.recipe.id} $index');
        int? startTime = prefs.getInt('startTime ${widget.recipe.id} $index');

        if (savedTime != null) {
          if (startTime != null) {
            int elapsed = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(startTime)).inSeconds;
            int remainingTime = savedTime - elapsed;
            if (remainingTime > 0) {
              startTimer(index, remainingTime);
              return remainingTime;
            }
            return 0;
          }
          return savedTime;
        }

        return step.timer != null ? step.timer! * 60 : null;
      }).toList();
    });
  }

  Future<void> saveTimerState(int index, bool isTimerRunning) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'step ${widget.recipe.id} $index';
    int? value = stepTimers[index];

    if (value != null) {
      prefs.setInt(key, value);
      if (isTimerRunning) {
        prefs.setInt('startTime ${widget.recipe.id} $index', DateTime.now().millisecondsSinceEpoch);
      } else {
        prefs.remove('startTime ${widget.recipe.id} $index');
      }
    } else {
      prefs.remove(key);
      prefs.remove('startTime ${widget.recipe.id} $index');
    }
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

  void startTimer(int index, int secondsLeft) {
    activeTimers[index] = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsLeft > 0) {
          secondsLeft--;
          stepTimers[index] = secondsLeft;
          saveTimerState(index, true);
        } else {
          timer.cancel();
          activeTimers[index] = null;
          saveTimerState(index, false);
          sendNotification('Timer Completed', 'Step ${index + 1} of the recipe is done!');
        }
      });
    });

    final scheduledTime = DateTime.now().add(Duration(seconds: secondsLeft));
    scheduleNotification(
      title: 'Timer Completed',
      body: 'Step ${index + 1} of the recipe is done!',
      scheduledDate: scheduledTime,
    );
  }

  Future<void> resetTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var timer in activeTimers) {
      timer?.cancel();
    }

    setState(() {
      stepTimers = widget.recipe.steps.asMap().entries.map((entry) {
        int index = entry.key;
        RecipeStep step = entry.value;
        prefs.remove('startTime ${widget.recipe.id} $index');
        prefs.remove('step ${widget.recipe.id} $index');
        if (step.timer != null) {
          stepTimers[index] = widget.recipe.steps[index].timer! * 60;
          return step.timer! * 60;
        } else {
          return null;
        }
      }).toList();
    });

    activeTimers = List.generate(widget.recipe.steps.length, (_) => null);
  }

  void toggleTimer(int index) {
    if (activeTimers[index] == null) {
      int secondsLeft = stepTimers[index] ?? 0;
      startTimer(index, secondsLeft);
      saveTimerState(index, true);
    } else {
      activeTimers[index]?.cancel();
      setState(() {
        activeTimers[index] = null;
        saveTimerState(index, false);
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

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, // Base color to prevent blending issues
        child: Scaffold(
          backgroundColor: Colors.orange.withOpacity(0.19),
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.orange.withOpacity(0.01),
            title: Text(widget.recipe.name,
                style: TextStyle(
                  color: Color(0xFFC08019),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                )),
            actions: [
              IconButton(
                icon:
                    Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                color: const Color(0xFF885B0E),
                onPressed: toggleBookmark,
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                color: const Color(0xFF885B0E),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CommentsPage(comments: widget.recipe.comments),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Center(
                    child: Image.network(
                      widget.recipe.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                Text(widget.recipe.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF885B0E),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8.0,
                  children: widget.recipe.tags
                      .map((tag) => TagWidget(text: tag))
                      .toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Created By: ${widget.recipe.createdBy}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF885B0E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...widget.recipe.ingredients
                    .map((ingredient) => Text(
                        '- ${ingredient.name}: ${ingredient.getAdjustedQuantity(widget.recipe.servings, widget.recipe.defaultServings)} ${ingredient.unit}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF885B0E),
                          fontWeight: FontWeight.bold,
                        )))
                    .toList(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Servings:',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF754F0D),
                          fontWeight: FontWeight.bold,
                        )),
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
                Row(
                  children: [
                    const Text(
                        'Steps:',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF754F0D),
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => resetTimer(),
                      child: Text("Reset Timers"),
                    ),
                  ],
                ),
                ...widget.recipe.steps.asMap().entries.map((entry) {
                  int index = entry.key;
                  RecipeStep step = entry.value;
                  bool isCompleted = stepCompletionStatus[index];
                  bool hasTimer = step.timer != null;
                  bool isTimerActive = activeTimers[index] != null;

                  return ListTile(
                    leading: Checkbox(
                        value: isCompleted,
                        onChanged: (_) => toggleStepCompletion(index)),
                    title: Text(
                      step.description,
                      style: TextStyle(
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    subtitle: hasTimer
                        ? Row(
                            children: [
                              if (index < stepTimers.length && stepTimers[index] != null) ...[
                                Text('Time left: ${formatTime(
                                    stepTimers[index] ?? 0)}'),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () => toggleTimer(index),
                                  child: Text(isTimerActive
                                      ? 'Stop Timer'
                                      : 'Start Timer'),
                                ),
                              ]
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
        ));
  }
}
