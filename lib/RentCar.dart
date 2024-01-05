import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'booking.dart';
import 'booking_list.dart';

// Domain of your server
const String _baseURL = 'perfectionist-team.000webhostapp.com';

class Car {
  String id;
  String make;
  String model;
  int year;
  String color;
  int price_per_day;
  int availability;
  String features;
  String image_path;

  Car(this.id,this.make, this.model, this.year, this.color, this.price_per_day,
      this.availability, this.features, this.image_path);

  String isAvailable(int availability) {
    if (availability == 1) {
      return 'Available';
    } else
      return 'Rented';
  }

  @override
  String toString() {
    return '$make $model \n year: $year, color: $color, Daily price: $price_per_day \n availability: ${isAvailable(availability)} , features: $features';
  }
}

List<Car> _cars = [];

void updateCars(Function(bool success) update) async {
  try {
    final url = Uri.https(_baseURL, 'getCars.php');
    final response = await http.get(url).timeout(const Duration(seconds: 30));
    _cars.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        Car c = Car(
          row['car_id'],
          row['make'],
          row['model'],
          int.parse(row['year']),
          row['color'],
          int.parse(row['price_per_day']),
          int.parse(row['availability']),
          row['features'],
          row['image_path'],
        );
        _cars.add(c);
      }
      update(true);
    }
  } catch (e) {
    update(false);
  }
}

void searchCar(Function(List<Car> results) update, String model) async {
  try {
    final url = Uri.https(_baseURL, 'searchCar.php', {'model': model});
    final response = await http.get(url).timeout(const Duration(seconds: 30));
    _cars.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      List<Car> results = [];
      for (var row in jsonResponse) {
        Car c = Car(
          row['car_id'],
          row['make'],
          row['model'],
          int.parse(row['year']),
          row['color'],
          int.parse(row['price_per_day']),
          int.parse(row['availability']),
          row['features'],
          row['image_path'],
        );
        results.add(c);
      }
      _cars.addAll(results);
      update(results);
    }
  } catch (e) {
    update([]);
  }
}

class ShowCars extends StatelessWidget {
  const ShowCars({Key? key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: _cars.length,
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        color: index % 2 == 0 ? Colors.grey[200] : Colors.grey[300], // Adjust colors here
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: width * 0.5, // Set the height for the image container
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    '${_cars[index].image_path}',
                  ),
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(15),
              title: Text(
                '${_cars[index].make} ${_cars[index].model}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Year: ${_cars[index].year}', style: TextStyle(fontSize: 14)),
                  Text('Color: ${_cars[index].color}', style: TextStyle(fontSize: 14)),
                  Text('Daily Price: ${_cars[index].price_per_day}', style: TextStyle(fontSize: 14)),
                  Text(
                    'Availability: ${_cars[index].isAvailable(_cars[index].availability)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: _cars[index].availability == 1 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              trailing: _cars[index].availability == 1
                  ? ElevatedButton(
                onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(
                          carId: _cars[index].id,
                          pricePerDay: _cars[index].price_per_day,
                        ),
                      ),
                    );

                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange, // Adjust button color
                  onPrimary: Colors.white, // Adjust text color
                ),
                child: Text('Rent Now'),
              )
                  : ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey,
                ),
                child: Text('Out of Stock'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



