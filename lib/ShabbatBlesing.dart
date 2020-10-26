import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'FileProvider.dart';
import 'PDFViewPage.dart';
import 'package:blessingtestgridapp/localization/localization_constants.dart';

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
    @required this.blessingS,
  }) : super(key: key);

  final FileProvider fileProvider;
  final ShabbatBlessing blessingS;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
// ***** color del Card *********
          color: Color.fromARGB(500, 254, 129, 52),
          child: InkWell(
            onTap: () async {
              print('File Name ' + getTranslated(context, blessingS.fileName));
              var filePath = await fileProvider
                  .getAssetByName(getTranslated(context, blessingS.fileName));
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PdfViewPage(
                  path: filePath.path,
                  appBarName: getTranslated(context, blessingS.name),
                );
              }));
            },
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
// **** color container prayer name *****
                    color: Color.fromARGB(500, 116, 221, 166),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(7, 6),
                        blurRadius: 4,
                      )
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 75,
                  width: 110,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          heightFactor: 5,
                          child: Text(
                            getTranslated(context, blessingS.name),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.sourceSerifPro(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
// **** color container separador del titulo y la categoria*****
                SizedBox(
                  height: 5,
                ),
// ****** color Container de la categoria
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(500, 95, 181, 210),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(7, 6),
                        blurRadius: 4,
                      )
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 110,
                  height: 25,
                  child: Center(
                    child: Text(
                      getTranslated(context, blessingS.appBarName),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sourceSerifPro(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
