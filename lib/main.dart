import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flighttickets/CustomShapeClipper.dart';
import 'package:flighttickets/constants.dart';
import 'package:flighttickets/flight_list.dart';
import 'package:flighttickets/CustomAppBar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'Flight App Mock',
    options: const FirebaseOptions(
      googleAppID: '1:428371937243:android:6f22f8d058eda019cf09fe',
      gcmSenderID: '428371937243',
      apiKey: 'AIzaSyDzajQnyj5YnCX5Fv6LGI3ZPlhlCstz2RI',
      projectID: 'flight-app-mock-f9dbe',
    ),
  );

  runApp(
    MaterialApp(
      title: 'Flight List Mock Up',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: appTheme,
    ),
  );
}

List<String> locations = List();

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomAppBar(),
      body: Column(
        children: <Widget>[
          HomeScreenTopPart(),
          homeScreenBottomPart,
        ],
      ),
    );
  }
}

final _searchFieldController = TextEditingController();

class HomeScreenTopPart extends StatefulWidget {
  @override
  _HomeScreenTopPartState createState() => _HomeScreenTopPartState();
}

class _HomeScreenTopPartState extends State<HomeScreenTopPart> {
  var selectedLocationIndex = 0;
  bool isFightSelected = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 370,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kFirstColor, kSecondColor],
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                StreamBuilder(
                  stream:
                      Firestore.instance.collection('locations').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      addLocation(context, snapshot.data.documents);
                    return !snapshot.hasData
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: kWhiteColor,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                PopupMenuButton(
                                  onSelected: (index) {
                                    setState(() {
                                      selectedLocationIndex = index;
                                    });
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        locations[selectedLocationIndex],
                                        style: kDropDownLabelStyle,
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: kWhiteColor,
                                      )
                                    ],
                                  ),
                                  itemBuilder: (BuildContext context) => _buildPopupMenuItem(context),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.settings,
                                  color: kWhiteColor,
                                )
                              ],
                            ),
                          );
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.all(
                      (Radius.circular(10)),
                    ),
                    child: TextField(
                      controller: _searchFieldController,
                      style: kDropDownMenuItemStyle,
                      cursorColor: appTheme.primaryColor,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          suffixIcon: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.all(
                              (Radius.circular(30)),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        InheritedFlightListing(
                                      fromLocation:
                                          locations[selectedLocationIndex],
                                      toLocation: _searchFieldController.text,
                                      child: FlightListingScreen(),
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.search,
                                color: kBlackColor,
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      child: ChoiceChips(
                        Icons.flight_takeoff,
                        'Flights',
                        isFightSelected,
                      ),
                      onTap: () {
                        setState(() {
                          isFightSelected = true;
                        });
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      child: ChoiceChips(
                        Icons.hotel,
                        'Hotels',
                        !isFightSelected,
                      ),
                      onTap: () {
                        setState(() {
                          isFightSelected = false;
                        });
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<PopupMenuItem<int>> _buildPopupMenuItem(context) {
  List<PopupMenuItem> popupMenuItems = List();
  for (int i = 0; i < locations.length; i++) {
    popupMenuItems.add(
      PopupMenuItem(
        child: Text(
          locations[i],
          style: kDropDownMenuItemStyle,
        ),
        value: i,
      ),
    );
  }
  return popupMenuItems;
}

addLocation(BuildContext context, List<DocumentSnapshot> snapshots) {
  for (int i = 0; i < snapshots.length; i++) {
    final Location location = Location.fromSnapshot(snapshots[i]);
    locations.add(location.name);
  }
}

class ChoiceChips extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool isSelected;

  ChoiceChips(this.icon, this.text, this.isSelected);

  @override
  _ChoiceChipsState createState() => _ChoiceChipsState();
}

class _ChoiceChipsState extends State<ChoiceChips> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: widget.isSelected
          ? BoxDecoration(
              color: kWhiteColor.withOpacity(0.15),
              borderRadius: BorderRadius.all(Radius.circular(20)))
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            widget.icon,
            size: 20,
            color: kWhiteColor,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            widget.text,
            style: TextStyle(color: kWhiteColor, fontSize: 16),
          )
        ],
      ),
    );
  }
}

var homeScreenBottomPart = Column(
  children: <Widget>[
    Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Currently watched items',
            style: kDropDownMenuItemStyle,
          ),
          Spacer(),
          Text(
            'View all(12)'.toUpperCase(),
            style: kViewAllStyle,
          )
        ],
      ),
    ),
    Container(
      height: 220,
      child: StreamBuilder(
        stream: Firestore.instance.collection('cities').snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? CircularProgressIndicator
              : _buildCitiesList(context, snapshot.data.documents);
        },
      ),
    )
  ],
);

Widget _buildCitiesList(
    BuildContext context, List<DocumentSnapshot> snapshots) {
  return ListView.builder(
    itemCount: snapshots.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) {
      return CityCard(
        city: City.fromSnapshot(
          snapshots[index],
        ),
      );
    },
  );
}

class Location {
  final String name;

  Location.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        name = map['name'];

  Location.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);
}

class City {
  final String imagePath, cityName, monthYear, discount;
  final int oldPrice, newPrice;

  City.fromMap(Map<String, dynamic> map)
      : assert(map['cityName'] != null),
        assert(map['monthYear'] != null),
        assert(map['discount'] != null),
        assert(map['imagePath'] != null),
        imagePath = map['imagePath'],
        cityName = map['cityName'],
        monthYear = map['monthYear'],
        discount = map['discount'],
        oldPrice = map['oldPrice'],
        newPrice = map['newPrice'];

  City.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data);
}

class CityCard extends StatelessWidget {
  final City city;

  const CityCard({this.city});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    height: 190,
                    width: 165,
                    child: CachedNetworkImage(
                      imageUrl: '${city.imagePath}',
                      fit: BoxFit.cover,
                      fadeInDuration: Duration(milliseconds: 500),
                      fadeInCurve: Curves.easeIn,
                    )),
                Positioned(
                  left: 10,
                  bottom: 0,
                  width: 160,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                          kBlackColor,
                          kBlackColor.withOpacity(0.2)
                        ])),
                  ),
                ),
                Positioned(
                  right: 10,
                  left: 5,
                  bottom: 5,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${city.cityName}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${city.monthYear}',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          "${city.discount}%",
                          style: TextStyle(
                            fontSize: 14,
                            color: kBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              Text(
                '${city.newPrice}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '${city.oldPrice}',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 12),
              ),
            ],
          )
        ],
      ),
    );
  }
}
