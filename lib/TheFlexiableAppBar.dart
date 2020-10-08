import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'localization/localization_constants.dart';

class MyFlexiableAppBar extends StatelessWidget {
  final double appBarHeight = 60.0;

  final String datehebrew;
  final String date;
  final String headerimage;
  final String holidayline1;
  final String holidayline2;
  final String holidayline3;

  const MyFlexiableAppBar(this.date, this.datehebrew, this.headerimage,
      this.holidayline1, this.holidayline2, this.holidayline3);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    print(' estoy  en MyFlexiableAppBar ' + headerimage + ' ' + holidayline2);

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + appBarHeight,
      child: new Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text('$holidayline1',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'RobotoSlab',
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Container(
                        child: Text('$holidayline2',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'RobotoSlab',
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Container(
                        child: Text('$holidayline3',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'RobotoSlab',
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(date,
                              style: TextStyle(
                                  color: Color.fromARGB(500, 13, 17, 50),
                                  fontFamily: 'RobotoSlab',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(datehebrew,
                              style: TextStyle(
                                  color: Color.fromARGB(500, 13, 17, 50),
                                  fontFamily: 'RobotoSlab',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
      decoration: new BoxDecoration(
        image: DecorationImage(
          image: AssetImage(headerimage),
          fit: BoxFit.scaleDown,
        ),
        color: Colors.amber,
      ),
    );
  }
}
