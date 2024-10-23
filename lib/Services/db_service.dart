import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workout/Models/workout.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  Database? _db;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'workouts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create 'workouts' table
        await db.execute('''
          CREATE TABLE workouts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');

        // Create 'sets' table with foreign key reference to 'workouts'
        await db.execute('''
          CREATE TABLE sets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            workout_id INTEGER,  -- Foreign key reference to the workouts table
            exercise TEXT NOT NULL,
            weight INTEGER NOT NULL,
            repetitions INTEGER NOT NULL,
            FOREIGN KEY(workout_id) REFERENCES workouts(id) ON DELETE CASCADE
          )
        ''');
      },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<int> insertWorkout(Workout workout) async {
    final db = await database;

    // Insert the workout into the 'workouts' table
    int workoutId = await db.insert('workouts', workout.toMap());

    // Insert all the sets linked to this workout
    for (WorkoutSet set in workout.sets) {
      set.workoutId = workoutId; // Assign the workout ID to the set
      await db.insert('sets', set.toMap());
    }

    return workoutId;
  }

  Future<List<Workout>> getAllWorkouts() async {
    final db = await database;

    // Fetch all workouts
    final List<Map<String, Object?>> workoutMaps = await db.query('workouts');

    // Fetch all sets and associate them with the corresponding workouts
    List<Workout> workouts = [];

    for (Map<String, dynamic> workoutMap in workoutMaps) {
      int workoutId = workoutMap['id'];

      // Fetch the sets for this workout
      final List<Map<String, Object?>> setMaps = await db.query(
        'sets',
        where: 'workout_id = ?',
        whereArgs: [workoutId],
      );

      // Convert the sets maps into a list of WorkoutSet objects
      List<WorkoutSet> sets = List.generate(setMaps.length, (i) {
        return WorkoutSet.fromMap(setMaps[i]);
      });

      // Add the workout to the list, with its sets
      workouts.add(Workout.fromMap(workoutMap, sets));
    }

    return workouts;
  }

  Future<int> insertWorkoutSet(WorkoutSet set) async {
    final db = await database;
    return await db.insert('sets', set.toMap());
  }

  Future<void> deleteWorkout(int id) async {
    final db = await database;
    await db.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }
}
