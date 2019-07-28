import 'package:flutter/material.dart';
import 'package:twenty_one_days/constants.dart';
import 'package:twenty_one_days/screens/login/widgets/login_avatar.widget.dart';
import 'package:twenty_one_days/screens/login/widgets/login_form.widget.dart';
import 'package:twenty_one_days/screens/login/widgets/login_graphic.widget.dart';
import 'package:twenty_one_days/utilities/storage_helper.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen() {
    StorageHelper();
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _textEditingController = TextEditingController();

  double height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _scrollableContent,
      backgroundColor: Colors.white,
    );
  }

  Widget get _scrollableContent {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      if (height == null) {
        height = viewportConstraints.maxHeight;
      }
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: height,
              maxHeight: height,
              minWidth: viewportConstraints.maxWidth),
          child: Container(
            color: Colors.white,
            child: IntrinsicHeight(
              child: _getContent(context),
            ),
          ),
        ),
      );
    });
  }

  Widget _getContent(BuildContext context) {
    final _onNameEntered = (String name) async {
      try {
        await StorageHelper().setName(name);
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      } catch (_) {}
    };

    final _onAvatarSelected = (bool isMaleSelected) async {
      try {
        await StorageHelper().setAvatar(isMaleSelected);
        Navigator.of(context).pushReplacementNamed(AppRoutes.GOALS_LIST);
      } catch (_) {}
    };

    return Column(
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            // flex: 40,
            child: LoginGraphicWidget(),
          ),
          Expanded(
              child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    if (index != 0) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    }
                  },
                  children: <Widget>[
                LoginFormWidget(_onNameEntered, _textEditingController),
                LoginAvatarWidget(_onAvatarSelected)
              ])
              // flex: 40,
              // child: LoginFormWidget(),
              // child: LoginAvatarWidget(),
              ),
        ]);
  }
}
