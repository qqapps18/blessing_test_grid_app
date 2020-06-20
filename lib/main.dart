import 'package:flutter/material.dart';

void main() {
  runApp(BlessingGridView());
}

class BlessingGridView extends StatefulWidget {
  @override
  _BlessingGridViewState createState() => _BlessingGridViewState();
}

class _BlessingGridViewState extends State<BlessingGridView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Blessing Grid View'),
        ),
        body: GridView.count(
          crossAxisCount: 3,
          children: <Widget>[
            Card(
              color: Colors.amberAccent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: InkWell(
                      onTap: () {},
                      child: Image.asset(
                        'assets/imgblessingaftereaten.jpg',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Bendiciones Hijos',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Card(
              color: Colors.amberAccent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: InkWell(
                      onTap: () {},
                      child: Image.asset(
                        'assets/fondo_bendiciones.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Bendiciones Hijos',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Card(
              color: Colors.amberAccent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: InkWell(
                      onTap: () {},
                      child: Image.asset(
                        'assets/fondo_bendiciones.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Bendiciones 2',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Card(
              color: Colors.amberAccent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: InkWell(
                      onTap: () {},
                      child: Image.asset(
                        'assets/fondo_bendiciones.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Bendiciones 3',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
