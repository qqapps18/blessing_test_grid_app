import 'dart:async';

import 'dart:math';
import 'package:blessingbook/BlessingSectionHeader.dart';
import 'package:blessingbook/GridLayoutHelper.dart';
import 'package:blessingbook/localization/App_Localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:store_redirect/store_redirect.dart';
import 'Blessing.dart';
import 'FileProvider.dart';
import 'BlessingSectionHeader.dart';
import 'localization/localization_constants.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sunrise_sunset/sunrise_sunset.dart';

import 'myappbar.dart';
import 'HeaderIsHolliday.dart';

import 'dart:io';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    // DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp
  ]);
  runApp(BlessingGridView());
}

class BlessingGridView extends StatefulWidget {
  @override
  _BlessingGridViewState createState() => _BlessingGridViewState();
}

class _BlessingGridViewState extends State<BlessingGridView> {
  String intTimeString;
  int intTime;
  String headerImage = 'assets/maguendavidyellow.png';
  String holidayText = 'texto de pruebga';

  // Inicializamos la clase 'FileProvider'
  var fileProvider = FileProvider();
  var gridLayoutHelper = GridLayoutHelper();

  DateTime date = DateTime.now();
  DateTime dateUTC;

  String _deviceLocale;

  String hmonth;
  int hyom;
  int hshana;
  bool hisLeapYear;
  int dayofweek;
  String holidayline1 = ' ';
  String holidayline2 = ' ';
  String holidayline3 = ' ';
  String headerimage = 'assets/splashlogo.gif';
  int istzomesther = 0;
  String position;
  double lat;
  double long;
  DateTime sunrisetime;
  DateTime sunsettime;
  bool swfestivity = false;
  bool swtzom = false;

  bool isLargeScreen = false;
  double screenWidth;
  double screenHeight;
  int widecount;
  bool isLargeScreenPortrait = false;
  String phoneTypePoss;
  double aspectRatio;
  String os;

  @override
  void initState() {
//    print('++++++++++++++++++  initstate ++++++++++++++++++++');
    fileProvider
        .getDocuments()
        .then((file) => _getCurrentlocation())
        .then((point) => _getSunriseSunset(point));
//        .then((sunrisedata) => checkHoliday(sunrisedata));
    dayofweek = date.weekday;
    intTimeString =
        DateFormat.H(_deviceLocale).format(DateTime.now().toLocal());
    intTime = int.parse(intTimeString);
    hmonth = fileProvider.jodesh;
    hyom = fileProvider.yom;
    hshana = fileProvider.shana;
    hisLeapYear = fileProvider.isleapyear;

    super.initState();
  }

// Inicializamos un arreglo con todos los blessings que queremos mostrar.
  // Idealmente, este arreglo se cambiaria por otra clase que nos provea la
  // estructura de la vista, es decir, el número de secciones y la cantidad de
  // elementos por sección.

  // se agrego nombre para el AppBar de la lectura del PDF
  var blessingsPDFs = [
    Blessing('Blessing_of_Children', "B_PDF_Children",
        'assets/fondo_bendiciones.png', "B_Children"),
    Blessing("Affixing_a_Mezuzah", "B_PDF_Mezuzah",
        'assets/fondo_bendiciones.png', 'B_Mezuzah'),
    Blessing("Blessings_for_Travelers", "B_PDF_Travelers",
        'assets/fondo_bendiciones.png', 'B_Travel'),
  ];

  var blessingsFood = [
    Blessing("Blessing_When_Washing_Hands", "B_PDF_Washing_Hand",
        'assets/fondo_bendiciones.png', "Before_Eating"),
    Blessing("Wine", "B_PDF_Wine", 'assets/fondo_bendiciones.png', 'B_Wine'),
    Blessing("Blessing_When_Eating_Bread", "B_PDF_Bread",
        'assets/fondo_bendiciones.png', 'B_Bread'),
    Blessing("Blessing_Over_Grains", "B_PDF_Grains",
        'assets/fondo_bendiciones.png', 'Grains'),
    Blessing("Blessing_Over_Vegetables", "B_PDF_Vegetables",
        'assets/fondo_bendiciones.png', 'Vegetables'),
    Blessing("Blessing_When_Eating_Fruits", "B_PDF_Fruits",
        'assets/fondo_bendiciones.png', 'Fruits'),
    Blessing("All_Other_Food", "B_PDF_All_Other_Food",
        'assets/fondo_bendiciones.png', 'B_All_Other_Food'),
    Blessing("Blessing_After_Meal", "B_PDF_After_Meal",
        'assets/fondo_bendiciones.png', 'Birkat_Hamazon'),
    Blessing("Making_Challa", "B_PDF_Challa", 'assets/fondo_bendiciones.png',
        'Challa'),
  ];

  var blessingsShabbat = [
    Blessing("Blessing_Of_The_Shabbath_Candles", "B_PDF_Shabbath_Blessing",
        'assets/fondo_bendiciones.png', 'The_Candles'),
    Blessing("Kidush_Shabbath", "B_PDF_Kidush_Shabbath",
        'assets/fondo_bendiciones.png', 'Kidush'),
    Blessing("Blessing_Havdalah", "B_PDF_Havdalah",
        'assets/fondo_bendiciones.png', 'Havdalah'),
  ];

  var blessingsFestivites = [
    Blessing("Blessing_Over_Hanukkah_Candles", "B_PDF_Hanukkah_Candles",
        'assets/fondo_bendiciones.png', 'Hanukka'),
    Blessing(
        "Blessing_Over_Festivities_Candles",
        "B_PDF_Over_Festivities_Candles",
        'assets/fondo_bendiciones.png',
        'Yom_Tov'),
    Blessing("Blessings_For_Sukkot", "B_PDF_Sukkot",
        'assets/fondo_bendiciones.png', 'Sukkot'),
    Blessing("Kidush_For_Shalosh_Regalim", "B_PDF_Shalosh_Regalim",
        'assets/fondo_bendiciones.png', 'Yom_Tov'),
    Blessing("Kidush_For_Rosh_Hashanah", "B_PDF_Kidush_Rosh_Hashanah",
        'assets/fondo_bendiciones.png', 'Rosh_Hashanah'),
    Blessing("Blessing_Over_Yom_Kippur_Candles", "B_PDF_Yom_Kippur_Candles",
        'assets/fondo_bendiciones.png', 'Yom_Kipur'),
  ];

  var blessingsMiscellaneous = [
    Blessing("Blessing_When_Hear_Thunder", "B_PDF_Thunder",
        'assets/fondo_bendiciones.png', 'Nature'),
    Blessing("Blessing_When_See_Lightning", "B_PDF_Lightning",
        'assets/fondo_bendiciones.png', 'Nature'),
    Blessing("Blessing_When_see_a_Rainbow", "B_PDF_Rainbow",
        'assets/fondo_bendiciones.png', 'Nature'),
    Blessing("Blessing_When_Hear_Good_News", "B_PDF_Good_News",
        'assets/fondo_bendiciones.png', 'Personnel'),
    Blessing("Blessing_When_Hear_Bad_News", "B_PDF_Bad_news",
        'assets/fondo_bendiciones.png', 'Personnel'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: [
          Locale('en', 'US'),
          Locale('es', 'ES'),
        ],
        localizationsDelegates: [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          if ('es' == deviceLocale.languageCode) {
            return deviceLocale;
          }
          return supportedLocales.first;
        },

        home: Builder(
          builder: (context) =>
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(500, 254, 140, 46),
                        Color.fromARGB(500, 254, 140, 46),
                        Color.fromARGB(500, 253, 200, 11),
                        Color.fromARGB(500, 254, 140, 46),
                      ],
                    ),
                  ),
                  child: OrientationBuilder(
                    builder: (context, orientation) {
//********************** Method to define type of screen ***************
                      gridLayoutHelper.calculatelayout(context, orientation);

                      return SafeArea(
                        child: CustomScrollView(
                          scrollDirection: Axis.vertical,
                          slivers: <Widget>[
                            SliverAppBar(
                              title: MyAppBar(),
                              floating: false,
                              pinned: true,
                              expandedHeight: gridLayoutHelper.needsLargeAppBar
                                  ? 190.0
                                  : 200.0,
// *************** color del encabezado cerrado **************
                              backgroundColor: Color.fromARGB(500, 181, 150, 5),
                              flexibleSpace: FlexibleSpaceBar(
                                background: HeaderIsHolliday(this.fileProvider),
                              ),
                            ),

//   este es el encabezado de la primera seccion  **************************
                            BlessingSectionHeader(Colors.amber[200],
                                getTranslated(context, 'Family')),

// lista de bendiciones de la primera seccion ******************************
                            SliverGrid.count(
                              childAspectRatio: gridLayoutHelper.aspectRatio,
                              crossAxisCount: gridLayoutHelper.numberOfCells,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                              children:
                              sectionCardWidgets(blessingsPDFs),
                            ),

//   este es el encabezado de la segunda  seccion  **************************
                            BlessingSectionHeader(
                                Colors.amber[200], getTranslated(context,
                                'Food')),

// lista de bendiciones de la segunda seccion ******************************
                            SliverGrid.count(
                              childAspectRatio: gridLayoutHelper.aspectRatio,
                              crossAxisCount: gridLayoutHelper.numberOfCells,
                              mainAxisSpacing: 0,
                              crossAxisSpacing: 0,
                              children:
                              sectionCardWidgets(blessingsFood),
                            ),
//   este es el encabezado de la tercera  seccion  **************************
                            BlessingSectionHeader(Colors.amber[200],
                                getTranslated(context, 'Sabbath')),

// lista de bendiciones de la segunda seccion ******************************
                            SliverGrid.count(
                              childAspectRatio: gridLayoutHelper.aspectRatio,
                              crossAxisCount: gridLayoutHelper.numberOfCells,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                              children: sectionCardWidgets(
                                  blessingsShabbat),
                            ),
//   este es el encabezado de la cuarta  seccion  **************************
                            BlessingSectionHeader(Colors.amber[200],
                                getTranslated(context, 'Festivities')),

// lista de bendiciones de la quinta seccion ******************************
                            SliverGrid.count(
                              childAspectRatio: gridLayoutHelper.aspectRatio,
                              crossAxisCount: gridLayoutHelper.numberOfCells,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                              children: sectionCardWidgets(
                                  blessingsFestivites),
                            ),
//   este es el encabezado de la quinta  seccion  **************************
                            BlessingSectionHeader(Colors.amber[200],
                                getTranslated(context, 'Miscellaneous')),

// lista de bendiciones de la sexta seccion ******************************
                            SliverGrid.count(
                              childAspectRatio: gridLayoutHelper.aspectRatio,
                              crossAxisCount: gridLayoutHelper.numberOfCells,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                              children: sectionCardWidgets(
                                  blessingsMiscellaneous),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
        ));
  }

  void definaLargeParams(BuildContext context, Orientation orientation) {
//    print(' DEBUG SAMI ANCHO ' + MediaQuery.of(context).size.width.toString());

    if (MediaQuery
        .of(context)
        .size
        .width > 790) {
      isLargeScreen = true;
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp
      ]);
    } else {
      isLargeScreen = false;
      // SystemChrome.setPreferredOrientations([
      //   // DeviceOrientation.landscapeLeft,
      //   // DeviceOrientation.landscapeRight,
      //   DeviceOrientation.portraitUp
      // ]);
    }
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    widecount = (screenWidth / 130).floor();
    aspectRatio = ((screenWidth / widecount) - 3) / 141;

    if (isLargeScreen) {
      if (orientation == Orientation.portrait) {
        isLargeScreenPortrait = true;
        phoneTypePoss = 'LP';
        // aspectRatio = 127/141;
      } else {
        isLargeScreenPortrait = false;
        phoneTypePoss = 'LL';
        // aspectRatio = 127/141;
      }
    } else {
      phoneTypePoss = 'NL';
      // aspectRatio = 127/141;
    }
  }

// TODO la idea es crear un metodo por seccion y carge el grid con sus contenido
  List<Widget> sectionCardWidgets(List<Blessing> blessings) {
    return List.generate(blessings.length, (index) {
      return CardLoad(
        fileProvider: fileProvider,
        gridLayoutHelper: gridLayoutHelper,
        blessing: blessings[index],
      );
    });
  }

  // ***************  get geoposition ********************
  Future<Point> _getCurrentlocation() async {
    var completer = Completer<Point>();

    Point point;
    try {
      final Position position =
      await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude;
      long = position.longitude;
      point = Point(position.latitude, position.longitude);

      // print("ANDRES 1  " + position.toString());
      // print("ANDRES 1.5  latitud $lat   longitud  $long");
    } on Exception catch (e) {
      lat = 0;
      long = 0;
//      print('[DEBUG] falla de geolocation ' + e.toString());
      point = Point(0.0, 0.0);
//      print("[ANDRES] no authorization granted to obtain the position ");
    }

    completer.complete(point);

    return completer.future;
    //_getSunriseSunset();
  }

// ***************  get sunrise & sunset ********************
  Future<SunriseSunsetData> _getSunriseSunset(Point point) async {
//    print('[DEBUG] LATITUD $lat  and LONGITUD $long');

    var completer = Completer<SunriseSunsetData>();
    try {
      final response = await SunriseSunset.getResults(

// ******** el parametro DateTime se utiliza solo para testear la app,
// una vez en produccion, se debe eliminar

          latitude: point.x,
          longitude: point.y);

      if (response.success) {
        completer.complete(response.data);
      } else {
        print(response.error);
      }
    } catch (err) {
      print("Failed to get data.");
      print(err);
    }

    return completer.future;
  }
}