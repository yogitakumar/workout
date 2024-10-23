import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:workout/Screens/workout_list_screen.dart';
import 'package:workout/ViewModel/workout_viewmodel.dart';
import 'package:workout/Models/workout.dart';

class MockWorkoutViewModel extends Mock implements WorkoutViewModel {}

void main() {
  Widget createWorkoutListScreen(MockWorkoutViewModel mockViewModel) {
    return ChangeNotifierProvider<WorkoutViewModel>.value(
      value: mockViewModel,
      child: MaterialApp(
        home: WorkoutListScreen(),
      ),
    );
  }

  testWidgets('WorkoutListScreen should display list of workouts', (WidgetTester tester) async {
    final mockViewModel = MockWorkoutViewModel();
    final mockWorkouts = [
      Workout(id: 1, name: 'Workout 1', sets: []),
      Workout(id: 2, name: 'Workout 2', sets: []),
    ];

    when(mockViewModel.workouts).thenReturn(mockWorkouts);
    when(mockViewModel.loadWorkouts()).thenAnswer((_) async {});

    await tester.pumpWidget(createWorkoutListScreen(mockViewModel));

    // Check that the screen displays the correct workout names
    expect(find.text('Workout 1'), findsOneWidget);
    expect(find.text('Workout 2'), findsOneWidget);
  });

  testWidgets('Delete button should call deleteWorkout', (WidgetTester tester) async {
    final mockViewModel = MockWorkoutViewModel();
    final mockWorkouts = [
      Workout(id: 1, name: 'Workout 1', sets: []),
    ];

    when(mockViewModel.workouts).thenReturn(mockWorkouts);
    when(mockViewModel.loadWorkouts()).thenAnswer((_) async {});
    when(mockViewModel.deleteWorkout(1)).thenAnswer((_) async {});

    await tester.pumpWidget(createWorkoutListScreen(mockViewModel));

    // Find the delete button
    final deleteButton = find.byIcon(Icons.delete);
    expect(deleteButton, findsOneWidget);

    // Tap on the delete button
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    // Verify that deleteWorkout was called
    verify(mockViewModel.deleteWorkout(1)).called(1);
  });
}
