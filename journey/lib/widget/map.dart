import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:journey/widget/add_stop.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng initialLocation = const LatLng(37.422131, -122.084801);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  List<PointLatLng> listWayPoints() {
    List<PointLatLng> res = List.generate(
        stopsTracker.stops.length,
        (index) => PointLatLng(
            stopsTracker.stops[index].lat, stopsTracker.stops[index].lang));
    PolylineWayPoint(location: "asdf", stopOver: true);
    return res;
  }

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  @override
  void initState() {
    super.initState();

    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(startLocation.toString()),
      position: startLocation, //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Starting Point ',
        snippet: 'Start Marker',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    markers.add(Marker(
      //add distination location marker
      markerId: MarkerId(endLocation.toString()),
      position: endLocation, //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Destination Point ',
        snippet: 'Destination Marker',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    getDirections(); //fetch direction polylines from Google API
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: GoogleMap(
  //       initialCameraPosition: CameraPosition(
  //         target: initialLocation,
  //         zoom: 14,
  //       ),
  //       markers: markerFiller(),
  //     ),
  //   );
  // }
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyDNPoPB8bcMwOo9l2-wnNzXgRWe_seERfY";
  GoogleMapController? mapController;

  LatLng startLocation = const LatLng(27.6683619, 85.3101895);
  LatLng endLocation = const LatLng(27.6688312, 85.3077329);

  List<LatLng> polylineCoordinates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 14,
        ),
        polylines: Set<Polyline>.of(polylines.values),
        mapType: MapType.satellite,
        onMapCreated: (controller) { //method called when map is created
                      setState(() {
                        mapController = controller; 
                      });
                    },

      ),
    );
  }
}
