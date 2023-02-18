// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:journey/database.dart';
import 'package:journey/entity/trip.dart';
import 'package:journey/widget/add_trip.dart';

late AppDatabase database;

void main() async {
  runApp(const MyApp());
  await Geolocator.requestPermission();
  database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
}

void addTrip(String name) async {
  database.tripdao.insertTrip(Trip(name));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Trips',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        debugShowCheckedModeBanner: false);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Color nameToColor(String name) {
  List<int> c = [0, 0, 0];
  for (int i = 0; i < name.length; ++i) {
    c[i % 3] += name.codeUnitAt(i);
  }
  c = c.map((e) => e % 256).toList();
  return Color.fromARGB(255, c[0], c[1], c[2]);
}

const TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 17);
const TextStyle textStyleBold =
    TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold);

class _MyHomePageState extends State<MyHomePage> {
  Position? _position;

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .timeout(const Duration(seconds: 5));
      setState(() {
        _position = newPosition;
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  List<Trip> trips = [];
  Future<void> loadTripList() async {
    trips = await database.tripdao.findAllTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {
                  print('tapped');
                },
                child: Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black87),
                                color: nameToColor(trips[index].name))),
                        Text(
                          trips[index].name,
                          style: textStyle,
                        )
                      ],
                    )),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO pagina crea trips
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTripPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
