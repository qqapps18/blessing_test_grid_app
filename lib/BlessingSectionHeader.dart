import 'package:flutter/material.dart';

// esta clase va a poner los titulos de las secciones
class BlessingSectionHeader extends StatelessWidget {
  final Color backgroundColor;
  final String headerTitle;

  BlessingSectionHeader(this.backgroundColor, this.headerTitle);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: DelegateHeader(backgroundColor, headerTitle),
    );
  }
}

class DelegateHeader extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final String headerTitle;

  DelegateHeader(this.backgroundColor, this.headerTitle);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Text(
          headerTitle,
          style: TextStyle(
            color: Colors.indigo,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
