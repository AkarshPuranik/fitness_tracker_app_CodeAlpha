import 'package:flutter/material.dart';

class Workout {
  final String exercise;
  final String duration;
  final String workoutPlan;

  Workout(this.exercise, this.duration, this.workoutPlan);
}

class WorkoutPage extends StatefulWidget {
  final Function(Workout) onSaveWorkout;

  WorkoutPage({required this.onSaveWorkout});

  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> with SingleTickerProviderStateMixin {
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  String _selectedPlan = 'Full Body';
  final List<String> _workoutPlans = ['Full Body', 'Cardio', 'Strength', 'Yoga', 'HIIT'];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _durationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _saveWorkout() {
    final exercise = _exerciseController.text;
    final duration = _durationController.text;
    final workoutPlan = _selectedPlan;

    if (exercise.isEmpty || duration.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields!')),
      );
      return;
    }


    widget.onSaveWorkout(Workout(exercise, duration, workoutPlan));


    _exerciseController.clear();
    _durationController.clear();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Select Workout Plan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: _selectedPlan,
                  isExpanded: true,
                  items: _workoutPlans.map((String plan) {
                    return DropdownMenuItem<String>(
                      value: plan,
                      child: Text(plan),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPlan = newValue!;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _exerciseController,
                  decoration: InputDecoration(
                    labelText: 'Exercise',
                    labelStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _durationController,
                  decoration: InputDecoration(
                    labelText: 'Duration (minutes)',
                    labelStyle: TextStyle(color: Colors.teal),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveWorkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Save Workout',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
