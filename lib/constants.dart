import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Theme
ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFFF3791A),
  fontFamily: 'Oxygen'
);


// Colors
const Color kFirstColor = Color(0xFFF47D15);
const Color kSecondColor = Color(0xFFEF772C);
const kWhiteColor = Colors.white;
const kBlackColor = Colors.black;

// Flight Listing Screen Colors
final Color discountBackgroundColor = Color(0xFFFFE08D);
final Color flightBorderColor = Color(0xFFE6E6E6);
final Color chipBackgroundColor = Color(0xFFF6F6F6);

// Other content
List<String> locations = ['Boston (BOS)', 'New York City (JFK)'];

final formatCurrency = NumberFormat.simpleCurrency();

const TextStyle kDropDownLabelStyle = TextStyle(
  color: Colors.white,
  fontSize: 16
);

const TextStyle kDropDownMenuItemStyle = TextStyle(
    color: Colors.black,
    fontSize: 16
);

const TextStyle kOldPriceStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    decoration: TextDecoration.lineThrough,
    color: Colors.grey
);

const TextStyle kNewPriceStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
);

var kViewAllStyle = TextStyle(
  fontSize: 14,
  color: appTheme.primaryColor
);