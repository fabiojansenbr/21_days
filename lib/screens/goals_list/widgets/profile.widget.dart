import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Profile Picture
                  _ProfilePictureWidget(),

                  // Spacer
                  SizedBox(width: 16),

                  // User Atrribution
                  _UserAttribution()
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          // Spacer
          SizedBox(height: 8),

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
            'Pretty long long long motivational and mind changing quote',
            textAlign: TextAlign.right,
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
