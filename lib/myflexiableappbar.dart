import 'package:flutter/material.dart';

class MyFlexiableAppBar extends StatelessWidget {
  final double appBarHeight = 60.0;

  const MyFlexiableAppBar();

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + appBarHeight,
      child: new Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text("Holiday Line 1",
                        style: TextStyle(
                          color: Color.fromARGB(500, 13, 17, 50),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    child: new Text("Holiday Line 2",
                        style: const TextStyle(
                          color: Color.fromARGB(500, 13, 17, 50),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    child: new Text("Holiday Line 3",
                        style: const TextStyle(
                          color: Color.fromARGB(500, 13, 17, 50),
                          fontSize: 20,
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
                      child: Text("fecha Greg",
                          style: TextStyle(
                              color: Color.fromARGB(500, 13, 17, 50),
                              fontFamily: 'Poppins',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text("fecha Hebrew",
                          style: TextStyle(
                              color: Color.fromARGB(500, 13, 17, 50),
                              fontFamily: 'Poppins',
                              fontSize: 20.0,
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
          image: AssetImage('assets/maguendavidyellow.png'),
          fit: BoxFit.scaleDown,
        ),
        color: Colors.amber,
      ),
    );
  }
}
