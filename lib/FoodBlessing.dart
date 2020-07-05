import 'package:flutter/material.dart';

import 'FileProvider.dart';
import 'PDFViewPage.dart';
import 'package:blessingtestgridapp/localization/localization_constants.dart';

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
    @required this.blessingF,
  }) : super(key: key);

  final FileProvider fileProvider;
  final FoodBlessing blessingF;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          color: Colors.amberAccent,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(500, 13, 17, 50),
                ),
                height: 65,
                child: Stack(
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        print('File Name ' +
                            getTranslated(context, blessingF.fileName));
                        var filePath = await fileProvider.getAssetByName(
                            getTranslated(context, blessingF.fileName));
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PdfViewPage(
                            path: filePath.path,
                            appBarName: getTranslated(context, blessingF.name),
                          );
                        }));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        heightFactor: 4,
                        child: Text(
                          getTranslated(context, blessingF.name),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: 'RobotoSlab'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow,
                ),
                height: 2,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(500, 13, 17, 50),
                ),
                height: 10,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                getTranslated(context, blessingF.appBarName),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoSlab'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
