import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';
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
          // enlace a la tienda para que califiquen la app
          //TODO de dejar esta opcion, faltaria eliminar el enlance una
          //TODO vez que se utilice

          InkWell(
            onTap: () {
              StoreRedirect.redirect(
                  androidAppId: "com.qqapps.blessingbook",
                  iOSAppId: "com.qqapps.blessingbook");
            },
            child: Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                child: Image(
                  image: AssetImage('assets/iconrate.png'),
                  fit: BoxFit.cover,
                  height: 30,
                  width: 30,
                ),

                //child: Text(''),
              ),
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
