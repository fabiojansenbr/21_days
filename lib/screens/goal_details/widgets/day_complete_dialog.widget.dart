import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:twenty_one_days/constants.dart';
import 'package:video_player/video_player.dart';

class DayCompleteDialogWidget extends StatefulWidget {
  final bool are21DaysCompleted;

  DayCompleteDialogWidget({this.are21DaysCompleted = false});

  @override
  _DayCompleteDialogWidgetState createState() =>
      _DayCompleteDialogWidgetState();
}

class _DayCompleteDialogWidgetState extends State<DayCompleteDialogWidget> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.are21DaysCompleted
        ? 'assets/videos/trophy.mp4'
        : 'assets/videos/day_complete.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized,
        // even before the play button has been pressed.
        setState(() {});
        _controller.setLooping(widget.are21DaysCompleted ? false : true);
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Center(child: Text('Congratulations!')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Container(
                child: AnimatedOpacity(
                  opacity: _controller.value.initialized ? 1 : 0,
                  duration: Duration(milliseconds: 350),
                  child: _controller.value.initialized
                      ? VideoPlayer(_controller)
                      : Container(
                          width: 200, height: 200, color: Colors.white10),
                ),
              ),
            )),

            // Text
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(widget.are21DaysCompleted
                  ? 'Kudos! You did it.'
                  : 'Day Conquered! Keep going.'),
            ),

            // Dissmiss
            ButtonTheme(
              height: 40,
              minWidth: 128,
              child: FlatButton(
                  child: Text('Dismiss'),
                  color: AppColors.PRIMARY,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(64)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            )
          ],
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
