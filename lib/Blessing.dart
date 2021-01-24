import 'package:blessingtestgridapp/GridLayoutHelper.dart';
import 'package:blessingtestgridapp/localization/localization_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'FileProvider.dart';
import 'PDFViewPage.dart';
import 'package:google_fonts/google_fonts.dart';

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
    @required this.gridLayoutHelper,
    @required this.blessing,
  }) : super(key: key);

  final FileProvider fileProvider;
  final GridLayoutHelper gridLayoutHelper;
  final Blessing blessing;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Card(
// ***** color del Card *********
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              print('File Name ' + getTranslated(context, blessing.fileName));
              var filePath = await fileProvider
                  .getAssetByName(getTranslated(context, blessing.fileName));
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PdfViewPage(
                    path: filePath.path,
                    appBarName: getTranslated(context, blessing.name),
                    typeScreen: gridLayoutHelper.deviceType);
              }));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  // ************************ wide assing according the phone size ************
                  height: gridLayoutHelper.cellWidth * 0.8,
                  width: gridLayoutHelper.cellWidth,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                          child: Text(
                            getTranslated(context, blessing.name),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.sourceSerifPro(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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
                  width: gridLayoutHelper.cellWidth,
                  height: 40,
                  child: Center(
                    child: Text(
                      getTranslated(context, blessing.appBarName),
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
