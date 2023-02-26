import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:journey/widget/add_stop.dart';
import 'package:journey/widget/map.dart';
import 'package:place_picker/widgets/place_picker.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Choose your location')),
        body: PlacePicker(
          googleAPiKey,
          displayLocation: LatLng(lastCoords.lat, lastCoords.long),
        ));
  }
}
