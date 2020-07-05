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
}
