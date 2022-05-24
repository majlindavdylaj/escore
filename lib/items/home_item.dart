import 'package:escore/helper/colors.dart';
import 'package:escore/models/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class HomeItem extends StatefulWidget {

  final Post? post;

  const HomeItem({
    Key? key,
    this.post
  }) : super(key: key);

  @override
  State<HomeItem> createState() => _HomeItemState();
}

class _HomeItemState extends State<HomeItem> {

  late VideoPlayerController controller;

  @override
  void initState() {
    controller = VideoPlayerController.network(widget.post!.video!)
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..play();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Center(
          child: controller.value.isInitialized
              ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              )
              : Container(),
        ),
      ),
      onTap: (){
        if(controller.value.isInitialized) {
          controller.value.isPlaying
              ? controller.pause()
              : controller.play();
        }
      },
    );
  }
}
