import 'package:blessingtestgridapp/BlessingSectionHeader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Blessing.dart';
import 'PDFViewPage.dart';
import 'FileProvider.dart';
import 'BlessingSectionHeader.dart';

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
    Blessing("Before Eating", "rev_blessing_over_hand_washingen.pdf",
        'img_blessingwhenwashinghands.png', 'Food'),
    Blessing("Wine", "rev_blessing_over_wineen.pdf",
        'img_blessing_the_wineen.png', 'Food'),
    Blessing("Bread", "revblessingoverbreaden.pdf",
        'img_blessingwheneatingbreaden.png', 'Food'),
    Blessing("Grains", "rev_blessing_over_grainsen.pdf",
        'img_blessingwheneatinggrainsen.png', 'Food'),
    Blessing("Vegetables", "rev_blessing_over_vegetablesen.pdf",
        'img_blessingwheneatingvegetablesen.png', 'Food'),
    Blessing("Fruits", "rev_blessing_over_fruiten.pdf",
        'img_blessingwheneatingfruitsen.png', 'Food'),
    Blessing("All Other Food", "rev_blessing_on_all_other_foodsen.pdf",
        'img_blessingwheneatingcakeandcandiesen.png', 'Food'),
    Blessing("Birkat Hamazon", "rev_birkat_hamazonen.pdf",
        'assets/imgblessingaftereaten.jpg', 'Food'),
    Blessing(
        "Challa", "rev_makingchallahen.pdf", 'fondo_bendiciones.png', 'Food'),
  ];

  var blessingsHome = [
    Blessing("Children", "rev_blessing_of_the_childrensp.pdf",
        'assets/imgblessingofchildren.jpg', 'Home'),
    Blessing("Mezuza", "rev_blessing_affix_mesusahen.pdf",
        'assets/img_the_travelers_prayeren.png', 'Home'),
    Blessing("Children", "rev_blessing_of_the_childrensp.pdf",
        'assets/imgblessingofchildren.jpg', 'Home'),
    Blessing("Mezuza", "rev_blessing_affix_mesusahen.pdf",
        'assets/img_the_travelers_prayeren.png', 'Home'),
    Blessing("Viajes", "rev_the_travelers_prayeren_sp.pdf",
        'assets/img_the_travelers_prayeren.png', 'Home'),
    Blessing("Children", "rev_blessing_of_the_childrensp.pdf",
        'assets/imgblessingofchildren.jpg', 'Home'),
    Blessing("Mezuza", "rev_blessing_affix_mesusahen.pdf",
        'assets/img_the_travelers_prayeren.png', 'Home'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Builder(
      builder: (context) => Scaffold(
        backgroundColor: Colors.amber,
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text(
                  'Book Of Blassings',
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
              BlessingSectionHeader(Colors.amber[200], 'Family'),

// lista de bendiciones de la primera seccion ******************************
              SliverGrid.count(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: BlessingsFiles(context),
              ),

//   este es el encabezado de la segunda  seccion  **************************
              BlessingSectionHeader(Colors.amber[200], 'Food'),

// lista de bendiciones de la segunda seccion ******************************
              SliverGrid.count(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: BlessingsFood(context),
              ),
//   este es el encabezado de la tercera  seccion  **************************
              BlessingSectionHeader(Colors.amber[200], 'Shabbat'),

// lista de bendiciones de la segunda seccion ******************************
              SliverGrid.count(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: BlessingsFiles(context),
              ),
//   este es el encabezado de la cuarta  seccion  **************************
              BlessingSectionHeader(Colors.amber[200], 'Festivities'),

// lista de bendiciones de la quinta seccion ******************************
              SliverGrid.count(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: BlessingsFiles(context),
              ),
//   este es el encabezado de la quinta  seccion  **************************
              BlessingSectionHeader(Colors.amber[200], 'Miscellaneous'),

// lista de bendiciones de la sexta seccion ******************************
              SliverGrid.count(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: BlessingsFiles(context),
              ),

//*******************************************************************
// segmento original que funciona bien, reservado como plan "B" *********
//          child: GridView.count(
//              crossAxisCount: 3,
//              // Este metodo genera una lista del numero de elementos en
//              // 'blessingPDFs' y nos da el indice que es el que luego
//              // necesitamos para poder obtener la información del rezo.
//              children: List.generate(blessingsPDFs.length, (index) {
//                // Abstraemos la creación de la vista a otro metodo
//                // para que quede mas limpio el código.
//                return cardView(context, index);
//              })),
//***********************************************************************
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
    return List.generate(blessingsPDFs.length, (index) {
      return cardView(context, index);
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

    return Card(
      color: Colors.amberAccent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: InkWell(
              onTap: () async {
                var filePath =
                    await fileProvider.getAssetByName(blessing.fileName);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PdfViewPage(
                    path: filePath.path,
                    appBarName: blessing.appBarName,
                  );
                }));
              },
              child: Image.asset(blessing.imagePath),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            blessing.name,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
