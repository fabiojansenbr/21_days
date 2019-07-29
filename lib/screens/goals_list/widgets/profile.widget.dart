import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:twenty_one_days/utilities/storage_helper.dart';

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Spacer

            SizedBox(height: 32),

            // Row
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Spacer
                  Spacer(flex: 8),

                  // Profile Picture
                  Expanded(child: _ProfilePictureWidget(), flex: 50),

                  // Spacer
                  SizedBox(width: 16),

                  // User Atrribution
                  Expanded(child: _UserAttribution(), flex: 60),

                  Spacer(flex: 12)
                ])
          ]),
    );
  }
}

class _ProfilePictureWidget extends StatefulWidget {
  @override
  __ProfilePictureWidgetState createState() => __ProfilePictureWidgetState();
}

class __ProfilePictureWidgetState extends State<_ProfilePictureWidget> {
  bool isMaleAvatar;

  @override
  void initState() {
    super.initState();
    _getAvatar();
  }

  _getAvatar() async {
    isMaleAvatar = await StorageHelper().getAvatar();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isMaleAvatar != null) {
      return CircleAvatar(
          radius: 56,
          child: isMaleAvatar
              ? Image.asset('assets/images/male.png')
              : Image.asset('assets/images/female.png'));
    } else {
      return Container();
    }
  }
}

class _UserAttribution extends StatefulWidget {
  @override
  __UserAttributionState createState() => __UserAttributionState();
}

class __UserAttributionState extends State<_UserAttribution> {
  String name;

  final List<String> quotes = [
    'Motivation gets you going and habit gets you there.',
    'Best way to break a habit is to drop it.',
    '21 days from now, you will thank yourself.',
    'Believe you can and you’re halfway there.',
    'Will it be easy ? Nope. Worth it ? Absolutely!'
  ];

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  _loadName() async {
    name = await StorageHelper().getName();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Spacer
          SizedBox(height: 4),

          // Username
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: 'Hi ',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 24)),
            TextSpan(
                text: name ?? '',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24)),
          ])),

          // Today's motivational Quote
          Text(
            quotes[Random().nextInt(4)],
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 18,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
