import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sunrise_sunset/sunrise_sunset.dart';
import 'package:intl/intl.dart';

import 'FileProvider.dart';
import 'localization/localization_constants.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/localization_constants.dart';

class HeaderIsHolliday extends StatefulWidget {
  @override
  _HeaderIsHollidaytState createState() => _HeaderIsHollidaytState();
}

class _HeaderIsHollidaytState extends State<HeaderIsHolliday> {

  String headerimage = 'assets/splashlogo.gif';
  String holidayline1 = ' ';
  String holidayline2 = ' ';
  String holidayline3 = ' ';
  bool swfestivity = false;
  bool swtzom = false;
  String datehebrew = '';
  DateTime date = DateTime.now();
  var fileProvider = FileProvider();
  int dayofweek = 0;
  double lat = 0;
  double long = 0;
  int istzomesther = 0;



  DateTime dateUTC;

  @override
  void initState() {
    fileProvider
        .getDocuments()
        .then((file) => _getCurrentlocation())
        .then((point) => _getSunriseSunset(point))
        .then((sunrisedata) => checkHoliday(sunrisedata));
    dayofweek = date.weekday;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + 60.0,
      child: new Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text('$holidayline1',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'RobotoSlab',
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    child: new Text('$holidayline2',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'RobotoSlab',
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    child: new Text('$holidayline3',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'RobotoSlab',
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(DateFormat.yMMMd().format(date),
                          style: TextStyle(
                              color: Color.fromARGB(500, 13, 17, 50),
                              fontFamily: 'RobotoSlab',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(fileProvider.datehebrew,
                          style: TextStyle(
                              color: Color.fromARGB(500, 13, 17, 50),
                              fontFamily: 'RobotoSlab',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
      decoration: new BoxDecoration(
        image: DecorationImage(
          image: AssetImage('$headerimage'),
          fit: BoxFit.scaleDown,
        ),
        color: Colors.amber,
      ),
    );
  }

  /* CHECK HOLIDAYS */

  void checkHoliday(SunriseSunsetData data) {
    print('CheckHoliday holidayline1 ' + holidayline1 + '===========');

    // variables para el calculo del sunrise y sunset
    // daylight - hora local del amanecer en el meridiano 0
    // nighlight - hora local del atardecer en el meridiano 0
    // offsetInHours - horas de diferencia con el meridiano 0
    //                 que se sumaran para obtener la hora local correcta
    // sunriseTime - hora local del amanecer
    // sunsetTime - hora local del atardecer
    // now - la hora actual

    var daylight = data.civilTwilightBegin;
    var nighlight = data.civilTwilightEnd;
    var offsetInHours = DateTime.now().timeZoneOffset;
    var sunriseTime = daylight.add(offsetInHours);
    var sunsetTime = nighlight.add(offsetInHours);
    var dateUTC = date.add(offsetInHours);
//    var now = DateTime.now();
    print("Daylight " + daylight.toString());
    print("Offset GMT " + offsetInHours.toString());
    print("===== SUNRISE " + sunriseTime.toString());
    print(' estoy en checkholiday **********************');

    switch (fileProvider.jodesh) {
      case "Elul":
        checkRoshHashana(date, sunsetTime);
        break;

      case "Tishrei":
        checkRoshHashana(date, sunsetTime);
        checkTzomGedalia(date, sunriseTime, sunsetTime);
        checkYomKipur(date, sunriseTime, sunsetTime);
        checksukkot(date, sunsetTime);
        break;

      case "Tevet":
        checkJanuca(date, sunsetTime);
        check10Tevet(date, sunriseTime, sunsetTime);
        break;

      case "Kislev":
        checkJanuca(date, sunsetTime);
        break;

      case "Shvat":
        checkTuBishvat();
        break;

      case "Adar I":
        checkPurim(date, sunriseTime, sunsetTime);
        break;

      case "Adar II":
        checkPurim(date, sunriseTime, sunsetTime);
        break;

      case "Adar":
        checkPurim(date, sunriseTime, sunsetTime);
        break;

      case "Nissan":
        checkPassover(date, sunsetTime);
        checkOmer(date, sunsetTime);
        break;

      case "Iyar":
        checkOmer(date, sunsetTime);
        break;

      case "Sivan":
        checkOmer(date, sunsetTime);
        checkShavuot(date, sunsetTime);
        break;

      case "Tamuz":
        check17Tamuz(date, sunriseTime, sunsetTime);
        break;

      case "Av":
        check9Beav(date, sunsetTime);
        break;
    }

    // checkRoshHashana(date, sunsetTime);
    // checkTzomGedalia(date, sunriseTime, sunsetTime);
    // checkYomKipur(date, sunriseTime, sunsetTime);
    // checksukkot(date, sunsetTime);
    // checkJanuca(date, sunsetTime);
    // check10Tevet(date, sunriseTime, sunsetTime);
    // checkTuBishvat();
    // checkPurim(date, sunriseTime, sunsetTime);
    // checkPassover(date, sunsetTime);
    // checkOmer(date, sunsetTime);
    // checkShavuot(date, sunsetTime);
    // check17Tamuz(date, sunriseTime, sunsetTime);
    // check9Beav(date, sunsetTime);
    swfestivity = false;
    swtzom = false;
  }

// ++++++++++++++++ check for Rosh Hashana **************************
  void checkRoshHashana(DateTime now, DateTime sunset) {
    print('[DEBUG] estoy en checkRoshHashana **********************');
    print('[DEBUG] mes ' + fileProvider.jodesh);
    print('[DEBUG] dia ' + fileProvider.yom.toString());
    print('[DEBUG] año ' + fileProvider.shana.toString());
    print('[DEBUG] leapyear ' + fileProvider.isleapyear.toString());
    print('[DEBUG] dia de la semana ' + dayofweek.toString());

    // aqui chequeo la fecha para ver si es año nuevo ***************
    if (fileProvider.jodesh == "Elul") {
      if (fileProvider.yom == 29 && now.isAfter(sunset)) {
        swfestivity = true;
        updateHoliday('assets/roshhashana.png', 'hemptytxt', 'shana_tova',
            'hemptytxt ', swfestivity, swtzom);
      } else {
        todayIsNotHoliday('assets/maguendavidyellow.png', 'hemptytxt', 'hemptytxt',
            'hemptytxt ', swfestivity, swtzom);
      }
    }

    if (fileProvider.jodesh == "Tishrei") {
      if (fileProvider.yom == 1 ||
          (fileProvider.yom == 2 && now.isBefore(sunset))) {
        swfestivity = true;
        updateHoliday('assets/roshhashana.png', 'hemptytxt', 'shana_tova',
            'hemptytxt', swfestivity, swtzom);
      } else {
        todayIsNotHoliday('assets/maguendavidyellow.png', 'hemptytxt', 'hemptytxt',
            'hemptytxt ', swfestivity, swtzom);
      }
    }
  }

//por default para Fluter el primer dia de la semana es el lunes
// por lo que el sabado es el dia 6
// ++++++++++++++++ check for Tzom Gedalia **************************

  void checkTzomGedalia(DateTime now, DateTime sunrise, DateTime sunset) {
    if (fileProvider.jodesh == "Tishrei") {
      if (fileProvider.yom == 3 &&
          (now.isAfter(sunrise) && now.isBefore(sunset))) {
        if (dayofweek == 6) {
          swtzom = true;
          updateHoliday('assets/emptyimage.png', 'tzomshabat1', 'tzomGedalia',
              'tzomshabat2', swfestivity, swtzom);
        } else {
          swtzom = true;
          updateHoliday('assets/emptyimage.png', 'hemptytxt', 'tzomGedalia',
              'hemptytxt', swfestivity, swtzom);
        }
      }
    }

    if (fileProvider.jodesh == "Tishrei") {
      if (fileProvider.yom == 4 &&
          (now.isAfter(sunrise) && now.isBefore(sunset))) {
        if (dayofweek == 7) {
          swtzom = true;
          updateHoliday('assets/emptyimage.png', 'Yzomshabat1', 'tzomGedalia',
              'Yzomshabat2', swfestivity, swtzom);
        } else {
          todayIsNotHoliday('assets/maguendavidyellow.png', 'hemptytxt',
              'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
        }
      }
    }
  }

// ++++++++++++++++ check for Yom Kipur **************************
  void checkYomKipur(DateTime now, DateTime sunrise, DateTime sunset) {
    if (fileProvider.jodesh == "Tishrei") {
      if ((fileProvider.yom == 9 && now.isAfter(sunset)) ||
          (fileProvider.yom == 10 && now.isBefore(sunset))) {
        swtzom = true;
        updateHoliday(
            'assets/emptyimage.png', 'hemptytxt', 'yomkipur', 'hemptytxt', swfestivity, swtzom);
      } else {
        todayIsNotHoliday('assets/maguendavidyellow.png', 'hemptytxt', 'hemptytxt',
            'hemptytxt ', swfestivity, swtzom);
      }
    }
  }

// ++++++++++++++++ check for Sukkot **************************
  void checksukkot(DateTime now, DateTime sunset) {
    print('now ' +
        now.millisecondsSinceEpoch.toString() +
        ' sunset ' +
        sunset.millisecondsSinceEpoch.toString());

    if (fileProvider.jodesh == "Tishrei") {
      if ((fileProvider.yom == 14 &&
              now.millisecondsSinceEpoch > sunset.millisecondsSinceEpoch) ||
          (fileProvider.yom > 14 && fileProvider.yom < 20) ||
          (fileProvider.yom == 20 && now.isBefore(sunset))) {
        swfestivity = true;
        updateHoliday('assets/sukkot.png', 'hemptytxt', 'sukkot', 'hemptytxt',
            swfestivity, swtzom);
      } else {
        if ((fileProvider.yom == 20 && now.isAfter(sunset)) ||
            (fileProvider.yom == 21 && now.isBefore(sunset))) {
          swfestivity = true;
          updateHoliday('assets/sukkot.png', 'hemptytxt', 'hoshanaraba',
              'hemptytxt', swfestivity, swtzom);
        } else {
          if ((fileProvider.yom == 21 && now.isBefore(sunset)) ||
              (fileProvider.yom == 22 && now.isAfter(sunset))) {
            swfestivity = true;
            updateHoliday('assets/sukkot.png', 'hemptytxt', 'sheminiatzeret',
                'hemptytxt', swfestivity, swtzom);
          } else {
            if ((fileProvider.yom == 22 && now.isBefore(sunset)) ||
                (fileProvider.yom == 23 && now.isAfter(sunset))) {
              swfestivity = true;
              updateHoliday('assets/sinchattorah.png', 'hemptytxt',
                  'sinchattorah', 'hemptytxt', swfestivity, swtzom);
            } else {
              todayIsNotHoliday('assets/maguendavidyellow.png', 'hemptytxt',
                  'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
            }
          }
        }
      }
    }
  }

  // ++++++++++++++++ check for Januca **************************

  void checkJanuca(DateTime now, DateTime sunset) {
    int endmonth = 0;

    if (fileProvider.jodesh == "Tevet") {
      if ((fileProvider.yom == 1 && fileProvider.yesterdayyom == 29) ||
          (fileProvider.yom == 2 && fileProvider.daybeforeyom == 29)) {
        endmonth = 1;
      } else {
        if ((fileProvider.yom == 1 && fileProvider.daybeforeyom == 30) ||
            (fileProvider.yom == 2 && fileProvider.daybeforeyom == 30)) {
          endmonth = 2;
        }
      }
    }

    if (fileProvider.jodesh == "Kislev") {
      if ((fileProvider.yom == 24 && now.isAfter(sunset)) ||
          (fileProvider.yom == 25 && now.isBefore(sunset))) {
        swfestivity = true;
        updateHoliday('assets/januquilladia1.png', 'hemptytxt', 'happyjanuca',
            'hemptytxt', swfestivity, swtzom);
      } else {
        if ((fileProvider.yom == 24 && now.isAfter(sunset)) ||
            (fileProvider.yom == 25 && now.isBefore(sunset))) {
          swfestivity = true;
          updateHoliday('assets/januquilladia2.png', 'hemptytxt', 'happyjanuca',
              'hemptytxt', swfestivity, swtzom);
        } else {
          if ((fileProvider.yom == 26 && now.isAfter(sunset)) ||
              (fileProvider.yom == 27 && now.isBefore(sunset))) {
            swfestivity = true;
            updateHoliday('assets/januquilladia3.png', 'hemptytxt',
                'happyjanuca', 'hemptytxt', swfestivity, swtzom);
          } else {
            if ((fileProvider.yom == 27 && now.isAfter(sunset)) ||
                (fileProvider.yom == 28 && now.isBefore(sunset))) {
              swfestivity = true;
              updateHoliday('assets/januquilladia4.png', 'hemptytxt',
                  'happyjanuca', 'hemptytxt', swfestivity, swtzom);
            } else {
              if ((fileProvider.yom == 28 && now.isAfter(sunset)) ||
                  (fileProvider.yom == 29 && now.isBefore(sunset))) {
                swfestivity = true;
                updateHoliday('assets/januquilladia5.png', 'hemptytxt',
                    'happyjanuca', 'hemptytxt', swfestivity, swtzom);
              } else {
                if ((fileProvider.yom == 29 && now.isAfter(sunset)) ||
                    (fileProvider.yom == 30 && now.isBefore(sunset))) {
                  swfestivity = true;
                  updateHoliday('assets/januquilladia6.png', 'hemptytxt',
                      'happyjanuca', 'hemptytxt', swfestivity, swtzom);
                } else {
                  if (fileProvider.yom == 30 && now.isAfter(sunset)) {
                    swfestivity = true;
                    updateHoliday('assets/januquilladia7.png', 'hemptytxt',
                        'happyjanuca', 'hemptytxt', swfestivity, swtzom);
                  }
                }
              }
            }
          }
        }
      }
    }

    if (fileProvider.jodesh == "Tevet") {
      if (fileProvider.yom == 1 && endmonth == 1 && now.isBefore(sunset)) {
        swfestivity = true;
        updateHoliday('assets/januquilladia6.png', 'hemptytxt', 'happyjanuca',
            'hemptytxt', swfestivity, swtzom);
      } else {
        if ((fileProvider.yom == 1 && endmonth == 1 && now.isAfter(sunset)) ||
            (fileProvider.yom == 2 && endmonth == 1 && now.isBefore(sunset))) {
          swfestivity = true;
          updateHoliday('assets/januquilladia7.png', 'hemptytxt', 'happyjanuca',
              'hemptytxt', swfestivity, swtzom);
        } else {
          if ((fileProvider.yom == 2 && endmonth == 1 && now.isAfter(sunset)) ||
              (fileProvider.yom == 3 &&
                  endmonth == 1 &&
                  now.isBefore(sunset))) {
            swfestivity = true;
            updateHoliday('assets/januquillacompleta.png', 'hemptytxt',
                'happyjanuca', 'hemptytxt', swfestivity, swtzom);
          } else {
            if (fileProvider.yom == 1 && endmonth == 2 && now.isAfter(sunset)) {
              swfestivity = true;
              updateHoliday('assets/januquilladia7.png', 'hemptytxt',
                  'happyjanuca', 'hemptytxt', swfestivity, swtzom);
            } else {
              if ((fileProvider.yom == 1 &&
                      endmonth == 2 &&
                      now.isAfter(sunset)) ||
                  (fileProvider.yom == 2 &&
                      endmonth == 2 &&
                      now.isBefore(sunset))) {
                swfestivity = true;
                updateHoliday('assets/januquillacompleta.png', 'hemptytxt',
                    'happyjanuca', 'hemptytxt', swfestivity, swtzom);
              } else {
                todayIsNotHoliday('assets/maguendavidyellow.png', 'hemptytxt',
                    'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
              }
            }
          }
        }
      }
    }
  }

//por default para Fluter el primer dia de la semana es el lunes
// por lo que el sabado es el dia 6
// ++++++++++++++++ check for Tzom 10 of TEVET **************************

  void check10Tevet(DateTime now, DateTime sunrise, DateTime sunset) {
    if (fileProvider.jodesh == "Tevet") {
      if (fileProvider.yom == 10 &&
          (now.isAfter(sunrise) && now.isBefore(sunset))) {
        if (dayofweek == 6) {
          swtzom = true;
          updateHoliday('assets/emptyimage.png', 'tzomshabat1', 'tzom10Tevet',
              'tzomshabat2', swfestivity, swtzom);
        } else {
          swtzom = true;
          updateHoliday('assets/emptyimage.png', 'hemptytxt', 'tzom10Tevet',
              'hemptytxt', swfestivity, swtzom);
        }
      }
    }

    if (fileProvider.jodesh == "Tevet") {
      if (fileProvider.yom == 11 &&
          (now.isAfter(sunrise) && now.isBefore(sunset))) {
        if (dayofweek == 7) {
          swtzom = true;
          updateHoliday('assets/emptyimage.png', 'Yzomshabat1', 'tzom10Tevet',
              'Yzomshabat2', swfestivity, swtzom);
        } else {
          todayIsNotHoliday('assets/maguendavidyellow.png', 'hemptytxt',
              'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
        }
      }
    }
  }

  // ++++++++++++++++ check for Tu Bishvat **************************

  void checkTuBishvat() {
    if (fileProvider.jodesh == "Shvat") {
      if (fileProvider.yom == 15) {
        swfestivity = true;
        updateHoliday('assets/tubishvat.png', 'hemptytxt', 'tubishvat',
            'hemptytxt', swfestivity, swtzom);
      } else {
        todayIsNotHoliday('assets/maguendavidyellow.png', 'hemptytxt', 'hemptytxt',
            'hemptytxt ', swfestivity, swtzom);
      }
    }
  }

  // *************** Check for Purim ++++++++++++++++++++++++++++++++

  void checkPurim(DateTime now, DateTime sunrise, DateTime sunset) {
    if (fileProvider.isleapyear) {
      if (fileProvider.jodesh == "Adar I") {
        if (fileProvider.yom == 14) {
          swfestivity = true;
          updateHoliday('assets/tpurimkatan.png', 'hemptytxt', 'purimkatan',
              'hemptytxt', swfestivity, swtzom);
        } else {
          if (fileProvider.yom == 15) {
            swfestivity = true;
            updateHoliday('assets/purimkatan.png', 'hemptytxt',
                'sushanpurimkatan', 'hemptytxt', swfestivity, swtzom);
          } else {
            todayIsNotHoliday('assets/maguendavidyellow.png', 'hemptytxt',
                'hemptytxt', 'hemptytxt', swfestivity, swtzom);
          }
        }
      }
    }

    if (fileProvider.isleapyear) {
      if (fileProvider.jodesh == "Adar II") {
        todayTzomEsther(now, sunrise, sunset);
        print("[PURIM]  istzomesther regresando1 " + istzomesther.toString());

        if (istzomesther == 0) {
          if (fileProvider.yom == 13 &&
              (now.isAfter(sunrise) && now.isBefore(sunset))) {
            swtzom = true;
            updateHoliday('assets/emptyimage.png', 'hemptytxt', 'tzomEsther',
                'hemptytxt', swfestivity, swtzom);
          } else {
            if (fileProvider.yom == 14) {
              swfestivity = true;
              updateHoliday('assets/purimnormal.png', 'hemptytxt', 'purim',
                  'hemptytxt', swfestivity, swtzom);
            } else {
              if (fileProvider.yom == 15) {
                swfestivity = true;
                updateHoliday('assets/purimnormal.png', 'hemptytxt',
                    'sushanpurim', 'hemptytxt', swfestivity, swtzom);
              } else {
                todayIsNotHoliday('assets/maguendavidyellow.png', 'hemptytxt',
                    'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
              }
            }
          }
        } else {
          if (istzomesther == 1) {
            if (fileProvider.yom == 13 &&
                (now.isAfter(sunrise) && now.isBefore(sunset))) {
              if (dayofweek == 6) {
                swtzom = true;
                updateHoliday('assets/emptyimage.png', 'tzomshabat1',
                    'tzomesthershabat', 'tzomesthershabatadarii', swfestivity, swtzom);
                istzomesther = 0;
              }
            }
          }
        }
      }
    }

    if (!fileProvider.isleapyear) {
      if (fileProvider.jodesh == "Adar") {
        todayTzomEsther(now, sunrise, sunset);
        print("[PURIM]  istzomesther regresando2 " + istzomesther.toString());

        if (istzomesther == 0) {
          if (fileProvider.yom == 13 &&
              (now.isAfter(sunrise) && now.isBefore(sunset))) {
            swtzom = true;
            updateHoliday('assets/emptyimage.png', 'hemptytxt', 'tzomEsther',
                'hemptytxt', swfestivity, swtzom);
          } else {
            if (fileProvider.yom == 14) {
              swfestivity = true;
              updateHoliday('assets/purimnormal.png', 'hemptytxt', 'purim',
                  'hemptytxt', swfestivity, swtzom);
            } else {
              if (fileProvider.yom == 15) {
                swfestivity = true;
                updateHoliday('assets/purimnormal.png', 'hemptytxt',
                    'sushanpurim', 'hemptytxt', swfestivity, swtzom);
              } else {
                todayIsNotHoliday('assets/maguendavidyellow.png', 'hemptytxt',
                    'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
              }
            }
          }
        }
        if (istzomesther == 1) {
          if (fileProvider.yom == 13 &&
              (now.isAfter(sunrise) && now.isBefore(sunset))) {
            swtzom = true;
            if (dayofweek == 6) {
              updateHoliday('assets/emptyimage.png', 'tzomshabat1',
                  'tzomesthershabat', 'tzomesthershabatadar', swfestivity, swtzom);
            }
          }
        }
      }
    }
  }

  //++++++++++++++++++++++ check fot Tzom Esther +++++++++++++++++++++

  void todayTzomEsther(DateTime now, DateTime sunrise, DateTime sunset) {
    if (fileProvider.isleapyear) {
      if (fileProvider.jodesh == "Adar II") {
        if (fileProvider.yom == 11 &&
            dayofweek == 4 &&
            (now.isAfter(sunrise) && now.isBefore(sunset))) {
          swtzom = true;
          updateHoliday('assets/emptyimage.png', 'tzomEsther',
              'tzomestheron11adarii', 'hemptytxt', swfestivity, swtzom);
          istzomesther = 1;
        } else {
          if (fileProvider.yom == 13 &&
              dayofweek == 7 &&
              (now.isAfter(sunrise) && now.isBefore(sunset))) {
            istzomesther = 1;
          }
        }
      }
    }

    if (!fileProvider.isleapyear) {
      if (fileProvider.jodesh == "Adar") {
        if (fileProvider.yom == 11 &&
            dayofweek == 4 &&
            (now.isAfter(sunrise) && now.isBefore(sunset))) {
          swtzom = true;
          updateHoliday('assets/emptyimage.png', 'tzomEsther',
              'tzomestheron11adar', 'hemptytxt', swfestivity, swtzom);
          istzomesther = 1;
        } else {
          if (fileProvider.yom == 13 &&
              dayofweek == 7 &&
              (now.isAfter(sunrise) && now.isBefore(sunset))) {
            istzomesther = 1;
          }
        }
      }
    }
  }

  //++++++++++++++++++++++ check for Passover +++++++++++++++++++++
  void checkPassover(DateTime now, DateTime sunset) {
    if (fileProvider.jodesh == "Nissan") {
      if (fileProvider.yom == 14 && now.isAfter(sunset)) {
        swfestivity = true;
        updateHoliday('assets/pesaj.png', 'hemptytxt', 'pesaje1seder',
            'hemptytxt', swfestivity, swtzom);
      } else {
        if (fileProvider.yom == 15 && now.isBefore(sunset)) {
          swfestivity = true;
          updateHoliday('assets/pesaj.png', 'hemptytxt', 'pesaj', 'hemptytxt',
              swfestivity, swtzom);
        } else {
          if (fileProvider.yom == 15 && now.isAfter(sunset)) {
            swfestivity = true;
            updateHoliday('assets/pesaj.png', 'hemptytxt', 'pesaj2seder',
                'hemptytxt', swfestivity, swtzom);
          } else {
            if (fileProvider.yom == 16 && now.isBefore(sunset)) {
              swfestivity = true;
              updateHoliday('assets/pesaj.png', 'hemptytxt', 'pesaj1omer',
                  'hemptytxt', swfestivity, swtzom);
            } else {
              if ((fileProvider.yom == 16 && now.isAfter(sunset)) ||
                  (fileProvider.yom == 17 && now.isBefore(sunset))) {
                swfestivity = true;
                updateHoliday('assets/pesaj.png', 'hemptytxt', 'pesaj2omer',
                    'hemptytxt', swfestivity, swtzom);
              } else {
                if ((fileProvider.yom == 17 && now.isAfter(sunset)) ||
                    (fileProvider.yom == 18 && now.isBefore(sunset))) {
                  swfestivity = true;
                  updateHoliday('assets/pesaj.png', 'hemptytxt', 'pesaj3omer',
                      'hemptytxt', swfestivity, swtzom);
                } else {
                  if ((fileProvider.yom == 18 && now.isAfter(sunset)) ||
                      (fileProvider.yom == 19 && now.isBefore(sunset))) {
                    swfestivity = true;
                    updateHoliday('assets/pesaj.png', 'hemptytxt', 'pesaj4omer',
                        'hemptytxt', swfestivity, swtzom);
                  } else {
                    if ((fileProvider.yom == 19 && now.isAfter(sunset)) ||
                        (fileProvider.yom == 20 && now.isBefore(sunset))) {
                      swfestivity = true;
                      updateHoliday('assets/pesaj.png', 'hemptytxt',
                          'pesaj5omer', 'hemptytxt', swfestivity, swtzom);
                    } else {
                      if ((fileProvider.yom == 20 && now.isAfter(sunset)) ||
                          (fileProvider.yom == 21 && now.isBefore(sunset))) {
                        swfestivity = true;
                        updateHoliday('assets/pesaj.png', 'hemptytxt',
                            'pesaj6omer', 'hemptytxt', swfestivity, swtzom);
                      } else {
                        if ((fileProvider.yom == 21 && now.isAfter(sunset)) ||
                            (fileProvider.yom == 22 && now.isBefore(sunset))) {
                          swfestivity = true;
                          updateHoliday('assets/pesaj.png', 'hemptytxt',
                              'pesaj7omer', 'hemptytxt', swfestivity, swtzom);
                        } else {
                          if ((fileProvider.yom == 22 && now.isAfter(sunset)) ||
                              (fileProvider.yom == 23 &&
                                  now.isBefore(sunset))) {
                            swfestivity = true;
                            updateHoliday('assets/pesaj.png', 'hemptytxt',
                                'pesaj8omer', 'hemptytxt', swfestivity, swtzom);
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

//++++++++++++++++++++++ check for Omer +++++++++++++++++++++
  void checkOmer(DateTime now, DateTime sunset) {
    int omerday = 0;
    if (fileProvider.jodesh == "Nissan") {
      for (int day = 23; day < 31; day++) {
        if (((fileProvider.yom == day && now.isAfter(sunset)) ||
            (fileProvider.yom == (day + 1) && now.isBefore(sunset)))) {
          swfestivity = true;
          omerday = day - 14;
          updateHoliday(
              'assets/emptyimage.png',
              'hemptytxt',
              ('omerday' + ' ' + omerday.toString()),
              'hemptytxt',
              swfestivity,
              swtzom);
        }
      }
    }

    if (fileProvider.jodesh == "Iyar") {
      if ((fileProvider.yom == 1 && now.isBefore(sunset))) {
        swfestivity = true;
        omerday = 16;
        updateHoliday(
            'assets/emptyimage.png',
            'hemptytxt',
            ('omerday' + ' ' + omerday.toString()),
            'hemptytxt',
            swfestivity,
            swtzom);
      }
    }

    if (fileProvider.jodesh == "Iyar") {
      for (int day = 1; day < 17; day++) {
        if (((fileProvider.yom == day && now.isAfter(sunset)) ||
            (fileProvider.yom == (day + 1) && now.isBefore(sunset)))) {
          swfestivity = true;
          omerday = day + 16;
          updateHoliday(
              'assets/emptyimage.png',
              'hemptytxt',
              ('omerday' + ' ' + omerday.toString()),
              'hemptytxt',
              swfestivity,
              swtzom);
        }
      }
    }

    if (fileProvider.jodesh == "Iyar") {
      if (((fileProvider.yom == 17 && now.isAfter(sunset)) ||
          (fileProvider.yom == 18 && now.isBefore(sunset)))) {
        swfestivity = true;
        updateHoliday('assets/lagbaomer.png', 'hemptytxt', 'pesaj33omer',
            'hemptytxt', swfestivity, swtzom);
      }
    }

    if (fileProvider.jodesh == "Iyar") {
      for (int day = 18; day < 30; day++) {
        if (((fileProvider.yom == day && now.isAfter(sunset)) ||
            (fileProvider.yom == (day + 1) && now.isBefore(sunset)))) {
          swfestivity = true;
          omerday = day + 16;
          updateHoliday(
              'assets/emptyimage.png',
              'hemptytxt',
              ('omerday' + ' ' + omerday.toString()),
              'hemptytxt',
              swfestivity,
              swtzom);
        }
      }
    }

    if (fileProvider.jodesh == "Sivan") {
      if ((fileProvider.yom == 1 && now.isBefore(sunset))) {
        swfestivity = true;
        omerday = 45;
        updateHoliday(
            'assets/emptyimage.png',
            'hemptytxt',
            ('omerday' + ' ' + omerday.toString()),
            'hemptytxt',
            swfestivity,
            swtzom);
      }
    }

    if (fileProvider.jodesh == "Sivan") {
      for (int day = 1; day < 5; day++) {
        if (((fileProvider.yom == day && now.isAfter(sunset)) ||
            (fileProvider.yom == (day + 1) && now.isBefore(sunset)))) {
          swfestivity = true;
          omerday = day + 45;
          updateHoliday(
              'assets/emptyimage.png',
              'hemptytxt',
              ('omerday' + ' ' + omerday.toString()),
              'hemptytxt',
              swfestivity,
              swtzom);
        }
      }
    }
  }

//++++++++++++++++++++++ check for Shavuot +++++++++++++++++++++
  void checkShavuot(DateTime now, DateTime sunset) {
    if (fileProvider.jodesh == "Sivan") {
      if ((fileProvider.yom == 5 && now.isAfter(sunset)) ||
          (fileProvider.yom == 6 && now.isBefore(sunset))) {
        swfestivity = true;
        updateHoliday('assets/shavuot.png', 'hemptytxt', 'shavuot', 'hemptytxt',
            swfestivity, swtzom);
      }
    }
  }

// ++++++++++++++++ check for fast of 17 of tamuz **************************
  void check17Tamuz(DateTime now, DateTime sunrise, DateTime sunset) {
    if (fileProvider.jodesh == "Tamuz") {
      if (fileProvider.yom == 17 &&
          (now.isAfter(sunrise) && now.isBefore(sunset))) {
        if (dayofweek == 6) {
          swtzom = true;
          updateHoliday('assets/emptyimage.png', 'tzomshabat1', 'tzom17tamuz',
              'tzomshabat2',swfestivity, swtzom);
        } else {
          swtzom = true;
          updateHoliday('assets/emptyimage.png', 'hemptytxt', 'tzom17tamuz',
              'hemptytxt',swfestivity, swtzom);
        }
      }
    }

    if (fileProvider.jodesh == "Tamuz") {
      if (fileProvider.yom == 18 &&
          (now.isAfter(sunrise) && now.isBefore(sunset))) {
        if (dayofweek == 7) {
          swtzom = true;
          updateHoliday('assets/emptyimage.png', 'Yzomshabat1', 'tzom17tamuz',
              'Yzomshabat2',swfestivity, swtzom);
        } else {
          todayIsNotHoliday('assets/maguendavidyellow.png', 'hemptytxt',
              'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
        }
      }
    }
  }

// ++++++++++++++++ check for fast of 9 of av **************************
  void check9Beav(DateTime now, DateTime sunset) {
    if (fileProvider.jodesh == "Av") {
      if (fileProvider.yom == 8 && dayofweek == 5 && now.isAfter(sunset)) {
        swtzom = true;
        updateHoliday('assets/emptyimage.png', 'tzomshabat1', 'tzom9beavshabat',
            'tzomshabat2',swfestivity, swtzom);
      } else {
        if (fileProvider.yom == 9 && dayofweek == 6 && now.isBefore(sunset)) {
          swtzom = true;
          updateHoliday('assets/emptyimage.png', 'tzomshabat1', 'tzom9beavshabat',
              'tzom9beavshabat2',swfestivity, swtzom);
        } else {
          if ((fileProvider.yom == 9 &&
                  dayofweek == 6 &&
                  now.isAfter(sunset)) ||
              (fileProvider.yom == 10 &&
                  dayofweek == 7 &&
                  now.isBefore(sunset))) {
            swtzom = true;
            updateHoliday('assets/emptyimage.png', 'hemptytxt', 'tzom9Beav',
                'hemptytxt',swfestivity, swtzom);
          } else {
            if ((fileProvider.yom == 8 &&
                    dayofweek != 5 &&
                    now.isAfter(sunset)) ||
                (fileProvider.yom == 9 &&
                    dayofweek != 6 &&
                    now.isBefore(sunset))) {
              swtzom = true;
              updateHoliday('assets/emptyimage.png', 'hemptytxt', 'tzom9Beav',
                  'hemptytxt',swfestivity, swtzom);
            } else {
              todayIsNotHoliday('assets/maguendavidyellow.png', 'hemptytxt',
                  'hemptytxt', 'hemptytxt ', swfestivity, swtzom);
            }
          }
        }
      }
    }
  }

//   //++++++++++ metodo que maneja los dias de ayuno +++++++++++++++
//   void updateHoliday(String himage, String hline1, hline2, hline3) {
//     print(' estoy updateHoliday ' + himage + ' ' + hline2);
//
//     setState(() {
//       headerimage = himage;
// //    holidayline1 = getTranslated(context, hline1);
// //    holidayline2 = getTranslated(context, hline2);
// //    holidayline3 = getTranslated(context, hline3);
//       holidayline1 = hline1;
//       holidayline2 = hline2;
//       holidayline3 = hline3;
//     });
//   }

  void updateHoliday(String image, String line1, String line2, String line3,
      bool swfestivityst, bool swtzomst) {
    setState(() {
      this.headerimage = image;
      this.holidayline1 =  getTranslated(context, line1);
      this.holidayline2 =  getTranslated(context, line2);
      this.holidayline3 =  getTranslated(context, line3);
      this.swfestivity = swfestivityst;
      this.swtzom = swtzomst;
    });
  }

  //++++++++++ metodo que maneja los dias  NO fectivos +++++++++++++++
  void todayIsNotHoliday(String image, String line1, String line2, String line3,
      bool swfestivityst, bool swtzomst) {
    print('swfestiviti xxxxxxxxxxxxx' + swfestivity.toString());
    print('swtzom xxxxxxxxxxxxxxxxxx' + swtzom.toString());

    if (!swfestivity && !swtzom) {
      setState(() {
        this.headerimage = 'assets/splashlogo.gif';
        this.holidayline1 = ' ';
        this.holidayline2 = ' ';
        this.holidayline3 = ' ';
        this.swfestivity = swfestivityst;
        this.swtzom = swtzomst;
      });
    }
  }


  Future<Point> _getCurrentlocation() async {
    var completer = Completer<Point>();

    Point point;
    try {
      final Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude;
      long = position.longitude;
      point = Point(position.latitude, position.longitude);

      print("ANDRES 1  " + position.toString());
      print("ANDRES 1.5  latitud $lat   longitud  $long");
    } on Exception catch (e) {
      lat = 0;
      long = 0;
      print('[DEBUG] falla de geolocation ' + e.toString());
      point = Point(0.0, 0.0);
      print("[ANDRES] no authorization granted to obtain the position ");
    }

    completer.complete(point);

    return completer.future;
    //_getSunriseSunset();
  }

// ***************  get sunrise & sunset ********************
  Future<SunriseSunsetData> _getSunriseSunset(Point point) async {
    var completer = Completer<SunriseSunsetData>();
    try {
      final response = await SunriseSunset.getResults(

// ******** el parametro DateTime se utiliza solo para testear la app,
// una vez en produccion, se debe eliminar

//          date: DateTime(2020, 09, 19, 22),
          latitude: point.x,
          longitude: point.y);

      if (response.success) {
        completer.complete(response.data);
      } else {
        print(response.error);
      }
    } catch (err) {
      print("Failed to get data.");
      print(err);
    }

    return completer.future;
  }
}
