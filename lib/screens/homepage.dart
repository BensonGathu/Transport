import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transportapp/screens/serviceProviders.dart';
import 'package:transportapp/utils/colors.dart';
import 'package:transportapp/widgets/text_input.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CardItem {
  final String urlImage;
  final String title;
  const CardItem({required this.urlImage, required this.title});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _currentLocationController =
      TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  late SingleValueDropDownController _timeController;
  late SingleValueDropDownController _pickUpLocationController;
  bool _isLoading = false;

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
    _timeController = SingleValueDropDownController();
    _pickUpLocationController = SingleValueDropDownController();
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
                      child: Text("MAP AREA"),
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
