import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Esta clase nos vas a servir para abstraer los metodos que usamos para
/// conseguir las rutas a los PDFs. Para usarla solo basta con instanciar
/// un objeto de esta clase y llamar al metodo de 'getAssetByname(String)'
class FileProvider {
  List<dynamic> yomview;
  String yom;
  String jodesh;
  String Shana;

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

  Future<void> getDocuments() async {
    String _message = 'no message yet ... ';
    List<dynamic> responseList = List(5);

    MethodChannel _methodChannel = MethodChannel('flutter/MethodChannelDemo');

// those are the items position in the List
//    yom         = day
//    jodesh      = month
//    shana       = year
//    isLeapYear  = bicentenary year
//    yomview     = complete date

    try {
      yomview = await _methodChannel.invokeMethod("Documents");
      print("[ANDROID] Result from android: " + yomview.cast<String>().toString());
    } on Exception catch (e) {
      print("[ANDROID] exception " + e.toString());
    }
  }
}
