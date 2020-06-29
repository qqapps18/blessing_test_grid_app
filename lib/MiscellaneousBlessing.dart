import 'package:flutter/material.dart';

import 'FileProvider.dart';
import 'PDFViewPage.dart';

/// Modelo del rezo en el cual definimos la estructura del objeto que necesitamos
/// para customizar el CardView en la pantalla principal.
class MiscellaneousBlessing {
  String name;
  String fileName;
  String imagePath;
// agrego nombre de para el AppBAr de lectura del PDF
  String appBarName;

  MiscellaneousBlessing(
      this.name, this.fileName, this.imagePath, this.appBarName);
}

class CardLoadM extends StatelessWidget {
  const CardLoadM({
    Key key,
    @required this.fileProvider,
    @required this.blessibgMis,
  }) : super(key: key);

  final FileProvider fileProvider;
  final MiscellaneousBlessing blessibgMis;

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
                    await fileProvider.getAssetByName(blessibgMis.fileName);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PdfViewPage(
                    path: filePath.path,
                    appBarName: blessibgMis.appBarName,
                  );
                }));
              },
              child: Image.asset(blessibgMis.imagePath),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            blessibgMis.name,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
