import 'package:flutter/material.dart';
import 'package:twenty_one_days/screens/login/widgets/login_form.widget.dart';
import 'package:twenty_one_days/screens/login/widgets/login_graphic.widget.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _content,
      backgroundColor: Colors.white,
    );
  }

  // Widget get _scrollableContent {
  //   return LayoutBuilder(
  //       builder: (BuildContext context, BoxConstraints viewportConstraints) {
  //     return SingleChildScrollView(
  //       child: ConstrainedBox(
  //         constraints: BoxConstraints(
  //             minHeight: viewportConstraints.maxHeight,
  //             minWidth: viewportConstraints.maxWidth),
  //         child: Container(
  //           color: Colors.white,
  //           child: IntrinsicHeight(
  //             child: _content,
  //           ),
  //         ),
  //       ),
  //     );
  //   });
  // }

  Widget get _content {
    return Column(
      mainAxisSize: MainAxisSize.max, 
      children: <Widget>[
      Expanded(
        flex: 60,
        child: LoginGraphicWidget(),
      ),
      Expanded(
        flex: 40,
        child: LoginFormWidget(),
      ),
      // Expanded(
      //   flex: 10,
      //   child: Container(),
      // ),
    ]);
  }
}
