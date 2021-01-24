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
          backgroundColor: Color.fromARGB(500, 254, 140, 46),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios),
              onPressed: () {
                if (widget.typeScreen == 'NL') {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
                }
                Navigator.of(context).pop();
              }),
          title: Text(widget.appBarName),
          centerTitle: true,
        ),
        body: WillPopScope(
          child: Stack(
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
          onWillPop: () async {
            print("popping from route 2 disabled");
            return true;
          },
        )
    );
  }

  bool backButtonInterseptor(bool stopDefaultButtonEvent, RouteInfo routeInfo) {
    if (widget.typeScreen == 'NL') {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }
}

// Se pone el PDF en pantalla
class PdfViewPage extends StatefulWidget {
  final String path;
  final String appBarName;
  final String typeScreen;

  const PdfViewPage({Key key, this.path, this.appBarName, this.typeScreen})
      : super(key: key);

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}
