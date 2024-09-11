import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FitnessAdvicePage extends StatefulWidget {
  @override
  _FitnessAdvicePageState createState() => _FitnessAdvicePageState();
}

class _FitnessAdvicePageState extends State<FitnessAdvicePage> {

  final TextEditingController _exerciseNameController = TextEditingController();

  String _selectedType = 'cardio';
  String _selectedMuscle = 'abdominals';
  String _selectedDifficulty = 'beginner';


  final String apiUrl = 'https://api.api-ninjas.com/v1/exercises';
  final String apiKey = 'yHfvzARGpIFsEp/7+utJ+g==Iw8qHwyGIoXoPE0J';

  List<Map<String, dynamic>> _exercises = [];
  bool _loading = false;
  bool _error = false;


  Future<void> _fetchExercises() async {
    setState(() {
      _loading = true;
      _error = false;
      _exercises.clear();
    });

    try {
      final response = await http.get(
        Uri.parse(
            '$apiUrl?name=${_exerciseNameController.text}&type=$_selectedType&muscle=$_selectedMuscle&difficulty=$_selectedDifficulty'),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _exercises = data.cast<Map<String, dynamic>>();
        });
      } else {
        setState(() {
          _error = true;
        });
      }
    } catch (e) {
      setState(() {
        _error = true;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness Advice'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              TextField(
                controller: _exerciseNameController,
                decoration: InputDecoration(
                  labelText: 'Exercise Name (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),


              Text('Exercise Type', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: _selectedType,
                isExpanded: true,
                items: [
                  'cardio',
                  'olympic_weightlifting',
                  'plyometrics',
                  'powerlifting',
                  'strength',
                  'stretching',
                  'strongman'
                ].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),


              Text('Muscle Group', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: _selectedMuscle,
                isExpanded: true,
                items: [
                  'abdominals',
                  'abductors',
                  'adductors',
                  'biceps',
                  'calves',
                  'chest',
                  'forearms',
                  'glutes',
                  'hamstrings',
                  'lats',
                  'lower_back',
                  'middle_back',
                  'neck',
                  'quadriceps',
                  'traps',
                  'triceps'
                ].map((String muscle) {
                  return DropdownMenuItem<String>(
                    value: muscle,
                    child: Text(muscle),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMuscle = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),

              Text('Difficulty', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: _selectedDifficulty,
                isExpanded: true,
                items: ['beginner', 'intermediate', 'expert'].map((String level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDifficulty = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),

              // Search Button
              ElevatedButton(
                onPressed: _fetchExercises,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Get Exercises',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              // Display loading or error state
              if (_loading)
                Center(child: CircularProgressIndicator())
              else if (_error)
                Center(child: Text('Error fetching exercises', style: TextStyle(color: Colors.red))),

              // Display fetched exercises
              if (_exercises.isNotEmpty)
                ..._exercises.map((exercise) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise['name'] ?? 'Unnamed Exercise',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text('Type: ${exercise['type']}'),
                          Text('Muscle Group: ${exercise['muscle']}'),
                          Text('Difficulty: ${exercise['difficulty']}'),
                          SizedBox(height: 10),
                          Text(exercise['instructions'] ?? 'No instructions available'),
                        ],
                      ),
                    ),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
