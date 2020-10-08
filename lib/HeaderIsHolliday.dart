import 'package:flutter/material.dart';

class HeaderIsHolliday extends StatefulWidget {
  final String headerimage;
  final String holidayline1;
  final String holidayline2;
  final String holidayline3;
  final bool swfestivity;
  final bool swtzom;

  HeaderIsHolliday(this.headerimage, this.holidayline1, this.holidayline2,
      this.holidayline3, this.swfestivity, this.swtzom);

  @override
  HeaderIsHollidatState createState() => HeaderIsHollidatState();
}

class HeaderIsHollidatState extends State<HeaderIsHolliday> {
  String headerimagest;
  String holidayline1st;
  String holidayline2st;
  String holidayline3st;
  bool swfestivityst;
  bool swtzomst;

  @override
  void initState() {
    headerimagest = widget.headerimage;
    holidayline1st = widget.holidayline1;
    holidayline2st = widget.holidayline2;
    holidayline3st= widget.holidayline3;
    swfestivityst = widget.swfestivity;
    swtzomst = widget.swtzom;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

   void isHoliday() {
    print(' estoy isHoliday ' +
        headerimagest +
        ' ' +
        holidayline2st);
    print('swfestiviti isHolliday ' + swfestivity.toString());
    print('swtzom isHolliday ' + swtzom.toString());

    setState(() {
      headerimage = headerimagest;
//    holidayline1 = getTranslated(context, hline1);
//    holidayline2 = getTranslated(context, hline2);
//    holidayline3 = getTranslated(context, hline3);
      holidayline1 = headerHolliday.holidayline1;
      holidayline2 = headerHolliday.holidayline2;
      holidayline3 = headerHolliday.holidayline3;
    });
  }

  void todayIsNotHoliday(String himage, String hline1, hline2, hline3,
      bool swfestivity, bool swtzom) {
    print('swfestiviti todayIsNotHolliday ' + swfestivity.toString());
    print('swtzom todayIsNotHolliday ' + swtzom.toString());

    if (!swfestivity && !swtzom) {
      headerimage = 'assets/maguendavidyellow.png';
      holidayline1 = ' ';
      holidayline2 = ' ';
      holidayline3 = ' ';
    }
  }
}
