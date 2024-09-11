import 'package:fitness_tracker_app/Auth/Appwrite.dart';
import 'package:flutter/material.dart';

class RatingPopup extends StatefulWidget {
  @override
  _RatingPopupState createState() => _RatingPopupState();
}

class _RatingPopupState extends State<RatingPopup> {
  final AppwriteService _appwriteService = AppwriteService();
  double _rating = 3.0; // Default rating value
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitRating() async {
    final feedback = _feedbackController.text;


    await _appwriteService.saveRating(_rating, feedback);


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Thanks for your feedback!')),
    );

    Navigator.of(context).pop(); // Close the popup
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate Fitness Tracker'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please rate the app:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            _buildRatingStars(),
            SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: 'Your Feedback (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the popup
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitRating,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
          ),
          child: Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1.0;
            });
          },
        );
      }),
    );
  }
}
