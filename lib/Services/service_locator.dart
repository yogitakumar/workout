import 'package:get_it/get_it.dart';
import 'package:workout/ViewModel/workout_viewmodel.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => WorkoutViewModel());
}
