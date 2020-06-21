import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(BlessingGridView());
}

class BlessingGridView extends StatefulWidget {
  @override
  _BlessingGridViewState createState() => _BlessingGridViewState();
}

class _BlessingGridViewState extends State<BlessingGridView> {
// variable para el Path del PDF
  String assetPDFPath = "";

// inicializa el path del PDF
  @override
  void initState() {
    super.initState();

    getAssetByName("rev_blessing_of_the_childrensp.pdf").then((f) {
      setState(() {
        print('este es el path ' + f.path);
        assetPDFPath = f.path;
      });
    });
  }

  Future<File> getAssetByName(String sourceName) async {
    var sampleData = await rootBundle.load("assets/$sourceName");
    final path = await _localPath;
    var file = File('$path/$sourceName');
    file = await file.writeAsBytes(sampleData.buffer.asUint8List());
    return file;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text('Blessing Grid View'),
        ),
        body: GridView.count(
          crossAxisCount: 3,
          children: <Widget>[
            Card(
              color: Colors.amberAccent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: InkWell(
                      onTap: () {
//                                 Se abre el PDF
                        if (assetPDFPath != null) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PdfViewPage(path: assetPDFPath);
                          }));
                        }
                      },
                      child: Image.asset(
                        'assets/imgblessingaftereaten.jpg',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Bendiciones Hijos',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

// Se pone el PDF en pantalla
class PdfViewPage extends StatefulWidget {
  final String path;

  const PdfViewPage({Key key, this.path}) : super(key: key);

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Document"),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: true,
            nightMode: false,
            onError: (e) {
              print(e);
            },
            onRender: (_pages) {
              setState(() {
                print('Esta es la pagina ' + _pages.toString());
                _totalPages = _pages;
                _currentPage = _pages;
                _pdfViewController.setPage(_pages);
                print('esta en la pagina a abrir  ' + _pages.toString());
                pdfReady = true;
              });
            },
            onViewCreated: (PDFViewController vc) {
              _pdfViewController = vc;
            },
            onPageChanged: (int page, int total) {
              setState(() {});
            },
            onPageError: (page, e) {},
          ),
          !pdfReady
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage()
        ],
      ),
    );
  }
}
