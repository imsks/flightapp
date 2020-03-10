import 'package:flighttickets/constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomBarItems = [];

  final bottomNavigationBarItemStyle = TextStyle(
    fontStyle: FontStyle.normal,
    color: kBlackColor
  );

  CustomAppBar() {
    bottomBarItems.add(
      BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.home,
          color: appTheme.primaryColor,
        ),
        icon: Icon(
          Icons.home,
          color: kBlackColor,
        ),
        title: Text(
          "Explore",
          style: TextStyle(color: kBlackColor),
        ),
      ),
    );
    bottomBarItems.add(
      BottomNavigationBarItem(
        icon: Icon(
          Icons.favorite,
          color: kBlackColor,
        ),
        title: Text(
          "Watchlist",
          style: TextStyle(color: kBlackColor),
        ),
      ),
    );
    bottomBarItems.add(
      BottomNavigationBarItem(
        icon: Icon(
          Icons.local_offer,
          color: kBlackColor,
        ),
        title: Text(
          "Deals",
          style: TextStyle(color: kBlackColor),
        ),
      ),
    );
    bottomBarItems.add(
      BottomNavigationBarItem(
        icon: Icon(
          Icons.notifications,
          color: kBlackColor,
        ),
        title: Text(
          "Notifications",
          style: TextStyle(color: kBlackColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 15,
      child: BottomNavigationBar(
        items: bottomBarItems,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
