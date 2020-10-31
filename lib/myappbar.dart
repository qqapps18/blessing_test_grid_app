import 'package:flutter/material.dart';
import 'localization/localization_constants.dart';
import 'package:google_fonts/google_fonts.dart';

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
                style: GoogleFonts.sourceSerifPro(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(500, 184, 29, 29),
                  fontStyle: FontStyle.italic,
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
