import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:twenty_one_days/constants.dart';
import 'package:twenty_one_days/screens/onboarding/onboarding.view_model.dart';
import 'package:video_player/video_player.dart';

class OnboardingScreen extends StatefulWidget {
  static const int N_SLIDES = 3;

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // int _selectedPage = 0;
  PageController _controller;
  OnboardingViewModel helperViewModel;

  @override
  void initState() {
    _controller = PageController();
    helperViewModel = OnboardingViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final changePageTriggerCallback = () {
      // this._controller.animateTo()
      this._controller.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    };

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                child: PageView(
              controller: _controller,
              children: <Widget>[
                _Slide(
                  heading: 'Mindfullness',
                  description: 'A long long log long long long description',
                  assetPath: 'assets/videos/mindfulness.mp4',
                ),
                _Slide(
                  heading: 'Changing Habits',
                  description: 'A long long log long long long description',
                  assetPath: 'assets/videos/habits.mp4',
                ),
                _Slide(
                  heading: 'Removing Addiction',
                  description: 'A long long log long long long description',
                  assetPath: 'assets/videos/addiction.mp4',
                ),
              ],
              onPageChanged: (index) {
                helperViewModel.setIndex(index);
              },
            )),
            Container(
              height: 56,
              child:
                  _SlidesIndicator(changePageTriggerCallback, helperViewModel),
            )
          ],
        ),
      ),
    );
  }
}

class _Slide extends StatefulWidget {
  final String heading;
  final String description;
  final String assetPath;

  _Slide({this.heading, this.description, this.assetPath});

  @override
  __SlideState createState() => __SlideState();
}

class __SlideState extends State<_Slide> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized,
        // even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Video
          Expanded(
              child: Container(
            // color: Colors.red,
            child: Center(
              child: _controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
          )),

          // TODO: Use Theming here

          // Heading
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
            child: Text(widget.heading ?? '',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    decoration: TextDecoration.none)),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(widget.description ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black12,
                    decoration: TextDecoration.none)),
          ),
        ]);
  }
}

class _SlidesIndicator extends StatelessWidget {
  final VoidCallback changePageTrigger;
  final OnboardingViewModel viewModel;

  _SlidesIndicator(this.changePageTrigger, this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<OnboardingViewModel>(
      model: viewModel,
      child: ScopedModelDescendant<OnboardingViewModel>(
          builder: (context, widget, model) {
        List<Widget> _slidesIndicator = [];
        bool isLastIndex = model.selectedIndex == OnboardingScreen.N_SLIDES - 1;

        for (int i = 0; i < OnboardingScreen.N_SLIDES; i++) {
          Widget indicator = Opacity(
              opacity: i == model.selectedIndex ? 1 : 0.32,
              child: Container(
                margin: EdgeInsets.all(6),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                    color: AppColors.PRIMARY,
                    borderRadius: BorderRadius.circular(24)),
              ));
          _slidesIndicator.add(indicator);
        }

        _slidesIndicator.add(Expanded(child: Container(), flex: 1));
        _slidesIndicator.add(FlatButton(
          textColor: AppColors.PRIMARY,
          child: Text(
            'Next',
            style: TextStyle(fontSize: 18),
          ),
          onPressed: isLastIndex
              ? () {
                  Navigator.of(context).pushNamed(AppRoutes.LOGIN);
                }
              : changePageTrigger,
        ));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _slidesIndicator),
        );
      }),
    );
  }
}
