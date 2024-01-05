import 'package:flutter/material.dart';
import 'RentCar.dart';
import 'booking.dart';

class ShowSearchResults extends StatelessWidget {
  final List<Car> searchResults;

  const ShowSearchResults({Key? key, required this.searchResults}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: searchResults.length,
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
                    '${searchResults[index].image_path}',
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${searchResults[index].make} ${searchResults[index].model}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text('Year: ${searchResults[index].year}', style: TextStyle(fontSize: 14)),
                  Text('Color: ${searchResults[index].color}', style: TextStyle(fontSize: 14)),
                  Text('Daily Price: ${searchResults[index].price_per_day}', style: TextStyle(fontSize: 14)),
                  Text(
                    'Availability: ${searchResults[index].availability == 1 ? 'Available' : 'Not Available'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: searchResults[index].availability == 1 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: searchResults[index].availability == 1
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingPage(
                      carId: searchResults[index].id,
                      pricePerDay: searchResults[index].price_per_day,
                    ),
                  ),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                primary: searchResults[index].availability == 1 ? Colors.orange : Colors.grey,
                onPrimary: Colors.white,
              ),
              child: Text('Rent Now'),
            ),
          ],
        ),
      ),
    );

  }
}

class Search extends StatefulWidget {
  const Search({Key? key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controllerModel = TextEditingController();
  List<Car> _searchResults = [];

  @override
  void dispose() {
    _controllerModel.dispose();
    super.dispose();
  }

  void update(List<Car> results) {
    setState(() {
      _searchResults = results;
    });
  }

  void getCar() {
    try {
      String model = _controllerModel.text;
      searchCar(update, model);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Wrong arguments')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search car'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _controllerModel,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Model',
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: getCar,
              child: const Text('Find', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ShowSearchResults(searchResults: _searchResults),
            ),
          ],
        ),
      ),
    );
  }
}
