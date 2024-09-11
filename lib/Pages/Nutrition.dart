import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NutritionInfoPage extends StatefulWidget {
  @override
  _NutritionInfoPageState createState() => _NutritionInfoPageState();
}

class _NutritionInfoPageState extends State<NutritionInfoPage> {
  final TextEditingController _foodController = TextEditingController();
  final String apiKey = 'yHfvzARGpIFsEp/7+utJ+g==Iw8qHwyGIoXoPE0J';
  bool _loading = false;
  bool _error = false;
  List<Map<String, dynamic>> _nutritionInfo = [];


  Future<void> _fetchNutritionInfo() async {
    final String query = _foodController.text;

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a food item')),
      );
      return;
    }

    setState(() {
      _loading = true;
      _error = false;
      _nutritionInfo.clear();
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.api-ninjas.com/v1/nutrition?query=$query'),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _nutritionInfo = data.cast<Map<String, dynamic>>();
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
        title: Text('Nutrition Information'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input field for food query
              TextField(
                controller: _foodController,
                decoration: InputDecoration(
                  labelText: 'Enter Food Item',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Search Button
              ElevatedButton(
                onPressed: _fetchNutritionInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Get Nutrition Info',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              // Display loading or error message
              if (_loading)
                Center(child: CircularProgressIndicator())
              else if (_error)
                Center(child: Text('Error fetching nutrition data', style: TextStyle(color: Colors.red))),

              // Display fetched nutrition information
              if (_nutritionInfo.isNotEmpty)
                ..._nutritionInfo.map((item) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'] ?? 'Unknown Food',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          _buildNutritionRow('Calories', '${item['calories'] ?? 'N/A'} kcal'),
                          _buildNutritionRow('Serving Size', '${item['serving_size_g'] ?? 'N/A'} g'),
                          _buildNutritionRow('Total Fat', '${item['fat_total_g'] ?? 'N/A'} g'),
                          _buildNutritionRow('Saturated Fat', '${item['fat_saturated_g'] ?? 'N/A'} g'),
                          _buildNutritionRow('Protein', '${item['protein_g'] ?? 'N/A'} g'),
                          _buildNutritionRow('Sodium', '${item['sodium_mg'] ?? 'N/A'} mg'),
                          _buildNutritionRow('Potassium', '${item['potassium_mg'] ?? 'N/A'} mg'),
                          _buildNutritionRow('Cholesterol', '${item['cholesterol_mg'] ?? 'N/A'} mg'),
                          _buildNutritionRow('Carbohydrates', '${item['carbohydrates_total_g'] ?? 'N/A'} g'),
                          _buildNutritionRow('Fiber', '${item['fiber_g'] ?? 'N/A'} g'),
                          _buildNutritionRow('Sugar', '${item['sugar_g'] ?? 'N/A'} g'),
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

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
