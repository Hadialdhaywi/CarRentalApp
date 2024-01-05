import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'account.dart';
import 'package:testproject/RentCarHome.dart';


class Booking {
  final int bookingId;
  final String carMake;
  final String carModel;
  final String carYear;
  final String carColor;
  final int pricePerDay;
  final String features;
  final String imagePath;
  final String pickupDate;
  final String dropoffDate;
  final String status;

  Booking({
    required this.bookingId,
    required this.carMake,
    required this.carModel,
    required this.carYear,
    required this.carColor,
    required this.pricePerDay,
    required this.features,
    required this.imagePath,
    required this.pickupDate,
    required this.dropoffDate,
    required this.status,
  });
}

// Import necessary packages and modules

class BookingListPage extends StatefulWidget {
  @override
  _BookingListPageState createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  List<Booking> bookings = [];
  late int userId = 0;
  late String username = '';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    // Load user id from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId') ?? 0;
      username = prefs.getString('username') ?? '';
    });
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    // Fetch bookings data from the API
    String apiUrl = "https://perfectionist-team.000webhostapp.com/booking-list.php?username=$username";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (!jsonData["error"]) {
          setState(() {
            List<dynamic> bookingsData = jsonData["bookings"];
            bookings = bookingsData.map((booking) => Booking(
              bookingId: int.parse(booking["booking_id"]),
              carMake: booking["make"],
              carModel: booking["model"],
              carYear: booking["year"],
              carColor: booking["color"],
              pricePerDay: int.parse(booking["price_per_day"]),
              features: booking["features"],
              imagePath: booking["image_path"],
              pickupDate: booking["pickup_date"],
              dropoffDate: booking["dropoff_date"],
              status: booking["status"],
            )).toList();
          });
        } else {
          print("Error: ${jsonData["message"]}");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking List'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            color: Colors.grey[200],
            child: ListTile(
              contentPadding: EdgeInsets.all(15),
              title: Text(
                '${booking.carMake} ${booking.carModel}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pickup Date: ${booking.pickupDate}', style: TextStyle(fontSize: 14)),
                  Text('Dropoff Date: ${booking.dropoffDate}', style: TextStyle(fontSize: 14)),
                  Text('Price per day: \$${booking.pricePerDay}', style: TextStyle(fontSize: 14)),
                  Text('Status: ${booking.status}', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.directions_car),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => carhome(),
                  ),
                );
              },
              color: Colors.black,
            ),
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                // Navigate to car list page
              },
              color: Colors.black,
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountPage(),
                  ),
                );
              },
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

