import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:workout/Models/workout.dart';
import 'package:workout/ViewModel/workout_viewmodel.dart';

class WorkoutScreen extends StatefulWidget {
  final Workout? workout;

  WorkoutScreen({this.workout});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String _workoutName = '';
  late Workout _workout;
  final workoutViewModel = GetIt.I<WorkoutViewModel>();
  List<WorkoutSet> _sets = [];
  final List<String> _exercises = [
    'Barbell row',
    'Bench press',
    'Shoulder press',
    'Deadlift',
    'Squat'
  ];
  String selectedExercise = 'Barbell row';
  bool wantToAddNewSet = false;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repetitionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.workout != null) {
      _workoutName = widget.workout!.name;
      _sets = widget.workout!.sets;
      _workout = widget.workout!;
    } else {
      _workout = Workout(name: '', sets: []);
    }
  }

  // Add a new set
  void _addSet() {
    if (_weightController.text.isEmpty || _repetitionsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter valid weight and repetitions')),
      );
      return;
    }

    setState(() {
      _sets.add(WorkoutSet(
        id: DateTime.now().millisecondsSinceEpoch,
        exercise: selectedExercise,
        weight: int.parse(_weightController.text),
        repetitions: int.parse(_repetitionsController.text),
      ));
    });

    _clearSetInputs();
    wantToAddNewSet = false;
  }

  // Clear weight and repetition inputs
  void _clearSetInputs() {
    _weightController.clear();
    _repetitionsController.clear();
  }

  // Edit an existing set
  void _editSet(int index, WorkoutSet newSet) {
    setState(() {
      _sets[index] = newSet;
    });
  }

  // Delete a set
  void _deleteSet(int index) {
    setState(() {
      _sets.removeAt(index);
    });
  }

  // Save the workout
  Future<void> _saveWorkout() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newWorkout = Workout(name: _workoutName, sets: _sets);

      if (widget.workout != null) {
        // Update existing workout
        await workoutViewModel.updateWorkout(widget.workout!.id, newWorkout);
      } else {
        // Add a new workout
        await workoutViewModel.addWorkout(newWorkout);
      }

      Navigator.of(context).pop(); // Go back after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout != null ? 'Edit Workout' : 'Add Workout'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Workout Name Input
              TextFormField(
                initialValue: _workoutName,
                decoration: const InputDecoration(
                  labelText: 'Workout Name',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onSaved: (value) => _workoutName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a workout name' : null,
              ),
              const SizedBox(height: 15),

              // Display the list of sets added
              Expanded(
                child: ListView.builder(
                  itemCount: _sets.length,
                  itemBuilder: (context, index) {
                    final set = _sets[index];
                    return Card(
                      child: ListTile(
                        title: Text('${set.exercise}: ${set.weight} kg'),
                        subtitle: Text('${set.repetitions} repetitions'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _weightController.text = set.weight.toString();
                                _repetitionsController.text =
                                    set.repetitions.toString();
                                setState(() {
                                  selectedExercise = set.exercise;
                                  wantToAddNewSet = true;
                                });
                                _editSet(index, set);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteSet(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Button to toggle Add Set section
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    wantToAddNewSet = !wantToAddNewSet;
                    _clearSetInputs(); // Ensure inputs are cleared when switching mode
                  });
                },
                child: Text(wantToAddNewSet ? 'Cancel' : 'Add Set'),
              ),

              // Add Set Form
              if (wantToAddNewSet)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedExercise,
                      items: _exercises.map((exercise) {
                        return DropdownMenuItem<String>(
                          value: exercise,
                          child: Text(exercise),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedExercise = value!;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Exercise'),
                    ),
                    const SizedBox(height: 10),
                    // Weight Input
                    TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Weight in kg',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Repetitions Input
                    TextFormField(
                      controller: _repetitionsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Repetitions',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addSet,
                      child: const Text('Add Set to Workout'),
                    ),
                  ],
                ),

              // Save Workout Button
              ElevatedButton(
                onPressed: _saveWorkout,
                child: const Text('Save Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
