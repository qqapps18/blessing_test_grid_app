import 'package:flutter/material.dart';
import 'Blessing.dart';
import 'PDFViewPage.dart';
import 'FileProvider.dart';

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
  var blessingsPDFs = [
    Blessing("Children", "rev_blessing_of_the_childrensp.pdf",
        'assets/imgblessingaftereaten.jpg'),
    Blessing("Sidur", "siduraskarvinv.pdf", 'assets/imgblessingaftereaten.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text('Blessing.dart Grid View'),
        ),
        body: GridView.count(
            crossAxisCount: 3,
            // Este metodo genera una lista del numero de elementos en
            // 'blessingPDFs' y nos da el indice que es el que luego
            // necesitamos para poder obtener la información del rezo.
            children: List.generate(blessingsPDFs.length, (index) {
              // Abstraemos la creación de la vista a otro metodo
              // para que quede mas limpio el código.
              return cardView(context, index);
            })),
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
                  return PdfViewPage(path: filePath.path);
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
