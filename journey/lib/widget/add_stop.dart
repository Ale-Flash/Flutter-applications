// ignore_for_file: use_build_context_synchronously

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:journey/entity/stop.dart';
import 'package:journey/entity/tripstops.dart';
import 'package:journey/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:journey/main.dart';
import 'package:journey/widget/map.dart';
import 'package:journey/widget/numeric_input.dart';
import 'package:provider/provider.dart';

class AddStopPage extends StatelessWidget {
  const AddStopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StopsTracker>(
        create: (context) => StopsTracker(), child: const AddStopPage1());
  }
}

class AddStopPage1 extends StatefulWidget {
  const AddStopPage1({super.key});

  @override
  State<AddStopPage1> createState() => _AddStopPageState();
}

Future<Position?> getLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .timeout(const Duration(seconds: 5));
    return position;
  } catch (e) {
    debugPrint('Error: $e');
  }
  return null;
}

late StopsTracker stopsTracker;
const TextStyle textStyleGrey =
    TextStyle(color: Color(0xFF3E3E3E), fontSize: 12);
const TextStyle textStyleInfos = TextStyle(color: Colors.black, fontSize: 15);
bool map = false;
Stop? selectedStop;
Coords? mapPosition;

class _AddStopPageState extends State<AddStopPage1> {
  

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    InputForm name = InputForm(label: "Name", size: 60, lines: 1);
    NumericInputForm lat = NumericInputForm(label: "Latitude", size: 60);
    NumericInputForm long = NumericInputForm(label: "Longitude", size: 60);
    InputForm info = InputForm(label: "Infos", size: 90, lines: 3);

    stopsTracker = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Stop'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MapScreen()));
              map = !map;
              stopsTracker.reload();
            },
            child: Container(
              width: 50,
              height: 50,
              color: Colors.red,
              child: Icon(map ? Icons.add : Icons.map),
            ),
          )
        ],
      ),
      body: ListView.builder(
          itemCount: stopsTracker.stops.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              // if (map) { // TODO make new page perché se no non si riesce a spostare nella lista
              //   return SizedBox(
              //     height: 300,
              //     child: GoogleMap(
              //       initialCameraPosition: CameraPosition(
              //         target: selectedStop == null
              //             ? const LatLng(41.4575846, 12.6610751)
              //             : LatLng(selectedStop!.lat, selectedStop!.lang),
              //         zoom: 14,
              //       ),
              //       markers: markerFiller(),
              //     ),
              //   );
              // } else {
                return Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          width: 2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  height: 240,
                  child: Column(children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.67,
                          child: name,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              // check if has permission
                              LocationPermission permission =
                                  await Geolocator.checkPermission();
                              if (permission == LocationPermission.denied) {
                                await Geolocator.requestPermission();
                              }
                              permission = await Geolocator.checkPermission();

                              if (permission != LocationPermission.denied) {
                                Position? p = await getLocation();
                                if (p != null) {
                                  lat.txt.text = p.latitude.toString();
                                  long.txt.text = p.longitude.toString();
                                  lat.value = p.latitude.toString();
                                  long.value = p.longitude.toString();
                                }
                              }
                            },
                            child: const Text('set position'))
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.47,
                          child: lat,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.47,
                          child: long,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.77,
                          child: info,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              // check parameters
                              if (name.value.isEmpty ||
                                  lat.value.isEmpty ||
                                  long.value.isEmpty ||
                                  info.value.isEmpty ||
                                  double.tryParse(lat.value) == null ||
                                  double.tryParse(long.value) == null) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertDialog(
                                          title: Text('Error'),
                                          content: Text(
                                              'Warning not all fields are completed, please fill them before saving'));
                                    });
                              } else {
                                int stopId = await database.stopdao.insertStop(
                                    Stop(
                                        null,
                                        name.value,
                                        info.value,
                                        double.parse(lat.value),
                                        double.parse(long.value),
                                        DateTime.now()));

                                await database.tripstopdao.insertTripStop(
                                    TripStop(selectedTripId, stopId));
                                stopsTracker.update();
                                // delete paramenters
                                name.txt.text = "";
                                lat.txt.text = "";
                                long.txt.text = "";
                                info.txt.text = "";
                                name.value = "";
                                lat.value = "";
                                long.value = "";
                                info.value = "";
                              }
                            },
                            child: const Text('save')),
                      ],
                    ),
                  ]),
                );
              // }
            } else {
              return GestureDetector(
                  onTap: () {
                    selectedStop = stopsTracker.stops[index - 1];
                    print(selectedStop!.name);
                    if (map) stopsTracker.reload();

                    // TODO FIXME
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MapScreen()));
                  },
                  onLongPress: () {
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
                                      text: 'Are you sure you want to delete '),
                                  TextSpan(
                                      text: stopsTracker.stops[index - 1].name,
                                      style: textStyleBold),
                                  const TextSpan(text: '?'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text("YES"),
                                onPressed: () async {
                                  await database.tripstopdao.deleteStopById(
                                      selectedTripId,
                                      stopsTracker.stops[index - 1].id!);
                                  stopsTracker.update();
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text("NO"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                width: 2))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.68,
                              child: Column(
                                children: [
                                  Text(stopsTracker.stops[index - 1].name,
                                      overflow: TextOverflow.ellipsis,
                                      style: textStyleBold),
                                  Text(stopsTracker.stops[index - 1].info,
                                      maxLines: 3,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: textStyle),
                                ],
                              )),
                          Column(
                            children: [
                              const Text('latitude:', style: textStyleGrey),
                              Text(stopsTracker.stops[index - 1].lat.toString(),
                                  style: textStyleInfos),
                              const Text('longitude:', style: textStyleGrey),
                              Text(
                                  stopsTracker.stops[index - 1].lang.toString(),
                                  style: textStyleInfos),
                              const Text('date:', style: textStyleGrey),
                              Text(
                                  datetimeToString(
                                      stopsTracker.stops[index - 1].datetime),
                                  style: textStyleInfos),
                            ],
                          )
                        ]),
                  ));
            }
          }),
    );
  }
}

String datetimeToString(DateTime dt) {
  return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')} ${dt.day}/${dt.month}/${dt.year}";
}

class StopsTracker extends ChangeNotifier {
  List<Stop> _stops = [];
  List<Stop> get stops => _stops;
  StopsTracker() {
    database.tripstopdao.findStopsByTripId(selectedTripId).then((value) {
      _stops = value;
      notifyListeners();
    });
  }
  Future<void> update() async {
    _stops = (await database.tripstopdao.findStopsByTripId(selectedTripId))
        .reversed
        .toList();
    notifyListeners();
    tripsTracker.update();
  }

  void reload() {
    notifyListeners();
  }
}

class Coords {
  final double lat, long;
  const Coords(this.lat, this.long);
}
