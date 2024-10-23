This app is a workout tracker built using Flutter. It follows the MVVM (Model-View-ViewModel) architecture and allows users to record, edit, and track workouts. Key features include storing workout details locally using SQLite, handling multiple sets per workout, and managing app state with the Provider package. The app also uses GetIt for dependency injection, making it easy to manage instances across the app.


Features
Workout List Screen: Displays all recorded workouts.
Workout Screen: Users can add or edit a workout by specifying details like the workout name and different sets (which include exercises, weight, and repetitions).


Architecture
The app is structured using the MVVM architecture pattern:

Model: Represents the core data (like Workout and WorkoutSet).
ViewModel: Handles the business logic, like retrieving data from the database or updating the UI state.
View: The UI layer that displays data and responds to user interaction by updating based on changes in the ViewModel.


Dependencies
The app relies on the following key packages:

sqflite: For managing the local SQLite database.
get_it: For dependency injection, making it easier to manage services like database access.
provider: For state management, ensuring the UI reacts to changes in the data.


How to Run the App
To get the app running locally, follow these steps:

Clone the repository to your local machine.
Run flutter pub get to install all the required dependencies.
Use flutter run to launch the app on your connected device or emulator.


Database Structure
The app uses an SQLite database with the following two tables:

workouts: Stores the workout's basic details like the name and ID.
sets: Stores the individual workout sets, including the exercise name, weight, and repetitions. Each set is linked to a workout via a foreign key.