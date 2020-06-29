import 'package:flutter/material.dart';

import 'FileProvider.dart';
import 'PDFViewPage.dart';

/// Modelo del rezo en el cual definimos la estructura del objeto que necesitamos
/// para customizar el CardView en la pantalla principal.
class FoodBlessing {
  String name;
  String fileName;
  String imagePath;
// agrego nombre de para el AppBAr de lectura del PDF
  String appBarName;

  FoodBlessing(this.name, this.fileName, this.imagePath, this.appBarName);
}

class CardLoadF extends StatelessWidget {
  const CardLoadF({
    Key key,
    @required this.fileProvider,
    @required this.blessibgF,
  }) : super(key: key);

  final FileProvider fileProvider;
  final FoodBlessing blessibgF;

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
                    await fileProvider.getAssetByName(blessibgF.fileName);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PdfViewPage(
                    path: filePath.path,
                    appBarName: blessibgF.appBarName,
                  );
                }));
              },
              child: Image.asset(blessibgF.imagePath),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            blessibgF.name,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
