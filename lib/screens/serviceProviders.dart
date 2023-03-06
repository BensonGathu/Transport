import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:badges/badges.dart' as badges;

class serviceProvider extends StatefulWidget {
  @override
  State<serviceProvider> createState() => _serviceProviderState();
}

class _serviceProviderState extends State<serviceProvider> {
  //const serviceProvider({super.key});
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Available Operators'),
        ),
        body: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: SizedBox(
                    
                    child: ExpansionTileCard(
                      baseColor: Color.fromARGB(255, 224, 247, 250),
                      expandedColor: Colors.cyan[50],
                      // key: cardA,
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage("assets/SM.jpg"),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Super Metro",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "ksh 240",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                //backgroundColor: Color.fromARGB(255, 191, 245, 253),
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: const [
                          Text("KCC 111A \n33 Seater Bus",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                              )),
                        ],
                      ),
                      children: <Widget>[
                        const Divider(
                          thickness: 1.0,
                          height: 1.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Column(children: const [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text("Isuzu Model "),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text("14 Available Seats"),
                              )
                            ]),
                            // child: Text(
                            //   "FlutterDevs specializes in creating cost-effective and efficient applications with our perfectly crafted,"
                            // ,
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .bodyText2
                            //       ?.copyWith(fontSize: 16),
                            // ),
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceAround,
                          buttonHeight: 52.0,
                          buttonMinWidth: 90.0,
                          children: <Widget>[
                            TextButton(
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(4.0)),
                              onPressed: () {
                                cardA.currentState?.expand();
                              },
                              child: Column(
                                children: const <Widget>[
                                  // Icon(Icons.arrow_downward),
                                  // Padding(
                                  //   padding: EdgeInsets.symmetric(vertical: 2.0),
                                  // ),
                                  // Text('Open'),
                                ],
                              ),
                            ),
                            // TextButton(
                            //   // shape: RoundedRectangleBorder(
                            //   //     borderRadius: BorderRadius.circular(4.0)),
                            //   onPressed: () {
                            //     cardA.currentState?.collapse();
                            //   },
                            //   child: Column(
                            //     children: <Widget>[
                            //       Icon(Icons.arrow_upward),
                            //       Padding(
                            //         padding: const EdgeInsets.symmetric(vertical: 2.0),
                            //       ),
                            //       Text('Close'),
                            //     ],
                            //   ),
                            // ),
                            TextButton(
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(4.0)),
                              onPressed: () {},
                              child: Column(
                                children: const <Widget>[
                                  Icon(Icons.arrow_forward),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  // Text('Toggle'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
            }));
  }
}
