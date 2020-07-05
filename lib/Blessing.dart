import 'package:blessingtestgridapp/localization/localization_constants.dart';
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
    return Stack(
      children: <Widget>[
        Card(
          color: Colors.amberAccent,
          child: Column(
//            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(500, 13, 17, 50),
                ),
                height: 80,

//                decoration: BoxDecoration(
//                  image: DecorationImage(
//                    image: AssetImage('assets/fondo_bendiciones.png'),
//                    fit: BoxFit.cover,
//                  ),
//                ),
                child: Stack(
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        print('File Name ' +
                            getTranslated(context, blessing.fileName));
                        var filePath = await fileProvider.getAssetByName(
                            getTranslated(context, blessing.fileName));
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PdfViewPage(
                            path: filePath.path,
                            appBarName: getTranslated(context, blessing.name),
                          );
                        }));
                      },
                      child: Container(
//                        decoration: BoxDecoration(
//                            color: Color.fromARGB(500, 13, 17, 50)),
//                        height: 100,
                          ),

//                      child: Image.asset(blessing.imagePath),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        heightFactor: 5,
                        child: Text(
                          getTranslated(context, blessing.name),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
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
                height: 20,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                getTranslated(context, blessing.appBarName),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 12,
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
