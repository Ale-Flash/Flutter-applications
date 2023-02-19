import 'package:geolocator/geolocator.dart';
import 'package:journey/entity/stop.dart';
import 'package:journey/entity/trip.dart';
import 'package:journey/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:journey/main.dart';
import 'package:journey/widget/input_multiple_lines.dart';
import 'package:journey/widget/numeric_input.dart';

class AddStopPage extends StatefulWidget {
  const AddStopPage({super.key});

  @override
  State<AddStopPage> createState() => _AddStopPageState();
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

class _AddStopPageState extends State<AddStopPage> {
  @override
  Widget build(BuildContext context) {
    InputForm name = InputForm(label: "Name", size: 60);
    NumericInputForm lat = NumericInputForm(label: "Latitude", size: 60);
    NumericInputForm long = NumericInputForm(label: "Longitude", size: 60);
    MultipleLinesInputForm info =
        MultipleLinesInputForm(label: "Infos", size: 90, lines: 3);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Trip'),
        ),
        body: ListView.builder(
            itemCount: stopsSelectedTrip.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  color: Colors.red,
                  height: 240,
                  child: Column(children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: name,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              // TODO
                              print('pressed set position');

                              // TODO fare icona di caricamento

                              // check if has permission
                              LocationPermission permission =
                                  await Geolocator.checkPermission();
                              if (permission == LocationPermission.denied) {
                                await Geolocator.requestPermission();
                              }
                              permission = await Geolocator.checkPermission();
                              if (permission == LocationPermission.denied) {
                                return;
                              }
                              Position? p = await getLocation();
                              if (p == null) return;
                              lat.txt.text = p.latitude.toString();
                              long.txt.text = p.longitude.toString();
                            },
                            child: const Text('set position'))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: lat,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: long,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: info,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              // TODO pressed save button

                              // TODO inserirla dentro al Trip, l'id lo sappiamo, non sappiamo l'id dello Stop

                              database.stopdao.insertStop(Stop(
                                  null,
                                  name.value,
                                  info.value,
                                  double.tryParse(lat.value) ?? 0,
                                  double.tryParse(long.value) ?? 0));
                            },
                            child: const Text('save')),
                      ],
                    ),
                  ]),
                );
              } else {
                return Container(
                  height: 120,
                  color: Colors.grey,
                  child: Row(children: [
                    Column(
                      children: [
                        Text(stopsSelectedTrip[index - 1].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textStyleBold),
                        Text(stopsSelectedTrip[index - 1].info,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: textStyle)
                      ],
                    )
                  ]),
                );
              }
            }));
  }
}
