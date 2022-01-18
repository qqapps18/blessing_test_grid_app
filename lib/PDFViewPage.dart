import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:store_redirect/store_redirect.dart';

class _PdfViewPageState extends State<PdfViewPage> with WidgetsBindingObserver {
  bool pdfReady = false;
  PDFViewController _pdfViewController;
  UniqueKey pdfViewerKey = UniqueKey();

  // Control para dar el rating a la app *****
  RateMyApp _rateMyApp = RateMyApp(
    minDays: 3,
    minLaunches: 3,
    remindDays: 2,
    remindLaunches: 5,
    appStoreIdentifier: "com.qqapps.blessingbook",
    googlePlayIdentifier: "com.qqapps.blessingbook",
  );
  // Control para rating fin *****

  void showRateDialog() {
    _rateMyApp.init().then((_) {
      if(_rateMyApp.shouldOpenDialog) {
      _rateMyApp.showRateDialog(
        context,
        title: 'Enjoying The Blessing Book?',
        message: 'Thanks for using this "Book of Blessings" is just the ' +
            'beginning of more content and information, and learnings. ' +
            'Please help us to keep improving this App, telling us your ' +
            'thought and suggestions to make it much better, more useful, ' +
            'and friendly to you. Please leave a rating.',
        dialogStyle: DialogStyle(
          titleAlign: TextAlign.center,
          messageAlign: TextAlign.center,
          messagePadding: EdgeInsets.only(bottom: 20.0),
        ),
        ignoreNativeDialog: Platform.isAndroid,
        rateButton: 'RATE',
        noButton: 'NO THANKS',
        laterButton: 'MAYBE LATER',
        listener: (button) {
          switch (button) {
            case RateMyAppDialogButton.rate:
              if (Platform.isAndroid) {
                print('Clicked on "Rate Android".');
                StoreRedirect.redirect(
                    androidAppId: "com.qqapps.blessingbook",
                    iOSAppId: "com.qqapps.blessingbook"
                );
              } else
                print('Clicked on "Rate IOS".');
              break;
            case RateMyAppDialogButton.later:
              print('Clicked on "Later".');
              break;
            case RateMyAppDialogButton.no:
              print('Clicked on "No".');
              break;
          }
          return true;
        },
      );
      }
    });
  }

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
                    showRateDialog();
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
