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
import 'localization/localization_constants.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'myappbar.dart';

void main() {
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

  DateTime date = DateTime.now();

  String _deviceLocale;
  DateTime _dateTime = new DateTime.now();
  String _date = DateFormat.yMMMd().format(DateTime.now());
  String hmonth;
  int hyom;
  int hshana;
  bool hisLeapYear;
  int dayofweek;
  String holidayline1 = ' ';
  String holidayline2 = ' ';
  String holidayline3 = ' ';
  String headerimage = 'assets/maguendavidyellow.png';

  @override
  void initState() {
    print('++++++++++++++++++  initstate ++++++++++++++++++++');
    fileProvider.getDocuments(callback: checkHoliday);
    dayofweek = date.weekday;
    intTimeString = DateFormat.H(_deviceLocale).format(DateTime.now());
    intTime = int.parse(intTimeString);
    hmonth = fileProvider.jodesh;
    hyom = fileProvider.yom;
    hshana = fileProvider.shana;
    hisLeapYear = fileProvider.isleapyear;
    print(' estoy de regreso de en initstate ' +
        headerimage +
        'y la linea 2 es ' +
        holidayline2 +
        '-+-+-+');
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
    FestivitiesBlessing("Kidush_For_Rosh_Hashanah", "B_PDF_Kidush_Rosh_Hashana",
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
    MiscellaneousBlessing("Blessing_When_Hear_Bad_News", "B_PDF_Bad_News",
        'assets/fondo_bendiciones.png', 'Personnel'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            backgroundColor: Colors.amber,
            body: SafeArea(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    title: MyAppBar(),
                    floating: false,
                    pinned: true,
                    expandedHeight: 180.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: MyFlexiableAppBar(
                        _date,
                        fileProvider.datehebrew,
                        headerimage,
                        holidayline1,
                        holidayline2,
                        holidayline3,
                      ),
                    ),
                  ),
//                  SliverAppBar(
//                    title: Column(
//                      children: <Widget>[
//                        Text(
//                          getTranslated(
//                            context,
//                            'Book_Of_Blessings',
//                          ),
//                          textAlign: TextAlign.center,
//                          maxLines: 2,
//                          style: TextStyle(
//                            color: Color.fromARGB(500, 13, 17, 50),
//                            fontSize: 25,
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                        SizedBox(height: 10),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Text(
//                              DateFormat.yMMMd(_deviceLocale)
//                                  .format(DateTime.now()),
//                              textAlign: TextAlign.center,
//                              maxLines: 2,
//                              style: TextStyle(
//                                color: Color.fromARGB(500, 13, 17, 50),
//                                fontSize: 18,
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
//                            Text(
//                              holidayText,
//                              textAlign: TextAlign.center,
//                              maxLines: 2,
//                              style: TextStyle(
//                                color: Colors.indigo,
//                                fontSize: 20,
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
//                            Text(
//// *************************** aqui funciona bien ***************************
//                              fileProvider.datehebrew,
//                              textAlign: TextAlign.center,
//                              maxLines: 2,
//                              style: TextStyle(
//                                color: Color.fromARGB(500, 13, 17, 50),
//                                fontSize: 18,
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
//                          ],
//                        ),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Text(
//// *************************** segunda linea de texto ***************************
//                              holidayText,
//                              textAlign: TextAlign.center,
//                              maxLines: 2,
//                              style: TextStyle(
//                                color: Color.fromARGB(500, 13, 17, 50),
//                                fontSize: 18,
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
//                          ],
//                        ),
//                      ],
//                    ),
//                    centerTitle: true,
//                    pinned: true,
//                    backgroundColor: Colors.amber,
//                    expandedHeight: 130,
//                    flexibleSpace: FlexibleSpaceBar(
//                        background: Image.asset(
//                      headerImage,
//                      fit: BoxFit.fitHeight,
//                    )),
//                  ),

//   este es el encabezado de la primera seccion  **************************
                  BlessingSectionHeader(
                      Colors.amber[200], getTranslated(context, 'Family')),

// lista de bendiciones de la primera seccion ******************************
                  SliverGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: BlessingsFiles(context),
                  ),

//   este es el encabezado de la segunda  seccion  **************************
                  BlessingSectionHeader(
                      Colors.amber[200], getTranslated(context, 'Food')),

// lista de bendiciones de la segunda seccion ******************************
                  SliverGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: BlessingsFood(context),
                  ),
//   este es el encabezado de la tercera  seccion  **************************
                  BlessingSectionHeader(
                      Colors.amber[200], getTranslated(context, 'Sabbath')),

// lista de bendiciones de la segunda seccion ******************************
                  SliverGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: BlessingsShabbat(context),
                  ),
//   este es el encabezado de la cuarta  seccion  **************************
                  BlessingSectionHeader(
                      Colors.amber[200], getTranslated(context, 'Festivities')),

// lista de bendiciones de la quinta seccion ******************************
                  SliverGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: BlessingsFestivities(context),
                  ),
//   este es el encabezado de la quinta  seccion  **************************
                  BlessingSectionHeader(Colors.amber[200],
                      getTranslated(context, 'Miscellaneous')),

// lista de bendiciones de la sexta seccion ******************************
                  SliverGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: BlessingsMiscellaneous(context),
                  ),
                ],
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
    // para customizar el 'CardView'.

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

  void checkHoliday() {
    print(' estoy en checkholiday **********************');
    checkRoshHashana();
    checkTzomGedalia();
    checkYomKipur();
    checksukkot();
  }

// ++++++++++++++++ check for Rosh Hashana **************************
  void checkRoshHashana() {
    print('[DEBUG] estoy en checkRoshHashana **********************');
    print('[DEBUG] mes ' + fileProvider.jodesh);
    print('[DEBUG] hora  ' + intTime.toString());
    print('[DEBUG] dia' + fileProvider.yom.toString());
    print('[DEBUG] año' + fileProvider.shana.toString());
    print('[DEBUG] leapyear ' + fileProvider.isleapyear.toString());
    print('[DEBUG] dia de la semana ' + dayofweek.toString());

    // aqui chequeo la fecha para ver si es año nuevo ***************

    if (fileProvider.jodesh == "Elul") {
      if (fileProvider.yom == 29 && intTime > 19) {
        isHoliday(
            'assets/roshhashana.png', 'hemptytxt', 'shana_tova', 'hemptytxt ');
      } else {
        todayIsNotHoliday();
      }
    }

    if (fileProvider.jodesh == "Tishrei") {
      if (fileProvider.yom == 1 || (fileProvider.yom == 2 && intTime < 19)) {
        isHoliday(
            'assets/roshhashana.png', 'hemptytxt', 'shana_tova', 'hemptytxt ');
        print(' estoy de regreso de isholiday 1 tishrei ' +
            headerimage +
            ' ' +
            holidayline2);
      } else {
        todayIsNotHoliday();
      }
    }
  }

//por default para Fluter el primer dia de la semana es el lunes
// por lo que el sabado es el dia 6
// ++++++++++++++++ check for Tzom Gedalia **************************

  void checkTzomGedalia() {
    if (fileProvider.jodesh == "Tishrei") {
      if (fileProvider.yom == 3 && (intTime > 5 && intTime < 19)) {
        if (dayofweek == 6) {
          todayIsTzom('assets/emptyimage.png', 'tzomshabat1', 'tzomGedalia',
              'tzomshabat2');
        } else {
          todayIsTzom('assets/emptyimage.png', 'hemptytxt', 'tzomGedalia',
              'hemptytxt ');
        }
      }
    }

    if (fileProvider.jodesh == "Tishrei") {
      if (fileProvider.yom == 4 && (intTime > 5 && intTime < 19)) {
        if (dayofweek == 7) {
          todayIsTzom('assets/emptyimage.png', 'Yzomshabat1', 'tzomGedalia',
              'Yzomshabat2 ');
        } else {
          todayIsNotHoliday();
        }
      }
    }
  }

// ++++++++++++++++ check for Yom Kipur **************************
  void checkYomKipur() {
    if (fileProvider.jodesh == "Tishrei") {
      if ((fileProvider.yom == 9 && intTime > 17) ||
          (fileProvider.yom == 10 && intTime < 19)) {
        todayIsTzom(
            'assets/emptyimage.png', 'hemptytxt', 'yomkipur', 'hemptytxt');
      } else {
        todayIsNotHoliday();
      }
    }
  }

// ++++++++++++++++ check for Sukkot **************************
  void checksukkot() {
    if (fileProvider.jodesh == "Tishrei") {
      if ((fileProvider.yom == 14 && intTime > 17) ||
          (fileProvider.yom > 14 && fileProvider.yom < 20) ||
          (fileProvider.yom == 20 && intTime < 19)) {
        isHoliday(
            'assets/sukkot.png', 'hemptytxt', 'sukkot', 'hemptytxt');
      } else {
        if ((fileProvider.yom == 20 && intTime > 17) ||
            (fileProvider.yom == 21 && intTime < 19)) {
          isHoliday(
              'assets/sukkot.png', 'hemptytxt', 'hoshanaraba', 'hemptytxt');
        } else {
          if ((fileProvider.yom == 21 && intTime > 17) ||
              (fileProvider.yom == 22 && intTime < 19)) {
            isHoliday(
                'assets/sukkot.png', 'hemptytxt', 'sheminiatzeret', 'hemptytxt');
          } else {
            if ((fileProvider.yom == 22 && intTime > 17) ||
                (fileProvider.yom == 23 && intTime < 19)) {
              isHoliday(
                  'assets/sukkot.png', 'hemptytxt', 'sinchattorah', 'hemptytxt');
            } else {
              todayIsNotHoliday();
            }
          }
        }
      }
    }
  }

//  private void checkJanuca() {
//    int endmonth = 0;
//
//    checkprevday();
//    checkantprevday();
//
//    if (jodesh.equals("Tevet")) {
//      if (yom == 1 && prevyom == 29) {
//        endmonth = 1;
//      } else if (yom == 2 && (antprevyom == 29)) {
//        endmonth = 1;
//      } else if (yom == 1 && (prevyom == 30)) {
//        endmonth = 2;
//      } else if (yom == 2 && (antprevyom == 30)) {
//        endmonth = 2;
//      }
//    }
//
//    if (jodesh.equals("Kislev")) {
//      if ((yom == 24 && intTime > 17) || (yom == 25 && intTime < 18)) {
//        imageHoliday.setImageResource(R.drawable.januquilladia1);
//        yomholiday.setText(getString(R.string.happyjanuca));
//        todayIsHoliday();
//      } else if ((yom == 25 && intTime > 17) || (yom == 26 && intTime < 18)) {
//        imageHoliday.setImageResource(R.drawable.januquilladia2);
//        yomholiday.setText(getString(R.string.happyjanuca));
//        todayIsHoliday();
//      }  else if ((yom == 26 && intTime > 17) || (yom == 27 && intTime < 18)) {
//        imageHoliday.setImageResource(R.drawable.januquilladia3);
//        yomholiday.setText(getString(R.string.happyjanuca));
//        todayIsHoliday();
//      }  else if ((yom == 27 && intTime > 17) || (yom == 28 && intTime < 18)) {
//        imageHoliday.setImageResource(R.drawable.januquilladia4);
//        yomholiday.setText(getString(R.string.happyjanuca));
//        todayIsHoliday();
//      } else if ((yom == 28 && intTime > 17) || (yom == 29 && intTime < 18)) {
//        imageHoliday.setImageResource(R.drawable.januquilladia5);
//        yomholiday.setText(getString(R.string.happyjanuca));
//        todayIsHoliday();
//      } else if ((yom == 29 && intTime > 17) || (yom == 30  && intTime < 18)) {
//        imageHoliday.setImageResource(R.drawable.januquilladia6);
//        yomholiday.setText(getString(R.string.happyjanuca));
//        todayIsHoliday();
//      } else if (yom == 30  && intTime > 17) {
//        imageHoliday.setImageResource(R.drawable.januquilladia7);
//        yomholiday.setText(getString(R.string.happyjanuca));
//        todayIsHoliday();
//      }
//    }
//
//    if (jodesh.equals("Tevet")) {
//      if (yom == 1 && endmonth == 1 && intTime < 18) {
//        imageHoliday.setImageResource(R.drawable.januquilladia7);
//        yomholiday.setText(getString(R.string.happyjanuca));
//        todayIsHoliday();
//      } else if (yom == 1 && endmonth == 1 && intTime > 17) {
//        imageHoliday.setImageResource(R.drawable.januquillacompleta);
//        yomholiday.setText(getString(R.string.happyjanuca));
//        todayIsHoliday();
//      } else if (yom == 2 && endmonth == 1 && intTime < 18) {
//        imageHoliday.setImageResource(R.drawable.januquillacompleta);
//        yomholiday.setText(getString(R.string.happyjanuca));
//        todayIsHoliday();
//      } else if (yom == 1 && endmonth == 2 && intTime < 18) {
//        imageHoliday.setImageResource(R.drawable.januquilladia7);
//        yomholiday.setText(getString(R.string.happyjanuca));
//        todayIsHoliday();
//      } else if (yom == 1 && endmonth == 2 && intTime > 17) {
//        imageHoliday.setImageResource(R.drawable.januquillacompleta);
//        yomholiday.setText(getString(R.string.happyjanuca));
//        todayIsHoliday();
//      } else if (yom == 1 && endmonth == 2 && intTime > 18) {
//        todayIsNotHoliday();
//      } else if (yom == 2 && endmonth == 2 && intTime < 18) {
//        imageHoliday.setImageResource(R.drawable.januquillacompleta);
//        yomholiday.setText(getString(R.string.happyjanuca));
//        todayIsHoliday();
//      } else if (yom == 3 || (yom == 2 && intTime > 17)) {
//        endmonth = 0;
//        isHoliday = 0;
//        todayIsNotHoliday();
//      }
//    }
//  }







  void isHoliday(String himage, String hline1, hline2, hline3) {
    print(' estoy isHoliday ' + himage + ' ' + hline2);
    headerimage = himage;
//    holidayline1 = getTranslated(context, hline1);
//    holidayline2 = getTranslated(context, hline2);
//    holidayline3 = getTranslated(context, hline3);
    holidayline1 = hline1;
    holidayline2 = hline2;
    holidayline3 = hline3;
  }

  void todayIsNotHoliday() {
    headerImage = 'assets/maguendavidyellow.png';
    holidayline1 = ' ';
    holidayline2 = ' ';
    holidayline3 = ' ';
  }

  void todayIsTzom(String himage, String hline1, hline2, hline3) {
    print(' estoy todayIsTzom ' + himage + ' ' + hline2);
    headerimage = himage;
//    holidayline1 = getTranslated(context, hline1);
//    holidayline2 = getTranslated(context, hline2);
//    holidayline3 = getTranslated(context, hline3);
    holidayline1 = hline1;
    holidayline2 = hline2;
    holidayline3 = hline3;
  }
}

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

    print(' estoy  en MyFlexiableAppBar 1 tishrei ' +
        headerimage +
        ' ' +
        holidayline2);

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
                    child: Text(holidayline1,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'RobotoSlab',
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    child: new Text(holidayline2,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'RobotoSlab',
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    child: new Text(holidayline3,
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
