class Workout {
  int? id;
  String name;
  List<WorkoutSet> sets;

  Workout({this.id, required this.name, required this.sets});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  Workout.fromMap(Map<String, dynamic> map, List<WorkoutSet> sets)
      : id = map['id'],
        name = map['name'],
        this.sets = sets;
}

class WorkoutSet {
  int? id;
  int? workoutId;
  String exercise;
  int weight;
  int repetitions;

  WorkoutSet(
      {this.id,
      this.workoutId,
      required this.exercise,
      required this.weight,
      required this.repetitions});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workout_id': workoutId,
      'exercise': exercise,
      'weight': weight,
      'repetitions': repetitions,
    };
  }

  WorkoutSet.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        workoutId = map['workout_id'],
        exercise = map['exercise'],
        weight = map['weight'],
        repetitions = map['repetitions'];
}
