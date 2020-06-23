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
        'assets/imgblessingofchildren.jpg', 'Blessing of Children'),
    Blessing("Mezuza", "rev_blessing_affix_mesusahen.pdf",
        'assets/img_the_travelers_prayeren.png', 'Home'),
    Blessing("Viajes", "rev_the_travelers_prayeren_sp.pdf",
        'assets/img_the_travelers_prayeren.png', 'Viajes'),
  ];

// widget para probar el sliverList ****************************************
  Widget _listaDeBendiciones(String type, String pathBlessingPDF,
      String imageBlessing, String blessingTitle, Color color) {
    return Container(
      color: color,
      child: Column(
        children: <Widget>[
          Text(type),
          Text(pathBlessingPDF),
          Text(imageBlessing),
          Text(blessingTitle),
        ],
      ),
    );
  }
// ************************************************************************

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Builder(
      builder: (context) => Scaffold(
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
//   este es el encabezado de cada seccion **************************
              BlessingSectionHeader(Colors.purple[200], 'Family'),
//*******************************************************************
// esta lista es de prueba, se debera eliminar mas adelante  y remplazar por el Slivergrid
              SliverFixedExtentList(
                itemExtent: 150,
                delegate: SliverChildListDelegate([
                  _listaDeBendiciones(
                      "Children",
                      "rev_blessing_of_the_childrensp.pdf",
                      'assets/imgblessingofchildren.jpg',
                      'Blessing of Children',
                      Colors.greenAccent),
                  _listaDeBendiciones(
                      "Mezuza",
                      "rev_blessing_affix_mesusahen.pdf",
                      'assets/img_the_travelers_prayeren.png',
                      'Home',
                      Colors.green),
                ]),
              ),
//*******************************************************************
// encabezado de la segunda seccion y asi se iran creando segun se necesite
              BlessingSectionHeader(Colors.purple[200], 'Alimentos'),
//*******************************************************************
// segunda lista de prueba, para verificar como funcionan los encabezados
              SliverFixedExtentList(
                itemExtent: 150,
                delegate: SliverChildListDelegate([
                  _listaDeBendiciones(
                      "Viajes",
                      "rev_the_travelers_prayeren_sp.pdf",
                      'assets/img_the_travelers_prayeren.png',
                      'Viajes',
                      Colors.greenAccent),
                ]),
              ),
//*******************************************************************
// este es el SliverGrid, equivalente al GridView pero soporta la animacion
// que quiero tenga la aplicacion
              SliverGrid(
//aqui defino el formato del SliverGrid, cuantas columnas y el espacion entre las casillas
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
// aqui deberia mandar cargar las celdas con el CardView, pero no lo he logrado todavia
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Container(
                    child: GridView(
                        children: List.generate(blessingsPDFs.length, (index) {
                      return cardView(context, index);
                    })),
                  );
                }),
              ),
            ],

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
          ),
        ),
      ),
    ));
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
