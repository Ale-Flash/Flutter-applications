// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:journey/database.dart';
import 'package:journey/entity/trip.dart';
import 'package:journey/widget/add_stop.dart';
import 'package:journey/widget/add_trip.dart';
import 'package:provider/provider.dart';

late AppDatabase database;

void main() async {
  runApp(const MyApp());
  database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
}

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

Color betterColor(Color c) {
  return (c.red * 0.3 + c.green * 0.6 + c.blue * 0.1) < 186
      ? Colors.white
      : Colors.black;
}

Color nameToColor(String name) {
  int value = name.hashCode;
  List<int> c = [0, 0, 0];
  switch (value % 3) {
    case 0:
      c[1] = value % 1000 % 256;
      c[2] = value ~/ 10000 % 1000 % 256;
      break;
    case 1:
      c[0] = value ~/ 10000 % 1000 % 256;
      c[2] = value % 1000 % 256;
      break;
    case 2:
      c[0] = value % 1000 % 256;
      c[1] = value ~/ 10000 % 1000 % 256;
      break;
  }
  return Color.fromARGB(255, c[0], c[1], c[2]);
}

late TripsTracker tripsTracker;

const TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 17);
const TextStyle textStyleBold =
    TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold);

int selectedTripId = 0;
late Trip selectedTrip;
List<DateTime> lastUpdateTripList = [];

String howMuchTimeAgo(DateTime dt) {
  if (dt.millisecondsSinceEpoch == 0) return 'never';
  DateTime current = DateTime.now();
  if (current.year != dt.year || current.month != dt.month) {
    return '${dt.day}/${dt.month}/${dt.year}';
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
  int indexDelete = -1;
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
                onTap: () {
                  indexDelete = -1;
                  tripsTracker.notifyOnly();
                  selectedTrip = tripsTracker.trips[index];
                  selectedTripId = selectedTrip.id!;

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddStopPage()));
                },
                onLongPress: () {
                  if (indexDelete == index) {
                    indexDelete = -1;
                  } else {
                    indexDelete = index;
                  }
                  tripsTracker.notifyOnly();
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                width: 2))),
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CircleAvatar(
                                backgroundColor:
                                    nameToColor(tripsTracker.trips[index].name),
                                foregroundColor: betterColor(nameToColor(
                                    tripsTracker.trips[index].name)),
                                child: Text(
                                  tripsTracker.trips[index].name.isEmpty
                                      ? ''
                                      : tripsTracker.trips[index].name[0],
                                  style: const TextStyle(fontSize: 23),
                                )),
                          ),
                          const SizedBox(width: 20),
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
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 17),
                                  children: <TextSpan>[
                                    const TextSpan(text: 'last update: '),
                                    TextSpan(
                                        text: howMuchTimeAgo(
                                            lastUpdateTripList[index]),
                                        style: textStyle),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ]),
                        (indexDelete == index
                            ? GestureDetector(
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Warning"),
                                        content: RichText(
                                          text: TextSpan(
                                            style: textStyle,
                                            children: <TextSpan>[
                                              const TextSpan(
                                                  text:
                                                      'Are you sure you want to delete '),
                                              TextSpan(
                                                  text: tripsTracker
                                                      .trips[indexDelete].name,
                                                  style: textStyleBold),
                                              const TextSpan(text: '?'),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text("YES"),
                                            onPressed: () async {
                                              await database.tripstopdao
                                                  .deleteAllTripStopsById(
                                                      tripsTracker
                                                          .trips[indexDelete]
                                                          .id!);
                                              await database.tripdao
                                                  .deleteAllTripsById(
                                                      tripsTracker
                                                          .trips[indexDelete]
                                                          .id!);
                                              indexDelete = -1;
                                              tripsTracker.update();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("NO"),
                                            onPressed: () {
                                              indexDelete = -1;
                                              tripsTracker.notifyOnly();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.red,
                                  child: const Icon(Icons.delete_outline,
                                      color: Colors.white),
                                ),
                              )
                            : const SizedBox(
                                width: 80,
                                height: 80,
                              ))
                      ],
                    )),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          indexDelete = -1;
          tripsTracker.notifyOnly();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTripPage()));
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TripsTracker extends ChangeNotifier {
  List<Trip> _trips = [];
  List<Trip> get trips => _trips;
  int updating = 0;

  Future<void> update() async {
    ++updating;
    _trips = (await database.tripdao.findAllTripsOrdered());
    lastUpdateTripList =
        List.filled(_trips.length, DateTime.fromMillisecondsSinceEpoch(0));
    for (int i = 0; i < _trips.length; ++i) {
      lastUpdateTripList[i] = DateTime.fromMillisecondsSinceEpoch(
          await database.tripstopdao.getLastUpdate(_trips[i].id!) ?? 0);
    }
    notifyListeners();
    if (updating == 1) {
      Future.delayed(const Duration(minutes: 1), update);
    }
    --updating;
  }

  void notifyOnly() {
    notifyListeners();
  }
}
