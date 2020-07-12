import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Esta clase nos vas a servir para abstraer los metodos que usamos para
/// conseguir las rutas a los PDFs. Para usarla solo basta con instanciar
/// un objeto de esta clase y llamar al metodo de 'getAssetByname(String)'
class FileProvider {
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
    List<String> responseList = List(5);

    MethodChannel _methodChannel = MethodChannel('flutter/MethodChannelDemo');

// those are the items position in the List
//    yom         = day
//    jodesh      = month
//    shana       = year
//    isLeapYear  = bicentenary year
//    yomview     = complete date

    try {
      List<dynamic> listResult = await _methodChannel.invokeMethod("Documents");
      responseList[0] = listResult[0];
      responseList[1] = listResult[1];
      responseList[2] = listResult[2];
      responseList[3] = listResult[3];
      responseList[4] = listResult[4];
      _message = responseList[4];

      print("Result from android: " + listResult.cast<String>().toString());
    } on Exception catch (e) {
      print("exception " + e.toString());
    }
  }
}
