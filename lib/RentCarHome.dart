import 'package:flutter/material.dart';
import 'RentCar.dart';
import 'search.dart';
import 'account.dart';
import 'booking_list.dart';

class carhome extends StatefulWidget {
  const carhome({super.key});

  @override
  State<carhome> createState() => _carhomeState();
}

class _carhomeState extends State<carhome> {

  bool _load = false; // used to show cars list or progress bar

  void update(bool success) {
    setState(() {
      _load = true; // show product list
      if (!success) { // API request failed
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('failed to load data')));
      }
    });
  }

  @override
  void initState() {
    // update data when the widget is added to the tree the first tome.
    updateCars((update));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(onPressed: !_load ? null : () {
            setState(() {
              _load = false; // show progress bar
              updateCars(update); // update data asynchronously
            });
          }, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () {
            setState(() { // open the search product page
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Search())
              );
            });
          }, icon: const Icon(Icons.search))
        ],
          title: const Text('Available Cars'),
          centerTitle: true,
          backgroundColor: Colors.orange,
        ),
        // load products or progress bar
        body: _load ? const ShowCars() : const Center(
            child: SizedBox(width: 100, height: 100, child: CircularProgressIndicator())
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

                    },
                    color: Colors.black,
                      ),
                IconButton(
                  icon: Icon(Icons.list),
                    onPressed: () {
                      // Navigate to car list page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingListPage(),
                        ),
                      );
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
