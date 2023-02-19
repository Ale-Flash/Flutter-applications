// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:journey/database.dart';
import 'package:journey/entity/stop.dart';
import 'package:journey/entity/trip.dart';
import 'package:journey/widget/add_stop.dart';
import 'package:journey/widget/add_trip.dart';
import 'package:provider/provider.dart';

late AppDatabase database;

void main() async {
  runApp(const MyApp());
  // TODO metterla nel posto giusto, quando viene creato uno stop
  await Geolocator.requestPermission();
  database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
}

// List<Trip> trips = [];

// Future<void> loadTripList() async {
//   trips = await database.tripdao.findAllTrips();
// }

Future<void> addTrip(String name) async {
  await database.tripdao.insertTrip(Trip(null, name));
  await tripsTracker.update();
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
        home: ChangeNotifierProvider<TripsTracker>(
          create: (context) => TripsTracker(),
          child: const MyHomePage(title: 'Trips'),
        ),
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

late TripsTracker tripsTracker;

const TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 17);
const TextStyle textStyleBold =
    TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold);

int selectedTripId = 0;
List<Stop> stopsSelectedTrip = [];

String howMuchTimeAgo(DateTime dt) {
  if (dt.millisecondsSinceEpoch == 0) return 'never';
  DateTime current = DateTime.now();
  if (current.year != dt.year) {
    return '${current.year - dt.year} year${(current.year - dt.year) == 1 ? '' : 's'} ago';
  }
  if (current.month != dt.month) {
    return '${current.month - dt.month} month${(current.month - dt.month) == 1 ? '' : 's'} ago';
  }
  if (current.day != dt.day) {
    return '${current.day - dt.day} day${(current.day - dt.day) == 1 ? '' : 's'} ago';
  }
  if (current.hour != dt.hour) {
    return '${current.hour - dt.hour} hour${(current.hour - dt.hour) == 1 ? '' : 's'} ago';
  }
  if (current.minute != dt.minute) {
    return '${current.minute - dt.minute} minute${(current.minute - dt.minute) == 1 ? '' : 's'} ago';
  }
  return 'now';
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    tripsTracker = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: tripsTracker.trips.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () async {
                  stopsSelectedTrip = await database.tripstopdao
                      .findStopsByTripId(tripsTracker.trips[index].id!);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddStopPage()));
                },
                child: Container(
                    color: Color.fromARGB(255, 255, 255, 255),
                    height: 80,
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black87),
                                color: nameToColor(
                                    tripsTracker.trips[index].name))),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tripsTracker.trips[index].name,
                              style: textStyleBold,
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 17),
                                children: <TextSpan>[
                                  const TextSpan(text: 'last update: '),
                                  TextSpan(
                                      text: howMuchTimeAgo(
                                          tripsTracker.trips[index].lastUpdate),
                                      style: textStyle),
                                ],
                              ),
                            )
                          ],
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

class TripsTracker extends ChangeNotifier {
  List<Trip> _trips = [];
  List<Trip> get trips => _trips;

  Future<void> update() async {
    _trips = await database.tripdao.findAllTrips();
    notifyListeners();
  }
}
