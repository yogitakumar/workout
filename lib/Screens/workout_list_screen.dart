import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:workout/Screens/base-view.dart';
import 'package:workout/Screens/workout_screen.dart';

import '../ViewModel/workout_viewmodel.dart';

class WorkoutListScreen extends StatefulWidget {
  @override
  _WorkoutListScreenState createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  final workoutViewModel = GetIt.I<WorkoutViewModel>();

  @override
  void initState() {
    super.initState();
    workoutViewModel.loadWorkouts();
  }

  void _deleteWorkout(int? id) {
    workoutViewModel.deleteWorkout(id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts'),
      ),
      body: BaseView<WorkoutViewModel>(
        builder: (context, model, child) {
          return ListView.builder(
            itemCount: model.workouts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(model.workouts[index].name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteWorkout(model.workouts[index].id);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WorkoutScreen(workout: model.workouts[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
