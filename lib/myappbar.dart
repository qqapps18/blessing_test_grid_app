import 'package:flutter/material.dart';
import 'package:blessingtestgridapp/localization/App_Localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/localization_constants.dart';

class MyAppBar extends StatefulWidget {

  const MyAppBar();

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  final double barHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
              child: Text(''),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Text(
                getTranslated(context, 'Book_Of_Blessings'),
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontFamily: 'RobotoSlab',
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Text('')),
          ),
        ],
      ),
    );
  }
}
