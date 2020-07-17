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

void main() {
  runApp(BlessingGridView());
}

class BlessingGridView extends StatefulWidget {
  @override
  _BlessingGridViewState createState() => _BlessingGridViewState();
}

class _BlessingGridViewState extends State<BlessingGridView> {
  var platform = MethodChannel("blessing/date");

  @override
  void initState() {
    fileProvider.getDocuments();
    super.initState();
  }

  // Inicializamos la clase 'FileProvider'
  var fileProvider = FileProvider();
  String _deviceLocale;
  DateTime _dateTime = new DateTime.now();
  String _date = DateFormat.yMMMd().format(DateTime.now());

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
                    title: Column(
                      children: <Widget>[
                        Text(
                          getTranslated(
                            context,
                            'Book_Of_Blessings',
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              DateFormat.yMMMd(_deviceLocale)
                                  .format(DateTime.now()),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              fileProvider.yomview,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    centerTitle: true,
                    pinned: true,
                    backgroundColor: Colors.amber,
                    expandedHeight: 130,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Image.asset(
                      'assets/maguendavidyellow.png',
                      fit: BoxFit.fitHeight,
                    )),
                  ),

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

//*********************************************************************

//*********************************************************************
}
