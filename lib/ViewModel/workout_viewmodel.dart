import 'dart:async';
import 'package:workout/Models/workout.dart';
import 'package:workout/Services/db_service.dart';
import 'package:workout/ViewModel/base-viewmodel.dart';

class WorkoutViewModel extends BaseViewModel{
  final DatabaseService _dbService = DatabaseService();
  List<Workout> workouts = [];

  Future<void> loadWorkouts() async {
    try {
      workouts = await _dbService.getAllWorkouts();  // Fetching workouts from DB
     } catch (e) {
      print('Error loading workouts: $e');
    }
    notifyListeners();
  }


  Future<void> addWorkout(Workout workout) async {
    await _dbService.insertWorkout(workout);
    await loadWorkouts();
  }

  Future<void> deleteWorkout(int id) async {
    await _dbService.deleteWorkout(id);
    await loadWorkouts();
  }

  Future<void> updateWorkout(int? id, Workout newWorkout) async {
    await _dbService.deleteWorkout(id!);
    await _dbService.insertWorkout(newWorkout);
    await loadWorkouts();
  }
}

