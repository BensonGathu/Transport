import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  final TextEditingController _currentLocationController =
      TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  late SingleValueDropDownController _timeController;
  late SingleValueDropDownController _pickUpLocationController;
  bool _isLoading = false;
  String? _currentAddress;
  Position? _currentPosition;
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

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
    super.initState();
    _getCurrentPosition();
    _timeController = SingleValueDropDownController();
    _pickUpLocationController = SingleValueDropDownController();
  }

  //checks if the app ahs permision to access the users location
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
      // setState(() => sourceLocation = position as LatLng);
      _getAddressFromLatLng(_currentPosition!);
      print("Your current location is....");
      print(position);
      print(sourceLocation);
      print("Your current address is....");
      print(_currentAddress);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  //transforming longitudes and latitudes to address
  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
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
  Widget build(BuildContext context) {
    final InputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(children: [
                  const Flexible(
                    flex: 2,
                    child: SizedBox(
                      height: 200,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: sourceLocation,
                          zoom: 13.5,
                        ),
                      ),
                    ),
                  ),
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
                    searchDecoration:
                        const InputDecoration(hintText: "Search travel Time"),
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
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
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
                ]))));
  }
}
