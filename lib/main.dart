import 'package:flutter/material.dart';
import 'RentCarHome.dart';
import 'booking_list.dart';
import 'login.dart'; // Update with the correct import path
import 'account.dart';
import 'package:shared_preferences/shared_preferences.dart';// Create the AccountPage file
//import 'car_list.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/account': (context) => AccountPage(),
        '/car_list':(context) => carhome(),
        '/booking-list' :(context) => BookingListPage(),

      },
    );
  }
}
