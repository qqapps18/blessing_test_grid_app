import 'dart:async';

import 'dart:math';
import 'package:blessingtestgridapp/BlessingSectionHeader.dart';
import 'package:blessingtestgridapp/FestivitiesBlessing.dart';
import 'package:blessingtestgridapp/FoodBlessing.dart';
import 'package:blessingtestgridapp/MiscellaneousBlessing.dart';
import 'package:blessingtestgridapp/ShabbatBlesing.dart';
import 'package:blessingtestgridapp/localization/App_Localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Blessing.dart';
import 'FileProvider.dart';
import 'BlessingSectionHeader.dart';
import 'TheFlexiableAppBar.dart';
import 'localization/localization_constants.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sunrise_sunset/sunrise_sunset.dart';

import 'myappbar.dart';
import 'HeaderIsHolliday.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/services.dart';

import 'BlessingApp.dart';

// // *********************** SplashScreen **************************
//
// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     supportedLocales: [
//       Locale('en', 'US'),
//       Locale('es', 'ES'),
//     ],
//     localizationsDelegates: [
//       AppLocalization.delegate,
//       GlobalMaterialLocalizations.delegate,
//       GlobalWidgetsLocalizations.delegate,
//       GlobalCupertinoLocalizations.delegate,
//     ],
//     localeResolutionCallback: (deviceLocale, supportedLocales) {
//       if ('es' == deviceLocale.languageCode) {
//         return deviceLocale;
//       }
//       return supportedLocales.first;
//     },
//     home: SplashScreenLoad(),
//   ));
// }
//
// class SplashScreenLoad extends StatefulWidget {
//   @override
//   _SplashScreenLoadState createState() => _SplashScreenLoadState();
// }
//
// class _SplashScreenLoadState extends State<SplashScreenLoad> {
//   @override
//   Widget build(BuildContext context) {
//     return SplashScreen(
//       seconds: 2,
//     backgroundColor: Colors.amber,
//     image: Image.asset('assets/splashlogo.gif'),
//       loadingText: Text(
//         getTranslated(context, 'Book_Of_Blessings'),
//         style: TextStyle(
//           color: Colors.blueGrey,
//           fontFamily: 'RobotoSlab',
//           fontWeight: FontWeight.bold,
//           fontSize: 22.0,
//         ),
//       ),
//       loaderColor: Color.fromARGB(500, 13, 17, 50),
//       photoSize: 150,
//       navigateAfterSeconds: BlessingGridView(),
//     );
//   }
// }
//
// //**************** hasta aqui el SplashScreen ********************

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
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
  var headerIsHolliday = HeaderIsHolliday();

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

  @override
  void initState() {
    print('++++++++++++++++++  initstate ++++++++++++++++++++');
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
    FoodBlessing("Blessing_When_Washing_Hands", "B_PDF_Washing_Hand",
        'assets/fondo_bendiciones.png', "Before_Eating"),
    FoodBlessing(
        "Wine", "B_PDF_Wine", 'assets/fondo_bendiciones.png', 'B_Wine'),
    FoodBlessing("Blessing_When_Eating_Bread", "B_PDF_Bread",
        'assets/fondo_bendiciones.png', 'B_Bread'),
    FoodBlessing("Blessing_Over_Grains", "B_PDF_Grains",
        'assets/fondo_bendiciones.png', 'Grains'),
    FoodBlessing("Blessing_Over_Vegetables", "B_PDF_Vegetables",
        'assets/fondo_bendiciones.png', 'Vegetables'),
    FoodBlessing("Blessing_When_Eating_Fruits", "B_PDF_Fruits",
        'assets/fondo_bendiciones.png', 'Fruits'),
    FoodBlessing("All_Other_Food", "B_PDF_All_Other_Food",
        'assets/fondo_bendiciones.png', 'B_All_Other_Food'),
    FoodBlessing("Blessing_After_Meal", "B_PDF_After_Meal",
        'assets/fondo_bendiciones.png', 'Birkat_Hamazon'),
    FoodBlessing("Making_Challa", "B_PDF_Challa",
        'assets/fondo_bendiciones.png', 'Challa'),
  ];

  var blessingsShabbat = [
    ShabbatBlessing(
        "Blessing_Of_The_Shabbath_Candles",
        "B_PDF_Shabbath_Blessing",
        'assets/fondo_bendiciones.png',
        'The_Candles'),
    ShabbatBlessing("Kidush_Shabbath", "B_PDF_Kidush_Shabbath",
        'assets/fondo_bendiciones.png', 'Kidush'),
    ShabbatBlessing("Blessing_Havdalah", "B_PDF_Havdalah",
        'assets/fondo_bendiciones.png', 'Havdalah'),
  ];

  var blessingsFestivites = [
    FestivitiesBlessing("Blessing_Over_Hanukkah_Candles",
        "B_PDF_Hanukkah_Candles", 'assets/fondo_bendiciones.png', 'Hanukka'),
    FestivitiesBlessing(
        "Blessing_Over_Festivities_Candles",
        "B_PDF_Over_Festivities_Candles",
        'assets/fondo_bendiciones.png',
        'Yom_Tov'),
    FestivitiesBlessing("Blessings_For_Sukkot", "B_PDF_Sukkot",
        'assets/fondo_bendiciones.png', 'Sukkot'),
    FestivitiesBlessing("Kidush_For_Shalosh_Regalim", "B_PDF_Shalosh_Regalim",
        'assets/fondo_bendiciones.png', 'Yom_Tov'),
    FestivitiesBlessing("Kidush_For_Rosh_Hashanah", "B_PDF_Kidush_Rosh_Hashanah",
        'assets/fondo_bendiciones.png', 'Rosh_Hashanah'),
    FestivitiesBlessing(
        "Blessing_Over_Yom_Kippur_Candles",
        "B_PDF_Yom_Kippur_Candles",
        'assets/fondo_bendiciones.png',
        'Yom_Kipur'),
  ];

  var blessingsMiscellaneous = [
    MiscellaneousBlessing("Blessing_When_Hear_Thunder", "B_PDF_Thunder",
        'assets/fondo_bendiciones.png', 'Nature'),
    MiscellaneousBlessing("Blessing_When_See_Lightning", "B_PDF_Lightning",
        'assets/fondo_bendiciones.png', 'Nature'),
    MiscellaneousBlessing("Blessing_When_see_a_Rainbow", "B_PDF_Rainbow",
        'assets/fondo_bendiciones.png', 'Nature'),
    MiscellaneousBlessing("Blessing_When_Hear_Good_News", "B_PDF_Good_News",
        'assets/fondo_bendiciones.png', 'Personnel'),
    MiscellaneousBlessing("Blessing_When_Hear_Bad_News", "B_PDF_Bad_news",
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
          builder: (context) => Scaffold(
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
                  return SafeArea(
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          title: MyAppBar(),
                          floating: false,
                          pinned: true,
                          expandedHeight: 180.0,
// *************** color del encabezado cerrado **************
                          backgroundColor: Color.fromARGB(500, 181, 150, 5),
                          flexibleSpace: FlexibleSpaceBar(
                            background: HeaderIsHolliday(),
                          ),
                        ),

//   este es el encabezado de la primera seccion  **************************
                        BlessingSectionHeader(Colors.amber[200],
                            getTranslated(context, 'Family')),

// lista de bendiciones de la primera seccion ******************************
                        SliverGrid.count(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 3 : 5,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          children: BlessingsFiles(context),
                        ),

//   este es el encabezado de la segunda  seccion  **************************
                        BlessingSectionHeader(
                            Colors.amber[200], getTranslated(context, 'Food')),

// lista de bendiciones de la segunda seccion ******************************
                        SliverGrid.count(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 3 : 5,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          children: BlessingsFood(context),
                        ),
//   este es el encabezado de la tercera  seccion  **************************
                        BlessingSectionHeader(Colors.amber[200],
                            getTranslated(context, 'Sabbath')),

// lista de bendiciones de la segunda seccion ******************************
                        SliverGrid.count(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 3 : 5,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          children: BlessingsShabbat(context),
                        ),
//   este es el encabezado de la cuarta  seccion  **************************
                        BlessingSectionHeader(Colors.amber[200],
                            getTranslated(context, 'Festivities')),

// lista de bendiciones de la quinta seccion ******************************
                        SliverGrid.count(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 3 : 5,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          children: BlessingsFestivities(context),
                        ),
//   este es el encabezado de la quinta  seccion  **************************
                        BlessingSectionHeader(Colors.amber[200],
                            getTranslated(context, 'Miscellaneous')),

// lista de bendiciones de la sexta seccion ******************************
                        SliverGrid.count(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 3 : 5,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          children: BlessingsMiscellaneous(context),
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

// TODO la idea es crear un metodo por seccion y carge el grid con sus contenido

  List<Widget> BlessingsFiles(BuildContext context) {
    return List.generate(blessingsPDFs.length, (index) {
      return cardView(context, index);
    });
  }

  List<Widget> BlessingsFood(BuildContext context) {
    return List.generate(blessingsFood.length, (index) {
      return cardViewF(context, index);
    });
  }

  List<Widget> BlessingsShabbat(BuildContext context) {
    return List.generate(blessingsShabbat.length, (index) {
      return cardViewS(context, index);
    });
  }

  List<Widget> BlessingsFestivities(BuildContext context) {
    return List.generate(blessingsFestivites.length, (index) {
      return cardViewFes(context, index);
    });
  }

  List<Widget> BlessingsMiscellaneous(BuildContext context) {
    return List.generate(blessingsMiscellaneous.length, (index) {
      return cardViewMis(context, index);
    });
  }

  // Este metodo crea el 'CardView' en base a la información del objeto
  // 'Blessing' que creamos en la lista. Este objeto se consigue en base
  // al indice que nos pasa el metodo al crear el GridCount.
  // Para mas información: https://flutter.dev/docs/cookbook/lists/grid-lists
  Widget cardView(BuildContext context, int index) {
    // Este es el rezo y en el metodode abajo vamos a utilizar la información
    // para customizar el 'CardView'.

    var blessing = blessingsPDFs[index];

    return CardLoad(fileProvider: fileProvider, blessing: blessing);
  }

  Widget cardViewF(BuildContext context, int index) {
    // Este es el rezo y en el metodode abajo vamos a utilizar la información
    // para customizar el 'CardView'. 0

    var blessingF = blessingsFood[index];

    return CardLoadF(fileProvider: fileProvider, blessingF: blessingF);
  }

  Widget cardViewS(BuildContext context, int index) {
    // Este es el rezo y en el metodode abajo vamos a utilizar la información
    // para customizar el 'CardView'.

    var blessingS = blessingsShabbat[index];

    return CardLoadS(fileProvider: fileProvider, blessingS: blessingS);
  }

  Widget cardViewFes(BuildContext context, int index) {
    // Este es el rezo y en el metodode abajo vamos a utilizar la información
    // para customizar el 'CardView'.

    var blessibgFe = blessingsFestivites[index];

    return CardLoadFes(fileProvider: fileProvider, blessibgFe: blessibgFe);
  }

  Widget cardViewMis(BuildContext context, int index) {
    // Este es el rezo y en el metodode abajo vamos a utilizar la información
    // para customizar el 'CardView'.

    var blessibgMis = blessingsMiscellaneous[index];

    return CardLoadM(fileProvider: fileProvider, blessibgMis: blessibgMis);
  }

//  void checkHoliday(SunriseSunsetData data) {
//    print('CheckHoliday holidayline1 ' + holidayline1 + '===========');
//
//    // variables para el calculo del sunrise y sunset
//    // daylight - hora local del amanecer en el meridiano 0
//    // nighlight - hora local del atardecer en el meridiano 0
//    // offsetInHours - horas de diferencia con el meridiano 0
//    //                 que se sumaran para obtener la hora local correcta
//    // sunriseTime - hora local del amanecer
//    // sunsetTime - hora local del atardecer
//    // now - la hora actual
//
//    var daylight = data.civilTwilightBegin;
//    var nighlight = data.civilTwilightEnd;
//    var offsetInHours = DateTime.now().timeZoneOffset;
//    var sunriseTime = daylight.add(offsetInHours);
//    var sunsetTime = nighlight.add(offsetInHours);
//    var dateUTC = date.add(offsetInHours);
////    var now = DateTime.now();
//    print("Daylight " + daylight.toString());
//    print("Offset GMT " + offsetInHours.toString());
//    print("===== SUNRISE " + sunriseTime.toString());
//    print(' estoy en checkholiday **********************');
//
//    switch (fileProvider.jodesh) {
//      case "Elul":
//        checkRoshHashana(date, sunsetTime);
//        break;
//
//      case "Tishrei":
//        checkRoshHashana(date, sunsetTime);
//        checkTzomGedalia(date, sunriseTime, sunsetTime);
//        checkYomKipur(date, sunriseTime, sunsetTime);
//        checksukkot(date, sunsetTime);
//        break;
//
//      case "Tevet":
//        checkJanuca(date, sunsetTime);
//        check10Tevet(date, sunriseTime, sunsetTime);
//        break;
//
//      case "Kislev":
//        checkJanuca(date, sunsetTime);
//        break;
//
//      case "Shvat":
//        checkTuBishvat();
//        break;
//
//      case "Adar I":
//        checkPurim(date, sunriseTime, sunsetTime);
//        break;
//
//      case "Adar II":
//        checkPurim(date, sunriseTime, sunsetTime);
//        break;
//
//      case "Adar":
//        checkPurim(date, sunriseTime, sunsetTime);
//        break;
//
//      case "Nissan":
//        checkPassover(date, sunsetTime);
//        checkOmer(date, sunsetTime);
//        break;
//
//      case "Iyar":
//        checkOmer(date, sunsetTime);
//        break;
//
//      case "Sivan":
//        checkOmer(date, sunsetTime);
//        checkShavuot(date, sunsetTime);
//        break;
//
//      case "Tamuz":
//        check17Tamuz(date, sunriseTime, sunsetTime);
//        break;
//
//      case "Av":
//        check9Beav(date, sunsetTime);
//        break;
//    }
//
//    // checkRoshHashana(date, sunsetTime);
//    // checkTzomGedalia(date, sunriseTime, sunsetTime);
//    // checkYomKipur(date, sunriseTime, sunsetTime);
//    // checksukkot(date, sunsetTime);
//    // checkJanuca(date, sunsetTime);
//    // check10Tevet(date, sunriseTime, sunsetTime);
//    // checkTuBishvat();
//    // checkPurim(date, sunriseTime, sunsetTime);
//    // checkPassover(date, sunsetTime);
//    // checkOmer(date, sunsetTime);
//    // checkShavuot(date, sunsetTime);
//    // check17Tamuz(date, sunriseTime, sunsetTime);
//    // check9Beav(date, sunsetTime);
//    swfestivity = false;
//    swtzom = false;
//  }

// ++++++++++++++++ check for Rosh Hashana **************************
//  void checkRoshHashana(DateTime now, DateTime sunset) {
//    print('[DEBUG] estoy en checkRoshHashana **********************');
//    print('[DEBUG] mes ' + fileProvider.jodesh);
//    print('[DEBUG] dia ' + fileProvider.yom.toString());
//    print('[DEBUG] año ' + fileProvider.shana.toString());
//    print('[DEBUG] leapyear ' + fileProvider.isleapyear.toString());
//    print('[DEBUG] dia de la semana ' + dayofweek.toString());
//
//    // aqui chequeo la fecha para ver si es año nuevo ***************
//    if (fileProvider.jodesh == "Elul") {
//      if (fileProvider.yom == 29 && now.isAfter(sunset)) {
//        swfestivity = true;
//        headerIsHolliday.updateHoliday('assets/roshhashana.png', 'hemptytxt',
//            'shana_tova', 'hemptytxt ', swfestivity, swtzom);
//      } else {
//        headerIsHolliday.updateHoliday('assets/maguendavidyellow.png',
//            'hemptytxt', 'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
//      }
//    }
//
//    if (fileProvider.jodesh == "Tishrei") {
//      if (fileProvider.yom == 1 ||
//          (fileProvider.yom == 2 && now.isBefore(sunset))) {
//        swfestivity = true;
//        headerIsHolliday.updateHoliday('assets/roshhashana.png', 'hemptytxt',
//            'shana_tova', 'hemptytxt', swfestivity, swtzom);
//      } else {
//        headerIsHolliday.updateHoliday('assets/maguendavidyellow.png',
//            'hemptytxt', 'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
//      }
//    }
//  }
//
////por default para Fluter el primer dia de la semana es el lunes
//// por lo que el sabado es el dia 6
//// ++++++++++++++++ check for Tzom Gedalia **************************
//
//  void checkTzomGedalia(DateTime now, DateTime sunrise, DateTime sunset) {
//    if (fileProvider.jodesh == "Tishrei") {
//      if (fileProvider.yom == 3 &&
//          (now.isAfter(sunrise) && now.isBefore(sunset))) {
//        if (dayofweek == 6) {
//          swtzom = true;
//          todayIsTzom('assets/emptyimage.png', 'tzomshabat1', 'tzomGedalia',
//              'tzomshabat2');
//        } else {
//          swtzom = true;
//          todayIsTzom('assets/emptyimage.png', 'hemptytxt', 'tzomGedalia',
//              'hemptytxt ');
//        }
//      }
//    }
//
//    if (fileProvider.jodesh == "Tishrei") {
//      if (fileProvider.yom == 4 &&
//          (now.isAfter(sunrise) && now.isBefore(sunset))) {
//        if (dayofweek == 7) {
//          swtzom = true;
//          todayIsTzom('assets/emptyimage.png', 'Yzomshabat1', 'tzomGedalia',
//              'Yzomshabat2 ');
//        } else {
//          headerIsHolliday.updateHoliday('assets/maguendavidyellow.png',
//              'hemptytxt', 'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
//        }
//      }
//    }
//  }
//
//// ++++++++++++++++ check for Yom Kipur **************************
//  void checkYomKipur(DateTime now, DateTime sunrise, DateTime sunset) {
//    if (fileProvider.jodesh == "Tishrei") {
//      if ((fileProvider.yom == 9 && now.isAfter(sunset)) ||
//          (fileProvider.yom == 10 && now.isBefore(sunset))) {
//        swtzom = true;
//        todayIsTzom(
//            'assets/emptyimage.png', 'hemptytxt', 'yomkipur', 'hemptytxt');
//      } else {
//        headerIsHolliday.updateHoliday('assets/maguendavidyellow.png',
//            'hemptytxt', 'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
//      }
//    }
//  }
//
//// ++++++++++++++++ check for Sukkot **************************
//  void checksukkot(DateTime now, DateTime sunset) {
//    print('now ' +
//        now.millisecondsSinceEpoch.toString() +
//        ' sunset ' +
//        sunset.millisecondsSinceEpoch.toString());
//
//    if (fileProvider.jodesh == "Tishrei") {
//      if ((fileProvider.yom == 14 &&
//              now.millisecondsSinceEpoch > sunset.millisecondsSinceEpoch) ||
//          (fileProvider.yom > 14 && fileProvider.yom < 20) ||
//          (fileProvider.yom == 20 && now.isBefore(sunset))) {
//        swfestivity = true;
//        headerIsHolliday.updateHoliday('assets/sukkot.png', 'hemptytxt', 'sukkot',
//            'hemptytxt', swfestivity, swtzom);
//      } else {
//        if ((fileProvider.yom == 20 && now.isAfter(sunset)) ||
//            (fileProvider.yom == 21 && now.isBefore(sunset))) {
//          swfestivity = true;
//          headerIsHolliday.updateHoliday('assets/sukkot.png', 'hemptytxt',
//              'hoshanaraba', 'hemptytxt', swfestivity, swtzom);
//        } else {
//          if ((fileProvider.yom == 21 && now.isBefore(sunset)) ||
//              (fileProvider.yom == 22 && now.isAfter(sunset))) {
//            swfestivity = true;
//            headerIsHolliday.updateHoliday('assets/sukkot.png', 'hemptytxt',
//                'sheminiatzeret', 'hemptytxt', swfestivity, swtzom);
//          } else {
//            if ((fileProvider.yom == 22 && now.isBefore(sunset)) ||
//                (fileProvider.yom == 23 && now.isAfter(sunset))) {
//              swfestivity = true;
//              headerIsHolliday.updateHoliday('assets/sinchattorah.png', 'hemptytxt',
//                  'sinchattorah', 'hemptytxt', swfestivity, swtzom);
//            } else {
//              headerIsHolliday.updateHoliday('assets/maguendavidyellow.png',
//                  'hemptytxt', 'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
//            }
//          }
//        }
//      }
//    }
//  }
//
//  // ++++++++++++++++ check for Januca **************************
//
//  void checkJanuca(DateTime now, DateTime sunset) {
//    int endmonth = 0;
//
//    if (fileProvider.jodesh == "Tevet") {
//      if ((fileProvider.yom == 1 && fileProvider.yesterdayyom == 29) ||
//          (fileProvider.yom == 2 && fileProvider.daybeforeyom == 29)) {
//        endmonth = 1;
//      } else {
//        if ((fileProvider.yom == 1 && fileProvider.daybeforeyom == 30) ||
//            (fileProvider.yom == 2 && fileProvider.daybeforeyom == 30)) {
//          endmonth = 2;
//        }
//      }
//    }
//
//    if (fileProvider.jodesh == "Kislev") {
//      if ((fileProvider.yom == 24 && now.isAfter(sunset)) ||
//          (fileProvider.yom == 25 && now.isBefore(sunset))) {
//        swfestivity = true;
//        headerIsHolliday.updateHoliday('assets/januquilladia1.png', 'hemptytxt',
//            'happyjanuca', 'hemptytxt', swfestivity, swtzom);
//      } else {
//        if ((fileProvider.yom == 24 && now.isAfter(sunset)) ||
//            (fileProvider.yom == 25 && now.isBefore(sunset))) {
//          swfestivity = true;
//          headerIsHolliday.updateHoliday('assets/januquilladia2.png', 'hemptytxt',
//              'happyjanuca', 'hemptytxt', swfestivity, swtzom);
//        } else {
//          if ((fileProvider.yom == 26 && now.isAfter(sunset)) ||
//              (fileProvider.yom == 27 && now.isBefore(sunset))) {
//            swfestivity = true;
//            headerIsHolliday.updateHoliday('assets/januquilladia3.png', 'hemptytxt',
//                'happyjanuca', 'hemptytxt', swfestivity, swtzom);
//          } else {
//            if ((fileProvider.yom == 27 && now.isAfter(sunset)) ||
//                (fileProvider.yom == 28 && now.isBefore(sunset))) {
//              swfestivity = true;
//              headerIsHolliday.updateHoliday('assets/januquilladia4.png',
//                  'hemptytxt', 'happyjanuca', 'hemptytxt', swfestivity, swtzom);
//            } else {
//              if ((fileProvider.yom == 28 && now.isAfter(sunset)) ||
//                  (fileProvider.yom == 29 && now.isBefore(sunset))) {
//                swfestivity = true;
//                headerIsHolliday.updateHoliday(
//                    'assets/januquilladia5.png',
//                    'hemptytxt',
//                    'happyjanuca',
//                    'hemptytxt',
//                    swfestivity,
//                    swtzom);
//              } else {
//                if ((fileProvider.yom == 29 && now.isAfter(sunset)) ||
//                    (fileProvider.yom == 30 && now.isBefore(sunset))) {
//                  swfestivity = true;
//                  headerIsHolliday.updateHoliday(
//                      'assets/januquilladia6.png',
//                      'hemptytxt',
//                      'happyjanuca',
//                      'hemptytxt',
//                      swfestivity,
//                      swtzom);
//                } else {
//                  if (fileProvider.yom == 30 && now.isAfter(sunset)) {
//                    swfestivity = true;
//                    headerIsHolliday.updateHoliday(
//                        'assets/januquilladia7.png',
//                        'hemptytxt',
//                        'happyjanuca',
//                        'hemptytxt',
//                        swfestivity,
//                        swtzom);
//                  }
//                }
//              }
//            }
//          }
//        }
//      }
//    }
//
//    if (fileProvider.jodesh == "Tevet") {
//      if (fileProvider.yom == 1 && endmonth == 1 && now.isBefore(sunset)) {
//        swfestivity = true;
//        headerIsHolliday.updateHoliday('assets/januquilladia6.png', 'hemptytxt',
//            'happyjanuca', 'hemptytxt', swfestivity, swtzom);
//      } else {
//        if ((fileProvider.yom == 1 && endmonth == 1 && now.isAfter(sunset)) ||
//            (fileProvider.yom == 2 && endmonth == 1 && now.isBefore(sunset))) {
//          swfestivity = true;
//          headerIsHolliday.updateHoliday('assets/januquilladia7.png', 'hemptytxt',
//              'happyjanuca', 'hemptytxt', swfestivity, swtzom);
//        } else {
//          if ((fileProvider.yom == 2 && endmonth == 1 && now.isAfter(sunset)) ||
//              (fileProvider.yom == 3 &&
//                  endmonth == 1 &&
//                  now.isBefore(sunset))) {
//            swfestivity = true;
//            headerIsHolliday.updateHoliday('assets/januquillacompleta.png',
//                'hemptytxt', 'happyjanuca', 'hemptytxt', swfestivity, swtzom);
//          } else {
//            if (fileProvider.yom == 1 && endmonth == 2 && now.isAfter(sunset)) {
//              swfestivity = true;
//              headerIsHolliday.updateHoliday('assets/januquilladia7.png',
//                  'hemptytxt', 'happyjanuca', 'hemptytxt', swfestivity, swtzom);
//            } else {
//              if ((fileProvider.yom == 1 &&
//                      endmonth == 2 &&
//                      now.isAfter(sunset)) ||
//                  (fileProvider.yom == 2 &&
//                      endmonth == 2 &&
//                      now.isBefore(sunset))) {
//                swfestivity = true;
//                headerIsHolliday.updateHoliday(
//                    'assets/januquillacompleta.png',
//                    'hemptytxt',
//                    'happyjanuca',
//                    'hemptytxt',
//                    swfestivity,
//                    swtzom);
//              } else {
//                headerIsHolliday.updateHoliday('assets/maguendavidyellow.png',
//                    'hemptytxt', 'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
//              }
//            }
//          }
//        }
//      }
//    }
//  }
//
////por default para Fluter el primer dia de la semana es el lunes
//// por lo que el sabado es el dia 6
//// ++++++++++++++++ check for Tzom 10 of TEVET **************************
//
//  void check10Tevet(DateTime now, DateTime sunrise, DateTime sunset) {
//    if (fileProvider.jodesh == "Tevet") {
//      if (fileProvider.yom == 10 &&
//          (now.isAfter(sunrise) && now.isBefore(sunset))) {
//        if (dayofweek == 6) {
//          swtzom = true;
//          todayIsTzom('assets/emptyimage.png', 'tzomshabat1', 'tzom10Tevet',
//              'tzomshabat2');
//        } else {
//          swtzom = true;
//          todayIsTzom('assets/emptyimage.png', 'hemptytxt', 'tzom10Tevet',
//              'hemptytxt ');
//        }
//      }
//    }
//
//    if (fileProvider.jodesh == "Tevet") {
//      if (fileProvider.yom == 11 &&
//          (now.isAfter(sunrise) && now.isBefore(sunset))) {
//        if (dayofweek == 7) {
//          swtzom = true;
//          todayIsTzom('assets/emptyimage.png', 'Yzomshabat1', 'tzom10Tevet',
//              'Yzomshabat2 ');
//        } else {
//          headerIsHolliday.updateHoliday('assets/maguendavidyellow.png',
//              'hemptytxt', 'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
//        }
//      }
//    }
//  }
//
//  // ++++++++++++++++ check for Tu Bishvat **************************
//
//  void checkTuBishvat() {
//    if (fileProvider.jodesh == "Shvat") {
//      if (fileProvider.yom == 15) {
//        swfestivity = true;
//        headerIsHolliday.updateHoliday('assets/tubishvat.png', 'hemptytxt',
//            'tubishvat', 'hemptytxt', swfestivity, swtzom);
//      } else {
//        headerIsHolliday.updateHoliday('assets/maguendavidyellow.png',
//            'hemptytxt', 'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
//      }
//    }
//  }
//
//  // *************** Check for Purim ++++++++++++++++++++++++++++++++
//
//  void checkPurim(DateTime now, DateTime sunrise, DateTime sunset) {
//    print("[PURIM]  istzomesther entrando " + istzomesther.toString());
//
//    if (fileProvider.isleapyear) {
//      if (fileProvider.jodesh == "Adar I") {
//        if (fileProvider.yom == 14) {
//          swfestivity = true;
//          headerIsHolliday.updateHoliday('assets/tpurimkatan.png', 'hemptytxt',
//              'purimkatan', 'hemptytxt', swfestivity, swtzom);
//        } else {
//          if (fileProvider.yom == 15) {
//            swfestivity = true;
//            headerIsHolliday.updateHoliday('assets/purimkatan.png', 'hemptytxt',
//                'sushanpurimkatan', 'hemptytxt', swfestivity, swtzom);
//          } else {
//            headerIsHolliday.updateHoliday('assets/maguendavidyellow.png',
//                'hemptytxt', 'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
//          }
//        }
//      }
//    }
//
//    if (fileProvider.isleapyear) {
//      if (fileProvider.jodesh == "Adar II") {
//        todayTzomEsther(now, sunrise, sunset);
//        print("[PURIM]  istzomesther regresando1 " + istzomesther.toString());
//
//        if (istzomesther == 0) {
//          if (fileProvider.yom == 13 &&
//              (now.isAfter(sunrise) && now.isBefore(sunset))) {
//            swtzom = true;
//            todayIsTzom('assets/emptyimage.png', 'hemptytxt', 'tzomEsther',
//                'hemptytxt');
//          } else {
//            if (fileProvider.yom == 14) {
//              swfestivity = true;
//              headerIsHolliday.updateHoliday('assets/purimnormal.png', 'hemptytxt',
//                  'purim', 'hemptytxt', swfestivity, swtzom);
//            } else {
//              if (fileProvider.yom == 15) {
//                swfestivity = true;
//                headerIsHolliday.updateHoliday(
//                    'assets/purimnormal.png',
//                    'hemptytxt',
//                    'sushanpurim',
//                    'hemptytxt',
//                    swfestivity,
//                    swtzom);
//              } else {
//                headerIsHolliday.updateHoliday('assets/maguendavidyellow.png',
//                    'hemptytxt', 'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
//              }
//            }
//          }
//        } else {
//          if (istzomesther == 1) {
//            if (fileProvider.yom == 13 &&
//                (now.isAfter(sunrise) && now.isBefore(sunset))) {
//              if (dayofweek == 6) {
//                swtzom = true;
//                todayIsTzom('assets/emptyimage.png', 'tzomshabat1',
//                    'tzomesthershabat', 'tzomesthershabatadarii');
//                istzomesther = 0;
//              }
//            }
//          }
//        }
//      }
//    }
//
//    if (!fileProvider.isleapyear) {
//      if (fileProvider.jodesh == "Adar") {
//        todayTzomEsther(now, sunrise, sunset);
//        print("[PURIM]  istzomesther regresando2 " + istzomesther.toString());
//
//        if (istzomesther == 0) {
//          if (fileProvider.yom == 13 &&
//              (now.isAfter(sunrise) && now.isBefore(sunset))) {
//            swtzom = true;
//            todayIsTzom('assets/emptyimage.png', 'hemptytxt', 'tzomEsther',
//                'hemptytxt');
//          } else {
//            if (fileProvider.yom == 14) {
//              swfestivity = true;
//              headerIsHolliday.updateHoliday('assets/purimnormal.png', 'hemptytxt',
//                  'purim', 'hemptytxt', swfestivity, swtzom);
//            } else {
//              if (fileProvider.yom == 15) {
//                swfestivity = true;
//                headerIsHolliday.updateHoliday(
//                    'assets/purimnormal.png',
//                    'hemptytxt',
//                    'sushanpurim',
//                    'hemptytxt',
//                    swfestivity,
//                    swtzom);
//              } else {
//                headerIsHolliday.updateHoliday('assets/maguendavidyellow.png',
//                    'hemptytxt', 'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
//              }
//            }
//          }
//        }
//        if (istzomesther == 1) {
//          if (fileProvider.yom == 13 &&
//              (now.isAfter(sunrise) && now.isBefore(sunset))) {
//            swtzom = true;
//            if (dayofweek == 6) {
//              todayIsTzom('assets/emptyimage.png', 'tzomshabat1',
//                  'tzomesthershabat', 'tzomesthershabatadar');
//            }
//          }
//        }
//      }
//    }
//  }
//
//  //++++++++++++++++++++++ check fot Tzom Esther +++++++++++++++++++++
//
//  void todayTzomEsther(DateTime now, DateTime sunrise, DateTime sunset) {
//    if (fileProvider.isleapyear) {
//      if (fileProvider.jodesh == "Adar II") {
//        if (fileProvider.yom == 11 &&
//            dayofweek == 4 &&
//            (now.isAfter(sunrise) && now.isBefore(sunset))) {
//          swtzom = true;
//          todayIsTzom('assets/emptyimage.png', 'tzomEsther',
//              'tzomestheron11adarii', 'hemptytxt');
//          istzomesther = 1;
//        } else {
//          if (fileProvider.yom == 13 &&
//              dayofweek == 7 &&
//              (now.isAfter(sunrise) && now.isBefore(sunset))) {
//            istzomesther = 1;
//          }
//        }
//      }
//    }
//
//    if (!fileProvider.isleapyear) {
//      if (fileProvider.jodesh == "Adar") {
//        if (fileProvider.yom == 11 &&
//            dayofweek == 4 &&
//            (now.isAfter(sunrise) && now.isBefore(sunset))) {
//          swtzom = true;
//          todayIsTzom('assets/emptyimage.png', 'tzomEsther',
//              'tzomestheron11adar', 'hemptytxt');
//          istzomesther = 1;
//        } else {
//          if (fileProvider.yom == 13 &&
//              dayofweek == 7 &&
//              (now.isAfter(sunrise) && now.isBefore(sunset))) {
//            istzomesther = 1;
//          }
//        }
//      }
//    }
//  }
//
//  //++++++++++++++++++++++ check for Passover +++++++++++++++++++++
//  void checkPassover(DateTime now, DateTime sunset) {
//    if (fileProvider.jodesh == "Nissan") {
//      if (fileProvider.yom == 14 && now.isAfter(sunset)) {
//        swfestivity = true;
//        headerIsHolliday.updateHoliday('assets/pesaj.png', 'hemptytxt',
//            'pesaje1seder', 'hemptytxt', swfestivity, swtzom);
//      } else {
//        if (fileProvider.yom == 15 && now.isBefore(sunset)) {
//          swfestivity = true;
//          headerIsHolliday.updateHoliday('assets/pesaj.png', 'hemptytxt', 'pesaj',
//              'hemptytxt', swfestivity, swtzom);
//        } else {
//          if (fileProvider.yom == 15 && now.isAfter(sunset)) {
//            swfestivity = true;
//            headerIsHolliday.updateHoliday('assets/pesaj.png', 'hemptytxt',
//                'pesaj2seder', 'hemptytxt', swfestivity, swtzom);
//          } else {
//            if (fileProvider.yom == 16 && now.isBefore(sunset)) {
//              swfestivity = true;
//              headerIsHolliday.updateHoliday('assets/pesaj.png', 'hemptytxt',
//                  'pesaj1omer', 'hemptytxt', swfestivity, swtzom);
//            } else {
//              if ((fileProvider.yom == 16 && now.isAfter(sunset)) ||
//                  (fileProvider.yom == 17 && now.isBefore(sunset))) {
//                swfestivity = true;
//                headerIsHolliday.updateHoliday('assets/pesaj.png', 'hemptytxt',
//                    'pesaj2omer', 'hemptytxt', swfestivity, swtzom);
//              } else {
//                if ((fileProvider.yom == 17 && now.isAfter(sunset)) ||
//                    (fileProvider.yom == 18 && now.isBefore(sunset))) {
//                  swfestivity = true;
//                  headerIsHolliday.updateHoliday('assets/pesaj.png', 'hemptytxt',
//                      'pesaj3omer', 'hemptytxt', swfestivity, swtzom);
//                } else {
//                  if ((fileProvider.yom == 18 && now.isAfter(sunset)) ||
//                      (fileProvider.yom == 19 && now.isBefore(sunset))) {
//                    swfestivity = true;
//                    headerIsHolliday.updateHoliday('assets/pesaj.png', 'hemptytxt',
//                        'pesaj4omer', 'hemptytxt', swfestivity, swtzom);
//                  } else {
//                    if ((fileProvider.yom == 19 && now.isAfter(sunset)) ||
//                        (fileProvider.yom == 20 && now.isBefore(sunset))) {
//                      swfestivity = true;
//                      headerIsHolliday.updateHoliday(
//                          'assets/pesaj.png',
//                          'hemptytxt',
//                          'pesaj5omer',
//                          'hemptytxt',
//                          swfestivity,
//                          swtzom);
//                    } else {
//                      if ((fileProvider.yom == 20 && now.isAfter(sunset)) ||
//                          (fileProvider.yom == 21 && now.isBefore(sunset))) {
//                        swfestivity = true;
//                        headerIsHolliday.updateHoliday(
//                            'assets/pesaj.png',
//                            'hemptytxt',
//                            'pesaj6omer',
//                            'hemptytxt',
//                            swfestivity,
//                            swtzom);
//                      } else {
//                        if ((fileProvider.yom == 21 && now.isAfter(sunset)) ||
//                            (fileProvider.yom == 22 && now.isBefore(sunset))) {
//                          swfestivity = true;
//                          headerIsHolliday.updateHoliday(
//                              'assets/pesaj.png',
//                              'hemptytxt',
//                              'pesaj7omer',
//                              'hemptytxt',
//                              swfestivity,
//                              swtzom);
//                        } else {
//                          if ((fileProvider.yom == 22 && now.isAfter(sunset)) ||
//                              (fileProvider.yom == 23 &&
//                                  now.isBefore(sunset))) {
//                            swfestivity = true;
//                            headerIsHolliday.updateHoliday(
//                                'assets/pesaj.png',
//                                'hemptytxt',
//                                'pesaj8omer',
//                                'hemptytxt',
//                                swfestivity,
//                                swtzom);
//                          }
//                        }
//                      }
//                    }
//                  }
//                }
//              }
//            }
//          }
//        }
//      }
//    }
//  }
//
////++++++++++++++++++++++ check for Omer +++++++++++++++++++++
//  void checkOmer(DateTime now, DateTime sunset) {
//    int omerday = 0;
//    if (fileProvider.jodesh == "Nissan") {
//      for (int day = 23; day < 31; day++) {
//        if (((fileProvider.yom == day && now.isAfter(sunset)) ||
//            (fileProvider.yom == (day + 1) && now.isBefore(sunset)))) {
//          swfestivity = true;
//          omerday = day - 14;
//          headerIsHolliday.updateHoliday(
//              'assets/emptyimage.png',
//              'hemptytxt',
//              ('omerday' + ' ' + omerday.toString()),
//              'hemptytxt',
//              swfestivity,
//              swtzom);
//        }
//      }
//    }
//
//    if (fileProvider.jodesh == "Iyar") {
//      if ((fileProvider.yom == 1 && now.isBefore(sunset))) {
//        swfestivity = true;
//        omerday = 16;
//        headerIsHolliday.updateHoliday(
//            'assets/emptyimage.png',
//            'hemptytxt',
//            ('omerday' + ' ' + omerday.toString()),
//            'hemptytxt',
//            swfestivity,
//            swtzom);
//      }
//    }
//
//    if (fileProvider.jodesh == "Iyar") {
//      for (int day = 1; day < 17; day++) {
//        if (((fileProvider.yom == day && now.isAfter(sunset)) ||
//            (fileProvider.yom == (day + 1) && now.isBefore(sunset)))) {
//          swfestivity = true;
//          omerday = day + 16;
//          headerIsHolliday.updateHoliday(
//              'assets/emptyimage.png',
//              'hemptytxt',
//              ('omerday' + ' ' + omerday.toString()),
//              'hemptytxt',
//              swfestivity,
//              swtzom);
//        }
//      }
//    }
//
//    if (fileProvider.jodesh == "Iyar") {
//      if (((fileProvider.yom == 17 && now.isAfter(sunset)) ||
//          (fileProvider.yom == 18 && now.isBefore(sunset)))) {
//        swfestivity = true;
//        headerIsHolliday.updateHoliday('assets/lagbaomer.png', 'hemptytxt',
//            'pesaj33omer', 'hemptytxt', swfestivity, swtzom);
//      }
//    }
//
//    if (fileProvider.jodesh == "Iyar") {
//      for (int day = 18; day < 30; day++) {
//        if (((fileProvider.yom == day && now.isAfter(sunset)) ||
//            (fileProvider.yom == (day + 1) && now.isBefore(sunset)))) {
//          swfestivity = true;
//          omerday = day + 16;
//          headerIsHolliday.updateHoliday(
//              'assets/emptyimage.png',
//              'hemptytxt',
//              ('omerday' + ' ' + omerday.toString()),
//              'hemptytxt',
//              swfestivity,
//              swtzom);
//        }
//      }
//    }
//
//    if (fileProvider.jodesh == "Sivan") {
//      if ((fileProvider.yom == 1 && now.isBefore(sunset))) {
//        swfestivity = true;
//        omerday = 45;
//        headerIsHolliday.updateHoliday(
//            'assets/emptyimage.png',
//            'hemptytxt',
//            ('omerday' + ' ' + omerday.toString()),
//            'hemptytxt',
//            swfestivity,
//            swtzom);
//      }
//    }
//
//    if (fileProvider.jodesh == "Sivan") {
//      for (int day = 1; day < 5; day++) {
//        if (((fileProvider.yom == day && now.isAfter(sunset)) ||
//            (fileProvider.yom == (day + 1) && now.isBefore(sunset)))) {
//          swfestivity = true;
//          omerday = day + 45;
//          headerIsHolliday.updateHoliday(
//              'assets/emptyimage.png',
//              'hemptytxt',
//              ('omerday' + ' ' + omerday.toString()),
//              'hemptytxt',
//              swfestivity,
//              swtzom);
//        }
//      }
//    }
//  }
//
////++++++++++++++++++++++ check for Shavuot +++++++++++++++++++++
//  void checkShavuot(DateTime now, DateTime sunset) {
//    if (fileProvider.jodesh == "Sivan") {
//      if ((fileProvider.yom == 5 && now.isAfter(sunset)) ||
//          (fileProvider.yom == 6 && now.isBefore(sunset))) {
//        swfestivity = true;
//        headerIsHolliday.updateHoliday('assets/shavuot.png', 'hemptytxt', 'shavuot',
//            'hemptytxt', swfestivity, swtzom);
//      }
//    }
//  }
//
//// ++++++++++++++++ check for fast of 17 of tamuz **************************
//  void check17Tamuz(DateTime now, DateTime sunrise, DateTime sunset) {
//    if (fileProvider.jodesh == "Tamuz") {
//      if (fileProvider.yom == 17 &&
//          (now.isAfter(sunrise) && now.isBefore(sunset))) {
//        if (dayofweek == 6) {
//          swtzom = true;
//          todayIsTzom('assets/emptyimage.png', 'tzomshabat1', 'tzom17tamuz',
//              'tzomshabat2');
//        } else {
//          swtzom = true;
//          todayIsTzom('assets/emptyimage.png', 'hemptytxt', 'tzom17tamuz',
//              'hemptytxt ');
//        }
//      }
//    }
//
//    if (fileProvider.jodesh == "Tamuz") {
//      if (fileProvider.yom == 18 &&
//          (now.isAfter(sunrise) && now.isBefore(sunset))) {
//        if (dayofweek == 7) {
//          swtzom = true;
//          todayIsTzom('assets/emptyimage.png', 'Yzomshabat1', 'tzom17tamuz',
//              'Yzomshabat2 ');
//        } else {
//          headerIsHolliday.updateHoliday('assets/maguendavidyellow.png',
//              'hemptytxt', 'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
//        }
//      }
//    }
//  }
//
//// ++++++++++++++++ check for fast of 9 of av **************************
//  void check9Beav(DateTime now, DateTime sunset) {
//    if (fileProvider.jodesh == "Av") {
//      if (fileProvider.yom == 8 && dayofweek == 5 && now.isAfter(sunset)) {
//        swtzom = true;
//        todayIsTzom('assets/emptyimage.png', 'tzomshabat1', 'tzom9beavshabat',
//            'tzomshabat2');
//      } else {
//        if (fileProvider.yom == 9 && dayofweek == 6 && now.isBefore(sunset)) {
//          swtzom = true;
//          todayIsTzom('assets/emptyimage.png', 'tzomshabat1', 'tzom9beavshabat',
//              'tzom9beavshabat2');
//        } else {
//          if ((fileProvider.yom == 9 &&
//                  dayofweek == 6 &&
//                  now.isAfter(sunset)) ||
//              (fileProvider.yom == 10 &&
//                  dayofweek == 7 &&
//                  now.isBefore(sunset))) {
//            swtzom = true;
//            todayIsTzom('assets/emptyimage.png', 'hemptytxt', 'tzom9Beav',
//                'hemptytxt ');
//          } else {
//            if ((fileProvider.yom == 8 &&
//                    dayofweek != 5 &&
//                    now.isAfter(sunset)) ||
//                (fileProvider.yom == 9 &&
//                    dayofweek != 6 &&
//                    now.isBefore(sunset))) {
//              swtzom = true;
//              todayIsTzom('assets/emptyimage.png', 'hemptytxt', 'tzom9Beav',
//                  'hemptytxt');
//            } else {
//              headerIsHolliday.updateHoliday('assets/maguendavidyellow.png',
//                  'hemptytxt', 'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
//            }
//          }
//        }
//      }
//    }
//  }
//
//  //++++++++++ metodo que maneja los dias de ayuno +++++++++++++++
//  void todayIsTzom(String himage, String hline1, hline2, hline3) {
//    print(' estoy todayIsTzom ' + himage + ' ' + hline2);
//
//    setState(() {
//      headerimage = himage;
////    holidayline1 = getTranslated(context, hline1);
////    holidayline2 = getTranslated(context, hline2);
////    holidayline3 = getTranslated(context, hline3);
//      holidayline1 = hline1;
//      holidayline2 = hline2;
//      holidayline3 = hline3;
//    });
//  }

  //++++++++++ metodo que maneja los dias fectivos +++++++++++++++
//   void headerIsHolliday.isHoliday(String himage, String hline1, hline2, hline3) {
//     print(' estoy headerIsHolliday.isHoliday ' + himage + ' ' + hline2);
//
//     setState(() {
//       headerimage = himage;
// //    holidayline1 = getTranslated(context, hline1);
// //    holidayline2 = getTranslated(context, hline2);
// //    holidayline3 = getTranslated(context, hline3);
//       holidayline1 = hline1;
//       holidayline2 = hline2;
//       holidayline3 = hline3;
//     });
//   }

  // //++++++++++ metodo que maneja los dias  NO fectivos +++++++++++++++
  // void todayIsNotHoliday() {
  //   print('swfestiviti xxxxxxxxxxxxx' + swfestivity.toString());
  //   print('swtzom xxxxxxxxxxxxxxxxxx' + swtzom.toString());
  //
  //   if (!swfestivity && !swtzom) {
  //     setState(() {
  //       headerImage = 'assets/maguendavidyellow.png';
  //       holidayline1 = ' ';
  //       holidayline2 = ' ';
  //       holidayline3 = ' ';
  //     });
  //   }
  // }

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

      print("ANDRES 1  " + position.toString());
      print("ANDRES 1.5  latitud $lat   longitud  $long");
    } on Exception catch (e) {
      lat = 0;
      long = 0;
      print('[DEBUG] falla de geolocation ' + e.toString());
      point = Point(0.0, 0.0);
      print("[ANDRES] no authorization granted to obtain the position ");
    }

    completer.complete(point);

    return completer.future;
    //_getSunriseSunset();
  }

// ***************  get sunrise & sunset ********************
  Future<SunriseSunsetData> _getSunriseSunset(Point point) async {
    print('[DEBUG] LATITUD $lat  and LONGITUD $long');

    var completer = Completer<SunriseSunsetData>();
    try {
      final response = await SunriseSunset.getResults(

// ******** el parametro DateTime se utiliza solo para testear la app,
// una vez en produccion, se debe eliminar

//          date: DateTime(2020, 09, 19, 22),
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

// class MyFlexiableAppBar extends StatelessWidget {
//   final double appBarHeight = 60.0;
//
//   final String datehebrew;
//   final String date;
//   final String headerimage;
//   final String holidayline1;
//   final String holidayline2;
//   final String holidayline3;
//
//   const MyFlexiableAppBar(this.date, this.datehebrew, this.headerimage,
//       this.holidayline1, this.holidayline2, this.holidayline3);
//
//   @override
//   Widget build(BuildContext context) {
//     final double statusBarHeight = MediaQuery.of(context).padding.top;
//
//     print(' estoy  en MyFlexiableAppBar ' + headerimage + ' ' + holidayline2);
//
//     return new Container(
//       padding: new EdgeInsets.only(top: statusBarHeight),
//       height: statusBarHeight + appBarHeight,
//       child: new Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           Container(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     child: Text('$holidayline1',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 20,
//                           fontFamily: 'RobotoSlab',
//                           fontWeight: FontWeight.bold,
//                         )),
//                   ),
//                   Container(
//                     child: new Text('$holidayline2',
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 20,
//                           fontFamily: 'RobotoSlab',
//                           fontWeight: FontWeight.bold,
//                         )),
//                   ),
//                   Container(
//                     child: new Text('$holidayline3',
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 20,
//                           fontFamily: 'RobotoSlab',
//                           fontWeight: FontWeight.bold,
//                         )),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Container(
//                     child: Padding(
//                       padding: EdgeInsets.only(bottom: 10.0),
//                       child: Text(date,
//                           style: TextStyle(
//                               color: Color.fromARGB(500, 13, 17, 50),
//                               fontFamily: 'RobotoSlab',
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.bold)),
//                     ),
//                   ),
//                   Container(
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 10.0),
//                       child: Text(datehebrew,
//                           style: TextStyle(
//                               color: Color.fromARGB(500, 13, 17, 50),
//                               fontFamily: 'RobotoSlab',
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.bold)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       )),
//       decoration: new BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(headerimage),
//           fit: BoxFit.scaleDown,
//         ),
//         color: Colors.amber,
//       ),
//     );
//   }
// }
