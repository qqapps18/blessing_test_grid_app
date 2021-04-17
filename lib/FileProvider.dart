import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


/// Esta clase nos vas a servir para abstraer los metodos que usamos para
/// conseguir las rutas a los PDFs. Para usarla solo basta con instanciar
/// un objeto de esta clase y llamar al metodo de 'getAssetByname(String)'
class FileProvider {
  List<dynamic> yomview;
  String datehebrew;
  int yom;
  String jodesh;
  int shana;
  bool isleapyear;
  String leapyear;
  int yesterdayyom;
  String yesterdayjodesh;
  int yesterdayshana;
  int daybeforeyom;
  String daybeforejodesh;
  int daybeforeshana;
  int numjodeshyesterday;
  int numjodeshdaybefore;
  int numjodesh;

  Future<File> getAssetByName(String sourceName) async {
    var sampleData = await rootBundle.load("assets/$sourceName");
    final path = await _localPath;
    var file = File('$path/$sourceName');
    print('El File Name en File provider ' + path);
    file = await file.writeAsBytes(sampleData.buffer.asUint8List());
    return file;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Busqueda de las fechas en android

  MethodChannel _methodChannel = MethodChannel('flutter/MethodChannelDemo');

  Future<void> getDocuments() async {

    try {
      yomview = await _methodChannel.invokeMethod("Documents");

      datehebrew = yomview[0];
      yom = int.parse(yomview[1]);
      jodesh = yomview[2];
      numjodesh = int.parse(yomview[3]);
      shana = int.parse(yomview[4]);
      leapyear = yomview[5];

      if (leapyear == "1") {
        isleapyear = true;
      } else {
        isleapyear = false;
      }

      yesterdayyom = int.parse(yomview[6]);
      yesterdayjodesh = yomview[7];
      numjodeshyesterday = int.parse(yomview[8]);
      yesterdayshana = int.parse(yomview[9]);

      daybeforeyom = int.parse(yomview[10]);
      daybeforejodesh = yomview[11];
      numjodeshdaybefore = int.parse(yomview[12]);
      daybeforeshana = int.parse(yomview[13]);

//      print("[ANDROID] Result from android: " +  yomview.cast<String>().toString());

      //callback();
    } on Exception catch (e) {
      print("[ANDROID] exception " + e.toString());
    }
  }
}
