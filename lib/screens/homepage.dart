// ignore_for_file: unnecessary_const

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';
import 'package:transportapp/screens/serviceProviders.dart';
import 'package:transportapp/utils/colors.dart';
import 'package:transportapp/widgets/text_input.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  //late LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  late LatLng destination = LatLng(37.33429383, -122.06600055);
  //late GoogleMapController _controller;
  // The camera position
  late CameraPosition _cameraPosition;
  // The latitude and longitude variable
  late LatLng sourceLocation;
  // late LatLng destination;
  // Camera markers
  final Set<Marker> _markers = {};
  // enable readOnly in input fields

  final TextEditingController _currentLocationController =
      TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  late SingleValueDropDownController _timeController;
  late SingleValueDropDownController _pickUpLocationController;
  bool _isLoading = false;

  List<LatLng> polylineCoordinates = [];
  String? _currentAddress;
  Position? _currentPosition;

  List<DropDownValueModel> pickUpList = const [
    DropDownValueModel(name: 'Stage 1', value: "Stage 1"),
    DropDownValueModel(
        name: 'Stage2',
        value: "Stage2",
        toolTipMsg:
            "DropDownButton is a widget that we can use to select one unique value from a set of values"),
    DropDownValueModel(name: 'Stage3', value: "Stage3"),
    DropDownValueModel(
        name: 'Stage4',
        value: "Stage4",
        toolTipMsg:
            "DropDownButton is a widget that we can use to select one unique value from a set of values"),
  ];

  List<DropDownValueModel> timeTravelList = const [
    DropDownValueModel(name: '8:00', value: "8:00"),
    DropDownValueModel(
        name: '9:00',
        value: "9:00",
        toolTipMsg:
            "DropDownButton is a widget that we can use to select one unique value from a set of values"),
    DropDownValueModel(name: '10:00', value: "10:00"),
    DropDownValueModel(
        name: '11:00',
        value: "11:00",
        toolTipMsg:
            "DropDownButton is a widget that we can use to select one unique value from a set of values"),
  ];
  @override
  void initState() {
    // TODO: implement initState
    getPolyPoints();
    _getCurrentPosition();
    _timeController = SingleValueDropDownController();
    _pickUpLocationController = SingleValueDropDownController();
    super.initState();
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyA1Hs6Grza62ekFVZnUYSzD97Gwmyqs3Oc", // Your Google Map Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      sourceLocation = LatLng(double.parse(position.latitude.toString()), double.parse(position.longitude.toString()));
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // Future<void> getLocation(String Lat, String Long) async {
  //   // Get the location
  //   setState(() {
  //     // Update controllers
  //     if (Lat.isNotEmpty && Long.isNotEmpty) {
  //       sourceLocation = LatLng(double.parse(Lat), double.parse(Long));
  //     }

  //     _cameraPosition = CameraPosition(target: sourceLocation, zoom: 19.0);
  //     // _controller
  //     //     .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));

  //     // Set markers
  //     _markers.add(Marker(
  //         markerId: const MarkerId('a'),
  //         draggable: true,
  //         position: sourceLocation,
  //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //         onDragEnd: (currentlatLng) {
  //           sourceLocation = currentlatLng;
  //         }));
  //   });
  //   return;
  // }

  void searchOperator() async {
    setState(() {
      _isLoading = true;
    });
    print(_currentLocationController.text);
    print(_destinationController.text);
    print(_timeController.dropDownValue);
    print(_pickUpLocationController.dropDownValue);
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => serviceProvider(),
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _currentLocationController.dispose();
    _destinationController.dispose();
    _timeController.dispose();
    _pickUpLocationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final InputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return Scaffold(
        body: SafeArea(
            child: Container(
                //padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(children: [
                  Flexible(
                    flex: 4,
                    child: SizedBox(
                      height: 320,
                      child: sourceLocation == null
                          ? const Center(child: Text("Loading"))
                          : GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: sourceLocation,
                                zoom: 13.5,
                              ),
                              // markers: _markers,
                              markers: {
                                Marker(
                                  markerId: const MarkerId("currentLocation"),
                                  position: LatLng(sourceLocation!.latitude!,
                                      sourceLocation!.longitude!),
                                ),
                                Marker(
                                  markerId: const MarkerId("currentLocation"),
                                  position: LatLng(destination!.latitude!,
                                      destination!.longitude!),
                                ),
                              },
                              polylines: {
                                Polyline(
                                  polylineId: const PolylineId("route"),
                                  points: polylineCoordinates,
                                  color: const Color(0xFF7B61FF),
                                  width: 6,
                                ),
                              },
                              onMapCreated: (mapController) {
                                _controller.complete(mapController);
                              },
                            ),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          TextFieldInput(
                            icon: const Icon(Icons.my_location_outlined),
                            hintText: 'Your Location',
                            textInputType: TextInputType.text,
                            textEditingController: _currentLocationController,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFieldInput(
                            icon: const Icon(Icons.location_on_outlined),
                            hintText: 'Your Destination',
                            textInputType: TextInputType.text,
                            textEditingController: _destinationController,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          //TIME PICKER
                          DropDownTextField(
                            controller: _timeController,
                            clearOption: true,
                            enableSearch: true,
                            searchDecoration: const InputDecoration(
                                hintText: "Search travel Time"),
                            validator: (value) {
                              if (value == null) {
                                return "Required field";
                              } else {
                                return null;
                              }
                            },
                            dropDownItemCount: timeTravelList.length,
                            dropDownList: timeTravelList,
                            onChanged: (val) {},
                          ),
                          const SizedBox(
                            height: 24,
                          ),

                          //LOCATION PICKUP
                          DropDownTextField(
                            controller: _pickUpLocationController,
                            clearOption: true,
                            enableSearch: true,
                            searchDecoration: const InputDecoration(
                                hintText: "Search PickUp Location"),
                            validator: (value) {
                              if (value == null) {
                                return "Required field";
                              } else {
                                return null;
                              }
                            },
                            dropDownItemCount: pickUpList.length,
                            dropDownList: pickUpList,
                            onChanged: (val) {},
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          InkWell(
                              onTap: searchOperator,
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    color: blueColor),
                                child: _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                            color: primaryColor),
                                      )
                                    : const Text('Search Operators',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                              ))
                        ],
                      )),
                ]))));
  }
}
