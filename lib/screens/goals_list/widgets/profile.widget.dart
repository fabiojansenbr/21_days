import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

class _ProfilePictureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 56, child: Image.asset('assets/images/sample_profile.png'));
  }
}

class _UserAttribution extends StatelessWidget {
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
                text: 'Devashish',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24)),
          ])),

          // Today's motivational Quote
          Text(
            'Motivation gets you going and habit gets you there',
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
