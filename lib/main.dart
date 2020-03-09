import 'package:flutter/material.dart';
import 'package:flighttickets/CustomShapeClipper.dart';
import 'package:flighttickets/constants.dart';

void main() => runApp(
      MaterialApp(
        title: 'Flight List Mock Up',
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
        theme: appTheme,
      ),
    );

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          HomeScreenTopPart(),
        ],
      ),
    );
  }
}

class HomeScreenTopPart extends StatefulWidget {
  @override
  _HomeScreenTopPartState createState() => _HomeScreenTopPartState();
}

class _HomeScreenTopPartState extends State<HomeScreenTopPart> {
  var selectedLocationIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 400,
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
                Padding(
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
                              style: dropDownLabelStyle,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: kWhiteColor,
                            )
                          ],
                        ),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuItem<int>>[
                          PopupMenuItem(
                            child: Text(
                              locations[0],
                              style: dropDownMenuItemStyle,
                            ),
                            value: 0,
                          ),
                          PopupMenuItem(
                            child: Text(
                              locations[1],
                              style: dropDownMenuItemStyle,
                            ),
                            value: 1,
                          ),
                        ],
                      ),
                      Spacer(),
                      Icon(
                        Icons.settings,
                        color: kWhiteColor,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
