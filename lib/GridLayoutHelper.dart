import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class GridLayoutHelper {
  double cellWidth;
  int numberOfCells;
  bool isLargeScreen;
  double aspectRatio;
  bool needsLargeAppBar = false;
  String deviceType;

  void calculatelayout(BuildContext context, Orientation orientation) {
    var screenSize = MediaQuery.of(context).size;
    isLargeScreen = Device.get().isTablet;

    if (isLargeScreen) {
      if (orientation == Orientation.portrait) {
        needsLargeAppBar = true;
        deviceType = 'LP';
        numberOfCells = 5;
      } else {
        numberOfCells = 7;
        needsLargeAppBar = false;
        deviceType = 'LL';
      }
    } else {
      numberOfCells = 3;
      deviceType = 'NL';
    }

    cellWidth = screenSize.width / numberOfCells;

    var mainBlockHeight = cellWidth * 0.8;
    aspectRatio = cellWidth / (mainBlockHeight + 65);
  }

// void cellSize(BuildContext context, Orientation orientation) {
//   var screenSize = MediaQuery.of(context).size;
//
//   widecount = (screenWidth.floor() / 130).floor();
//   highcount = (screenHeight.floor() / 130).floor();
//
//   print('[DEBUG COUNT ORIGINAL SAMI] cards portrait $widecount '
//       'cards landscape'
//       ' $highcount' +
//       ' y es largescreen $isLargeScreen');
//
//   if (isLargeScreen) {
//     if (orientation == Orientation.portrait) {
//       isLargeScreenPortrait = true;
//       phoneTypePoss = 'LP';
//       aspectRatio = 127/141;
//     } else {
//       isLargeScreenPortrait = false;
//       phoneTypePoss = 'LL';
//       aspectRatio = 127/141;
//     }
//   } else {
//     phoneTypePoss = 'NL';
//     aspectRatio = 127/141;
//   }
//
//   // if (orientation == Orientation.portrait && widecount < 3) {
//   //   widecount = widecount;
//   // }
//   //
//   // if (orientation != Orientation.portrait && widecount < 6) {
//   //   widecount = 3;
//   // }
//   //
//   // if (orientation == Orientation.portrait && widecount == 5) {
//   //   widecount = 4;
//   // }
//   //
//   // if (orientation == Orientation.portrait && widecount > 5) {
//   //   widecount = widecount - 1;
//   // }
//   //
//   // if (orientation != Orientation.portrait &&
//   //     phoneTypePoss != 'NL' &&
//   //     widecount < 10) {
//   //   //widecount = widecount - 2;
//   //   widecount = widecount - 4;
//   // }
//   //
//   // if (orientation != Orientation.portrait && widecount > 9) {
//   //   // widecount = widecount - 3;
//   //   widecount = widecount - 7;
//   // }
//
//   print('[DEBUG COUNT SAMI] cards portrait $widecount '
//       'cards landscape'
//       ' $highcount');
//
//   print('[DEBUG SAMI ROUND] redondeado a 0 decimales Ancho ' +
//       widecount.round().toString() +
//       ' alto ' +
//       highcount.round().toString());
//
//   print('DEBUG SAMI   alto $screenHeight ancho $screenWidth');
//
//   print('[DEBUG SAMI] Es Larga la Pantalla?  ' + isLargeScreen.toString());
//
//   print('[DEBUG SAMI] is large screen and portrait $isLargeScreenPortrait');
// }

}
