import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationInputPage extends StatelessWidget {
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enter Your Location',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Enter City Name',
                  border: InputBorder.none, // Remove the default border
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String location = _locationController.text.trim();
                if (location.isNotEmpty) {
                  bool isValid = await _validateLocation(location);
                  if (isValid) {
                    // Navigate to the next page only if location is valid
                    Navigator.pop(context, location);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a valid location.'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a location.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.brown,
                onPrimary: Colors.white,
                minimumSize: Size(
                    0.6 * MediaQuery.of(context).size.width, 48), // 60% of screen width
                padding: EdgeInsets.symmetric(vertical: 16.0), // Adjust padding as needed
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Check Weather',
                style: TextStyle(fontSize: 16.0), // Adjust text size as needed
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _validateLocation(String location) async {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$location&format=json&limit=1'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // Check if any results are returned
      return data.isNotEmpty;
    } else {
      // Handle error response
      return false;
    }
  }
}
