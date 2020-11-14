import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:back_button_interceptor/back_button_interceptor.dart';

class _PdfViewPageState extends State<PdfViewPage> with WidgetsBindingObserver {
  bool pdfReady = false;
  PDFViewController _pdfViewController;
  UniqueKey pdfViewerKey = UniqueKey();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp
    ]);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    BackButtonInterceptor.add(backButtonInterseptor);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (Platform.isAndroid) {
      Future.delayed(Duration(milliseconds: 250), () {
        setState(() => pdfViewerKey = UniqueKey());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () {
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
              Navigator.of(context).pop();
            }),
        title: Text(widget.appBarName),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            key: pdfViewerKey,
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
                _pdfViewController.setPage(_pages - 1);
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

  bool backButtonInterseptor(bool stopDefaultButtonEvent, RouteInfo routeInfo) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}

// Se pone el PDF en pantalla
class PdfViewPage extends StatefulWidget {
  final String path;
  final String appBarName;

  const PdfViewPage({Key key, this.path, this.appBarName}) : super(key: key);

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}
