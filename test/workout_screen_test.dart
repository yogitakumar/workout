import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:workout/Screens/workout_screen.dart';
import 'package:workout/ViewModel/workout_viewmodel.dart';
import 'package:workout/Models/workout.dart';

class MockWorkoutViewModel extends Mock implements WorkoutViewModel {}

void main() {
  Widget createWorkoutScreen(MockWorkoutViewModel mockViewModel, Workout? workout) {
    return ChangeNotifierProvider<WorkoutViewModel>.value(
      value: mockViewModel,
      child: MaterialApp(
        home: WorkoutScreen(workout: workout),
      ),
    );
  }

  testWidgets('WorkoutScreen should display workout name', (WidgetTester tester) async {
    final mockViewModel = MockWorkoutViewModel();
    final workout = Workout(id: 1, name: 'Test Workout', sets: []);

    await tester.pumpWidget(createWorkoutScreen(mockViewModel, workout));

    // Check if the workout name is displayed
    expect(find.text('Test Workout'), findsOneWidget);
  });

  testWidgets('Add set button should add a set to the workout', (WidgetTester tester) async {
    final mockViewModel = MockWorkoutViewModel();
    final workout = Workout(id: 1, name: 'Test Workout', sets: []);

    await tester.pumpWidget(createWorkoutScreen(mockViewModel, workout));

    // Tap the Add Set button
    await tester.tap(find.text('Add Set'));
    await tester.pump();

    // Enter weight and repetitions
    await tester.enterText(find.byType(TextFormField).at(1), '50'); // for weight
    await tester.enterText(find.byType(TextFormField).at(2), '10'); // for repetitions

    // Tap on the "Add Set to Workout" button
    await tester.tap(find.text('Add Set to Workout'));
    await tester.pumpAndSettle();

    // Verify that a set was added to the workout
    expect(find.text('50'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
  });
}
