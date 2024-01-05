// booking_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookingPage extends StatefulWidget {
  final String carId;
  final int pricePerDay;

  BookingPage({required this.carId, required this.pricePerDay});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int numberOfDays = 1;

  @override
  Widget build(BuildContext context) {
    int totalPrice = numberOfDays * widget.pricePerDay;

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'How many days do you want to rent the car?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (numberOfDays > 1) {
                        numberOfDays--;
                      }
                    });
                  },
                ),
                Text(
                  '$numberOfDays days',
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      numberOfDays++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Total Price: \$ $totalPrice',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _confirmBooking(totalPrice);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                onPrimary: Colors.white,
              ),
              child: Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmBooking(int totalPrice) async {
    // Replace with the actual user ID from the logged-in user
    // You may retrieve it from your authentication system
    String userId = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('uid') ?? 'Unknown id';

    String apiUrl = "https://perfectionist-team.000webhostapp.com/get_bookings.php";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'user_id': userId,
          'car_id': widget.carId,
          'number_of_days': numberOfDays.toString(),
          'pickup_date': DateTime.now().toString(), // Replace with your logic to set the pickup date
          'dropoff_date': DateTime.now().add(Duration(days: numberOfDays)).toString(), // Set dropoff date based on number of days
          'total_price': totalPrice.toString(),
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (!jsonData["error"]) {
          Navigator.pop(context); // Navigate back to the car list page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Booking Successful!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Booking Error: ${jsonData["message"]}'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('HTTP Error: ${response.statusCode}'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
