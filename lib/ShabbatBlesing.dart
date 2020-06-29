import 'package:flutter/material.dart';

import 'FileProvider.dart';
import 'PDFViewPage.dart';

/// Modelo del rezo en el cual definimos la estructura del objeto que necesitamos
/// para customizar el CardView en la pantalla principal.
class ShabbatBlessing {
  String name;
  String fileName;
  String imagePath;
// agrego nombre de para el AppBAr de lectura del PDF
  String appBarName;

  ShabbatBlessing(this.name, this.fileName, this.imagePath, this.appBarName);
}

class CardLoadS extends StatelessWidget {
  const CardLoadS({
    Key key,
    @required this.fileProvider,
    @required this.blessibgS,
  }) : super(key: key);

  final FileProvider fileProvider;
  final ShabbatBlessing blessibgS;

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
                    await fileProvider.getAssetByName(blessibgS.fileName);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PdfViewPage(
                    path: filePath.path,
                    appBarName: blessibgS.appBarName,
                  );
                }));
              },
              child: Image.asset(blessibgS.imagePath),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            blessibgS.name,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
