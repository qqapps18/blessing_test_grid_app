import 'package:blessingtestgridapp/BlessingSectionHeader.dart';
import 'package:blessingtestgridapp/FestivitiesBlessing.dart';
import 'package:blessingtestgridapp/FoodBlessing.dart';
import 'package:blessingtestgridapp/MiscellaneousBlessing.dart';
import 'package:blessingtestgridapp/ShabbatBlesing.dart';
import 'package:blessingtestgridapp/localization/App_Localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Blessing.dart';
import 'FileProvider.dart';
import 'BlessingSectionHeader.dart';
import 'localization/localization_constants.dart';

void main() {
  runApp(BlessingGridView());
}

class BlessingGridView extends StatefulWidget {
  @override
  _BlessingGridViewState createState() => _BlessingGridViewState();
}

class _BlessingGridViewState extends State<BlessingGridView> {
 
  // Inicializamos la clase 'FileProvider'
  var fileProvider = FileProvider();

  // Inicializamos un arreglo con todos los blessings que queremos mostrar.
  // Idealmente, este arreglo se cambiaria por otra clase que nos provea la
  // estructura de la vista, es decir, el número de secciones y la cantidad de
  // elementos por sección.

  // se agrego nombre para el AppBar de la lectura del PDF
  var blessingsPDFs = [
    Blessing("Children", "rev_blessing_of_the_childrensp.pdf",
        'assets/imgblessingofchildren.jpg', 'Family'),
    Blessing("Home", "rev_blessing_affix_mesusahen.pdf",
        'assets/img_affixing_a_mezuzahen.png', 'Family'),
    Blessing("Travel", "rev_the_travelers_prayeren_sp.pdf",
        'assets/img_the_travelers_prayeren.png', 'Family'),
  ];

  var blessingsFood = [
    FoodBlessing("Before Eating", "rev_blessing_over_hand_washingen.pdf",
        'assets/img_blessingwhenwashinghands.png', 'Food'),
    FoodBlessing("Wine", "rev_blessing_over_wineen.pdf",
        'assets/img_blessing_the_wineen.png', 'Food'),
    FoodBlessing("Bread", "revblessingoverbreaden.pdf",
        'assets/img_blessingwheneatingbreaden.png', 'Food'),
    FoodBlessing("Grains", "rev_blessing_over_grainsen.pdf",
        'assets/img_blessingwheneatinggrainsen.png', 'Food'),
    FoodBlessing("Vegetables", "rev_blessing_over_vegetablesen.pdf",
        'assets/img_blessingwheneatingvegetablesen.png', 'Food'),
    FoodBlessing("Fruits", "rev_blessing_over_fruiten.pdf",
        'assets/img_blessingwheneatingfruitsen.png', 'Food'),
    FoodBlessing("All Other Food", "rev_blessing_on_all_other_foodsen.pdf",
        'assets/img_blessingwheneatingcakeandcandiesen.png', 'Food'),
    FoodBlessing("Birkat Hamazon", "rev_birkat_hamazonen.pdf",
        'assets/imgblessingaftereaten.jpg', 'Food'),
    FoodBlessing("Challa", "rev_makingchallahen.pdf",
        'assets/fondo_bendiciones.png', 'Food'),
  ];

  var blessingsShabbat = [
    ShabbatBlessing(
        "The Candles",
        "rev_blessing_over_the_shabbat_candlesen.pdf",
        'assets/img_blessingofsabbathcandelsen.png',
        'Shabbat'),
    ShabbatBlessing("Kidush", "rev_kidush_Shabaten.pdf",
        'assets/img_kidush_shabbaten.png', 'Shabbat'),
    ShabbatBlessing(
        "Havdala", "rev_havdalahen.pdf", 'assets/imghavdalahen.jpg', 'Shabbat'),
  ];

  var blessingsFestivites = [
    FestivitiesBlessing("Hanukka", "rev_blessings_over_hanukkah_candlesen.pdf",
        'assets/img_blessing_over_hanukkah_candlesen.png', 'Festivities'),
    FestivitiesBlessing("Yom Tov", "rev_blessing_over_yom_tov_candlesen.pdf",
        'assets/img_blessing_over_yom_tov_candlesen.png', 'Festivities'),
    FestivitiesBlessing("Sukkot", "rev_sukkot_blessingsen.pdf",
        'assets/img_blessings_over_sukkoten.png', 'Festivities'),
    FestivitiesBlessing("Yom Tov", "rev_kiddush_shalosh_regalimen.pdf",
        'assets/img_kidush_shalosh_regalimen.png', 'Festivities'),
    FestivitiesBlessing("Rosh Hashanah", "rev_kiddush_Rosh_hashanahen.pdf",
        'assets/fondo_bendiciones.png', 'Festivities'),
    FestivitiesBlessing(
        "Yom Kipur",
        "rev_blessing_over_yom_kippur_candlesen.pdf",
        'assets/fondo_bendiciones.png',
        'Festivities'),
  ];

  var blessingsMiscellaneous = [
    MiscellaneousBlessing("Nature", "rev_blessings_when_hear_thunderen.pdf",
        'assets/img_when_hear_thunderen.png', 'Miscellaneous'),
    MiscellaneousBlessing("Nature", "rev_blessings_when_see_lightningen.pdf",
        'assets/img_when_see_lightningen.png', 'Miscellaneous'),
    MiscellaneousBlessing("Nature", "rev_blessings_when_see_rainbowen.pdf",
        'assets/img_when_see_a_rainbowen.png', 'Miscellaneous'),
    MiscellaneousBlessing(
        "Personnel",
        "rev_blessings_when_hear_good_newsen.pdf",
        'assets/fondo_bendiciones.png',
        'Miscellaneous'),
    MiscellaneousBlessing("Personnel", "rev_blessings_when_hear_bad_newsen.pdf",
        'assets/fondo_bendiciones.png', 'Miscellaneous'),
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
                    title: Text(
                      getTranslated(context, 'Book_Of_ Blessings'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                    pinned: true,
                    backgroundColor: Colors.amber,
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Image.asset(
                      'assets/headerblassingbookappbar.png',
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

    var blessibgF = blessingsFood[index];

    return CardLoadF(fileProvider: fileProvider, blessibgF: blessibgF);
  }

  Widget cardViewS(BuildContext context, int index) {
    // Este es el rezo y en el metodode abajo vamos a utilizar la información
    // para customizar el 'CardView'.

    var blessibgS = blessingsShabbat[index];

    return CardLoadS(fileProvider: fileProvider, blessibgS: blessibgS);
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
}
