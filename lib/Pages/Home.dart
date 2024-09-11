import 'package:fitness_tracker_app/Auth/Appwrite.dart';
import 'package:fitness_tracker_app/Pages/Advice.dart';
import 'package:fitness_tracker_app/Pages/Diet.dart';
import 'package:fitness_tracker_app/Pages/About.dart';
import 'package:fitness_tracker_app/Pages/Login.dart';
import 'package:fitness_tracker_app/Pages/Nutrition.dart';
import 'package:fitness_tracker_app/Pages/Progress.dart';
import 'package:fitness_tracker_app/Pages/Workout.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final AppwriteService _appwriteService = AppwriteService();

  // Separate Animation Controllers for each button
  late AnimationController _logWorkoutController;
  late AnimationController _trackProgressController;

  Workout? _savedWorkout;

  @override
  void initState() {
    super.initState();


    _logWorkoutController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0.9, // Minimum scale
      upperBound: 1.0, // Maximum scale
    );

    _trackProgressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0.9,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _logWorkoutController.dispose();
    _trackProgressController.dispose();
    super.dispose();
  }

  void _logout(BuildContext context) async {
    await _appwriteService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _onTapDown(AnimationController controller) {
    controller.reverse();
  }

  void _onTapUp(AnimationController controller) {
    controller.forward();
  }

  void _addWorkout(Workout workout) {
    setState(() {
      _savedWorkout = workout;
    });
  }

  // Drawer widget
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Text(
              'Fitness Tracker',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.question_mark),
            title: Text('Nutrition Info'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NutritionInfoPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.file_copy_rounded),
            title: Text('Plan your Diet'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DietPlanPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lightbulb_outline),
            title: Text('Fitness Advice'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FitnessAdvicePage()), // Navigate to Fitness Advice page
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About Us'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
        ]));


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal, // Set entire screen background color to teal
      appBar: AppBar(
        title: Text('Fitness Tracker'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            GestureDetector(
              onTapDown: (_) => _onTapDown(_logWorkoutController),
              onTapUp: (_) => _onTapUp(_logWorkoutController),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutPage(onSaveWorkout: _addWorkout),
                  ),
                );
              },
              child: ScaleTransition(
                scale: _logWorkoutController,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(Icons.fitness_center, size: 60, color: Colors.teal),
                        SizedBox(height: 10),
                        Text(
                          'Log Workout',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Track Progress Button
            GestureDetector(
              onTapDown: (_) => _onTapDown(_trackProgressController),
              onTapUp: (_) => _onTapUp(_trackProgressController),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProgressPage()),
                );
              },
              child: ScaleTransition(
                scale: _trackProgressController,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(Icons.show_chart, size: 60, color: Colors.teal),
                        SizedBox(height: 10),
                        Text(
                          'Track Progress',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Display the saved workout at the bottom
            if (_savedWorkout != null) ...[
              Divider(color: Colors.white),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Saved Workout: ${_savedWorkout!.exercise}\n'
                      'Duration: ${_savedWorkout!.duration} minutes\n'
                      'Plan: ${_savedWorkout!.workoutPlan}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
