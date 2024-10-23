import 'package:flutter/material.dart';
import 'Screens/workout_list_screen.dart';
import 'Services/service_locator.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      home: WorkoutListScreen(),
    );
  }
}
