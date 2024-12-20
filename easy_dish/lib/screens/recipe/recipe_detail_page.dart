// recipe_detail_page.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart'; 
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
          recipe: widget.recipe,
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
            int elapsed = DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(startTime))
                .inSeconds;
            int remainingTime = savedTime - elapsed;
            if (remainingTime > 0) {
              startTimer(index, remainingTime);
              return remainingTime;
            }
            return 0;
          }
          return savedTime;
        }

        return step.timer;
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
        prefs.setInt('startTime ${widget.recipe.id} $index',
            DateTime.now().millisecondsSinceEpoch);
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
          stepTimers[index] = 0; // Explicitly set to 0
          saveTimerState(index, false);
          sendNotification(
              'Timer Completed', 'Step ${index + 1} of the recipe is done!');
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
          stepTimers[index] = widget.recipe.steps[index].timer;
          return step.timer;
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Color(0xFFC08019),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
                  child: widget.recipe.imageUrl.isNotEmpty
                      ? (kIsWeb || widget.recipe.imageUrl.startsWith('http')
                          ? Image.network(
                              widget.recipe.imageUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(widget.recipe.imageUrl),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ))
                      : Image.asset(
                          "assets/meal_default_img.jpg",
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 16),
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
                    const Text(
                      'Servings:',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF754F0D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true, // Reduce padding
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            int? inputServings = int.tryParse(value);
                            if (inputServings != null && inputServings > 0) {
                              widget.recipe.servings = inputServings;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter a valid number.')),
                              );
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Current: ${widget.recipe.servings}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF885B0E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Steps:',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF754F0D),
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => resetTimer(),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFD095), elevation: 4),
                      child: Text("Reset Timers",
                          style: TextStyle(
                            color: Color(0xFF885B0E),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
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
                          Text('Time left: ${formatTime(stepTimers[index] ?? 0)}'),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (stepTimers[index] == 0) {
                                setState(() {
                                  stepTimers[index] = step.timer; // Reset timer to default
                                });
                                startTimer(index, stepTimers[index]!);
                              } else {
                                toggleTimer(index);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFD095), elevation: 4),
                            child: Text(
                              stepTimers[index] == 0 ? 'Restart Timer' : isTimerActive ? 'Stop Timer' : 'Start Timer',
                              style: TextStyle(
                                color: Color(0xFF885B0E),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
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
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFD095), elevation: 4),
                  child: const Text('Rate Recipe',
                      style: TextStyle(
                        color: Color(0xFF885B0E),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}
