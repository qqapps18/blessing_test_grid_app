import 'package:flutter/material.dart';

import 'FileProvider.dart';
import 'PDFViewPage.dart';

/// Modelo del rezo en el cual definimos la estructura del objeto que necesitamos
/// para customizar el CardView en la pantalla principal.
class Blessing {
  String name;
  String fileName;
  String imagePath;
// agrego nombre de para el AppBAr de lectura del PDF
  String appBarName;

  Blessing(this.name, this.fileName, this.imagePath, this.appBarName);
}

class CardLoad extends StatelessWidget {
  const CardLoad({
    Key key,
    @required this.fileProvider,
    @required this.blessing,
  }) : super(key: key);

  final FileProvider fileProvider;
  final Blessing blessing;

  @override
  Widget build(BuildContext context) {
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
