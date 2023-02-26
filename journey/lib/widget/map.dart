import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:journey/main.dart';
import 'package:journey/widget/add_stop.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

String googleAPiKey = "AIzaSyDNPoPB8bcMwOo9l2-wnNzXgRWe_seERfY";

class _MapScreenState extends State<MapScreen> {
  List<PointLatLng> listWayPoints() {
    List<PointLatLng> res = List.generate(
        stopsTracker.stops.length,
        (index) => PointLatLng(
            stopsTracker.stops[index].lat, stopsTracker.stops[index].lang));
    PolylineWayPoint(location: "asdf", stopOver: true);
    return res;
  }

  Set<Marker> markers = {}; //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  @override
  void initState() {
    super.initState();

    stopsTracker.stops.forEach((stop) {
      markers.add(Marker(
        markerId: MarkerId(stop.id.toString()),
        visible: true,
        infoWindow: InfoWindow(
          //popup info
          title: stop.name,
          snippet: stop.info,
        ),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(stop.lat, stop.lang),
      ));
    });

    getDirections(); //fetch direction polylines from Google API
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    for (int i = 0; i < stopsTracker.stops.length - 1; ++i) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(stopsTracker.stops[i].lat, stopsTracker.stops[i].lang),
        PointLatLng(
            stopsTracker.stops[i + 1].lat, stopsTracker.stops[i + 1].lang),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
    }

    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  Set<Marker> markerFiller() {
    Set<Marker> res =
        Set.from(List.generate(stopsTracker.stops.length, (index) {
      return Marker(
        markerId: MarkerId(stopsTracker.stops[index].id.toString()),
        infoWindow: InfoWindow(
          //popup info
          title: stopsTracker.stops[index].name,
          snippet: stopsTracker.stops[index].info,
        ),
        position: LatLng(
            stopsTracker.stops[index].lat, stopsTracker.stops[index].lang),
      );
    }));
    return res;
  }

  PolylinePoints polylinePoints = PolylinePoints();
  GoogleMapController? mapController;

  List<LatLng> polylineCoordinates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(selectedTrip.name)),
      body: GoogleMap(
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: stopsTracker.stops.isEmpty
              ? const LatLng(1, 1)
              : LatLng(stopsTracker.stops[0].lat, stopsTracker.stops[0].lang),
          zoom: 16,
        ),
        polylines: Set<Polyline>.of(polylines.values),
        mapType: MapType.satellite,
        markers: markerFiller(),
        onMapCreated: (controller) {
          //method called when map is created
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}
