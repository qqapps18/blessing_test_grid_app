import 'package:flutter/material.dart';
import 'package:blessingtestgridapp/localization/App_Localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/localization_constants.dart';

class MyAppBar extends StatelessWidget {
  final double barHeight = 60.0;

  const MyAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Icon(
                Icons.menu,
                color: Colors.red,
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Text(
                getTranslated(context, 'Book_Of_Blessings'),
                style: TextStyle(
                  color: Color.fromARGB(500, 13, 17, 50),
                  fontFamily: 'Poppins',
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Icon(
                Icons.menu,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
