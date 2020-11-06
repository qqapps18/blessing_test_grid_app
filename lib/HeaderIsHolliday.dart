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
  var fileProvider;

  @override
  _HeaderIsHollidaytState createState() => _HeaderIsHollidaytState(this.fileProvider);

  HeaderIsHolliday(FileProvider this.fileProvider);
}

class _HeaderIsHollidaytState extends State<HeaderIsHolliday> {

  String headerimage = 'assets/headerlogosinbacground.png';
  String holidayline1 = ' ';
  String holidayline2 = ' ';
  String holidayline3 = ' ';
  bool swfestivity = false;
  bool swtzom = false;
  String datehebrew = '';
  DateTime date = DateTime.now();
  int dayofweek = 0;
  double lat = 0;
  double long = 0;
  int istzomesther = 0;

  var fileProvider;
  DateTime dateUTC;

  _HeaderIsHollidaytState(FileProvider this.fileProvider);

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
          fit: BoxFit.contain,
        ),
// ************* color de fondo del enbabezado ***********
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(500, 254, 140, 46),
              Color.fromARGB(500, 253, 200, 11),
              Color.fromARGB(500, 254, 140, 46),
            ],
          )
//        color: Colors.amber,
      ),
    );
  }

  /* CHECK HOLIDAYS */

  void checkHoliday(SunriseSunsetData data) {
    print('CheckHoliday holidayline1 ' + holidayline1 + '===========');

    print('[DEBUG] estoy en checkRoshHashana **********************');
    print('[DEBUG] mes ' + fileProvider.jodesh);
    print ('[DEBUG] numero del mes '+ fileProvider.numjodesh.toString());
    print('[DEBUG] dia ' + fileProvider.yom.toString());
    print('[DEBUG] año ' + fileProvider.shana.toString());
    print('[DEBUG] leapyear ' + fileProvider.isleapyear.toString());
    print('[DEBUG] dia de la semana ' + dayofweek.toString());

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

// orden de los mese a chequear
//   1  Nisán
//   2  Iyar
//   3  Siván
//   4  Tamuz
//   5  Av
//   6  Elul
//   7  Tishrei
//   8  Jeshván
//   9  Kislev
//  10   Tevet
//  11   Shevat
//  12   Adar
//  13   Adar II

    switch (fileProvider.numjodesh) {
      case 6:
        checkRoshHashana(date, sunsetTime);
        break;

      case 7:
        checkRoshHashana(date, sunsetTime);
        checkTzomGedalia(date, sunriseTime, sunsetTime);
        checkYomKipur(date, sunriseTime, sunsetTime);
        checksukkot(date, sunsetTime);
        break;

      case 9:
        checkJanuca(date, sunsetTime);
        break;

      case 10:
        checkJanuca(date, sunsetTime);
        check10Tevet(date, sunriseTime, sunsetTime);
        break;

      case 11:
        checkTuBishvat();
        break;

      case 12:
        checkPurim(date, sunriseTime, sunsetTime);
        break;

      case 13:
        checkPurim(date, sunriseTime, sunsetTime);
        break;

      case 12:
        checkPurim(date, sunriseTime, sunsetTime);
        break;

      case 1:
        checkPassover(date, sunsetTime);
        checkOmer(date, sunsetTime);
        break;

      case 2:
        checkOmer(date, sunsetTime);
        break;

      case 3:
        checkOmer(date, sunsetTime);
        checkShavuot(date, sunsetTime);
        break;

      case 4:
        check17Tamuz(date, sunriseTime, sunsetTime);
        break;

      case 5:
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
 // aqui chequeo la fecha para ver si es año nuevo ***************
    if (fileProvider.numjodesh == 6) {
      if (fileProvider.yom == 29 && now.isAfter(sunset)) {
        swfestivity = true;
        updateHoliday('assets/roshhashana.png', 'hemptytxt', 'shana_tova',
            'hemptytxt ', swfestivity, swtzom);
      } else {
        todayIsNotHoliday('assets/maguendavidyellow.png', 'hemptytxt', 'hemptytxt',
            'hemptytxt ', swfestivity, swtzom);
      }
    }

    if (fileProvider.numjodesh == 7) {
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
    if (fileProvider.numjodesh == 7) {
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

    if (fileProvider.numjodesh == 7) {
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
    if (fileProvider.numjodesh == 7) {
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

    if (fileProvider.numjodesh == 7) {
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

    if (fileProvider.numjodesh == 10) {
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

    if (fileProvider.numjodesh == 9) {
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

    if (fileProvider.numjodesh == 10) {
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
    if (fileProvider.numjodesh == 10) {
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

    if (fileProvider.numjodesh == 10) {
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
    if (fileProvider.numjodesh == 11) {
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
      if (fileProvider.numjodesh == 12) {
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
      if (fileProvider.numjodesh == 13) {
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
      if (fileProvider.numjodesh == 12) {
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
      if (fileProvider.numjodesh == 13) {
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
      if (fileProvider.jodesh == 12) {
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
    if (fileProvider.numjodesh == 1) {
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
    if (fileProvider.numjodesh == 1) {
      for (int day = 23; day < 31; day++) {
        if (((fileProvider.yom == day && now.isAfter(sunset)) ||
            (fileProvider.yom == (day + 1) && now.isBefore(sunset)))) {
          swfestivity = true;
          omerday = day - 14;
          print('[DEBUG OMER $omerday');
          updateHoliday(
              'assets/headerlogosinbacground.png',
              'hemptytxt',
              ('pesaj$omerday'+ 'omer'),
//              ('omerday' + ' ' + omerday.toString()),
              'hemptytxt',
              swfestivity,
              swtzom);
        }
      }
    }

    if (fileProvider.numjodesh == 2) {
      if ((fileProvider.yom == 1 && now.isBefore(sunset))) {
        swfestivity = true;
        omerday = 16;
        print('[DEBUG OMER $omerday');
        updateHoliday(
            'assets/headerlogosinbacground.png',
            'hemptytxt',
            ('pesaj$omerday'+ 'omer'),
//            ('omerday' + ' ' + omerday.toString()),
            'hemptytxt',
            swfestivity,
            swtzom);
      }
    }

    if (fileProvider.numjodesh == 2) {
      for (int day = 1; day < 17; day++) {
        if (((fileProvider.yom == day && now.isAfter(sunset)) ||
            (fileProvider.yom == (day + 1) && now.isBefore(sunset)))) {
          swfestivity = true;
          omerday = day + 16;
          print('[DEBUG OMER $omerday');
          updateHoliday(
              'assets/headerlogosinbacground.png',
              'hemptytxt',
              ('pesaj$omerday'+ 'omer'),
//              ('omerday' + ' ' + omerday.toString()),
              'hemptytxt',
              swfestivity,
              swtzom);
        }
      }
    }

    if (fileProvider.numjodesh == 2) {
      if (((fileProvider.yom == 17 && now.isAfter(sunset)) ||
          (fileProvider.yom == 18 && now.isBefore(sunset)))) {
        swfestivity = true;
        updateHoliday('assets/lagbaomer.png', 'hemptytxt', 'pesaj33omer',
            'hemptytxt', swfestivity, swtzom);
      }
    }

    if (fileProvider.numjodesh == 2) {
      for (int day = 18; day < 30; day++) {
        if (((fileProvider.yom == day && now.isAfter(sunset)) ||
            (fileProvider.yom == (day + 1) && now.isBefore(sunset)))) {
          swfestivity = true;
          omerday = day + 16;
          print('[DEBUG OMER $omerday');
          updateHoliday(
              'assets/headerlogosinbacground.png',
              'hemptytxt',
              ('pesaj$omerday'+ 'omer'),
//              ('omerday' + ' ' + omerday.toString()),
              'hemptytxt',
              swfestivity,
              swtzom);
        }
      }
    }

    if (fileProvider.numjodesh == 3) {
      if ((fileProvider.yom == 1 && now.isBefore(sunset))) {
        swfestivity = true;
        omerday = 45;
        print('[DEBUG OMER $omerday');
        updateHoliday(
            'assets/headerlogosinbacground.png',
            'hemptytxt',
            ('pesaj$omerday'+ 'omer'),
//            ('omerday' + ' ' + omerday.toString()),
            'hemptytxt',
            swfestivity,
            swtzom);
      }
    }

    if (fileProvider.numjodesh == 3) {
      for (int day = 1; day < 5; day++) {
        if (((fileProvider.yom == day && now.isAfter(sunset)) ||
            (fileProvider.yom == (day + 1) && now.isBefore(sunset)))) {
          swfestivity = true;
          omerday = day + 45;
          print('[DEBUG OMER $omerday');
          updateHoliday(
              'assets/headerlogosinbacground.png',
              'hemptytxt',
              ('pesaj$omerday'+ 'omer'),
//              ('omerday' + ' ' + omerday.toString()),
              'hemptytxt',
              swfestivity,
              swtzom);
        }
      }
    }
  }

//++++++++++++++++++++++ check for Shavuot +++++++++++++++++++++
  void checkShavuot(DateTime now, DateTime sunset) {
    if (fileProvider.numjodesh == 3) {
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
    if (fileProvider.numjodesh == 4) {
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

    if (fileProvider.numjodesh == 4) {
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
    if (fileProvider.numjodesh == 5) {
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
        this.headerimage = 'assets/headerlogosinbacground.png';
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
