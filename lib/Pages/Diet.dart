import 'package:fitness_tracker_app/Auth/Appwrite.dart';
import 'package:flutter/material.dart';

class DietPlanPage extends StatefulWidget {
  @override
  _DietPlanPageState createState() => _DietPlanPageState();
}

class _DietPlanPageState extends State<DietPlanPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _mealController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final AppwriteService _appwriteService = AppwriteService();

  List<Map<String, dynamic>> _dietPlans = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controller.forward();
    _fetchDietPlans();
  }

  @override
  void dispose() {
    _mealController.dispose();
    _caloriesController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // Save diet plan and update UI
  void _saveDietPlan() async {
    final meal = _mealController.text;
    final calories = _caloriesController.text;

    if (meal.isEmpty || calories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields!')),
      );
      return;
    }


    await _appwriteService.createDietPlan(meal, calories);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Meal saved: $meal with $calories calories.')),
    );

    _mealController.clear();
    _caloriesController.clear();


    _fetchDietPlans();
  }


  Future<void> _fetchDietPlans() async {
    setState(() {
      _loading = true;
    });
    final plans = await _appwriteService.fetchDietPlans();
    setState(() {
      _dietPlans = plans;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Plan'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Log Your Meal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _mealController,
                  decoration: InputDecoration(
                    labelText: 'Meal',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _caloriesController,
                  decoration: InputDecoration(
                    labelText: 'Calories',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveDietPlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Save Meal',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 30),

                // Display saved diet plans
                if (_loading)
                  Center(child: CircularProgressIndicator())
                else if (_dietPlans.isNotEmpty)
                  ..._dietPlans.map((plan) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text(plan['meal']),
                        subtitle: Text('${plan['calories']} calories'),
                      ),
                    );
                  }).toList(),
                if (_dietPlans.isEmpty && !_loading)
                  Center(child: Text('No meals logged yet.')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
