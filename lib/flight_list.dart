import 'package:flighttickets/CustomShapeClipper.dart';
import 'package:flighttickets/main.dart';
import 'package:flutter/material.dart';
import 'package:flighttickets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InheritedFlightListing extends InheritedWidget {
  final String fromLocation, toLocation;

  InheritedFlightListing({this.fromLocation, this.toLocation, Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static InheritedFlightListing of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();
}

class FlightListingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Result',
        ),
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            FlightListTopPart(),
            SizedBox(
              height: 16,
            ),
            FlightListingBottomPart(),
          ],
        ),
      ),
    );
  }
}

class FlightListTopPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kFirstColor, kSecondColor],
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16),
              elevation: 10,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${InheritedFlightListing.of(context).fromLocation}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Divider(
                            color: Colors.grey,
                            height: 20,
                          ),
                          Text(
                            '${InheritedFlightListing.of(context).toLocation}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.import_export,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

class FlightListingBottomPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Best Deals for Next 6 Months",
              style: kDropDownMenuItemStyle,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: Firestore.instance.collection('deals').snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? CircularProgressIndicator
                  : _buildDealsList(context, snapshot.data.documents);
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildDealsList(BuildContext context, List<DocumentSnapshot> snapshots) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: snapshots.length,
    physics: ClampingScrollPhysics(),
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) {
      return FlightCard(
        flightDetails: FlightDetails.fromSnapshot(
          snapshots[index],
        ),
      );
    },
  );
}

class FlightDetails {
  final String airlines, date, discount, rating;
  final int oldPrice, newPrice;

  FlightDetails.fromMap(Map<String, dynamic> map)
      : assert(map['airlines'] != null),
        assert(map['date'] != null),
        assert(map['discount'] != null),
        assert(map['rating'] != null),
        airlines = map['airlines'],
        date = map['date'],
        discount = map['discount'],
        oldPrice = map['oldPrice'],
        newPrice = map['newPrice'],
        rating = map['rating'];

  FlightDetails.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);
}

class FlightCard extends StatelessWidget {
  final FlightDetails flightDetails;

  const FlightCard({this.flightDetails});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(color: flightBorderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "${formatCurrency.format(flightDetails.newPrice)}",
                        style: kNewPriceStyle,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "${formatCurrency.format(flightDetails.oldPrice)}",
                        style: kOldPriceStyle,
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: -8,
                    children: <Widget>[
                      FlightDetailsChip(
                        Icons.calendar_today,
                        "${flightDetails.date}",
                      ),
                      FlightDetailsChip(
                        Icons.flight_takeoff,
                        "${flightDetails.airlines}",
                      ),
                      FlightDetailsChip(
                        Icons.star,
                        "${flightDetails.rating}",
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                "${flightDetails.discount}",
                style: TextStyle(
                    color: appTheme.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(
                color: discountBackgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FlightDetailsChip extends StatelessWidget {
  final IconData iconData;
  final String label;

  FlightDetailsChip(this.iconData, this.label);

  @override
  Widget build(BuildContext context) {
    return RawChip(
      label: Text(
        label,
      ),
      labelStyle: TextStyle(color: Colors.black, fontSize: 14),
      backgroundColor: chipBackgroundColor,
      avatar: Icon(
        iconData,
        size: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }
}
