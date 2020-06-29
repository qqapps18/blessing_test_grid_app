import 'package:flutter/material.dart';

import 'FileProvider.dart';
import 'PDFViewPage.dart';

/// Modelo del rezo en el cual definimos la estructura del objeto que necesitamos
/// para customizar el CardView en la pantalla principal.
class FestivitiesBlessing {
  String name;
  String fileName;
  String imagePath;
// agrego nombre de para el AppBAr de lectura del PDF
  String appBarName;

  FestivitiesBlessing(
      this.name, this.fileName, this.imagePath, this.appBarName);
}

class CardLoadFes extends StatelessWidget {
  const CardLoadFes({
    Key key,
    @required this.fileProvider,
    @required this.blessibgFe,
  }) : super(key: key);

  final FileProvider fileProvider;
  final FestivitiesBlessing blessibgFe;

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
                await fileProvider.getAssetByName(blessibgFe.fileName);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PdfViewPage(
                    path: filePath.path,
                    appBarName: blessibgFe.appBarName,
                  );
                }));
              },
              child: Image.asset(blessibgFe.imagePath),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            blessibgFe.name,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
