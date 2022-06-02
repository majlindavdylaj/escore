import 'dart:typed_data';

import 'package:escore/controllers/post_controller.dart';
import 'package:escore/models/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:visibility_detector/visibility_detector.dart';

//ignore: must_be_immutable
class HomeItem extends StatefulWidget {

  final Post? post;
  int currentPos;

  HomeItem(this.currentPos,{
      Key? key,
      this.post
  }) : super(key: key);

  @override
  State<HomeItem> createState() => _HomeItemState();
}

class _HomeItemState extends State<HomeItem> {

  PostController postController = Get.find();
  VideoPlayerController? controller;

  Uint8List? image;

  @override
  void initState() {
    initController();
    getThumbnail();

    super.initState();
  }

  initController(){
    controller = VideoPlayerController.network(widget.post!.video!)
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true);
  }

  getThumbnail() async {
    image = await VideoThumbnail.thumbnailData(
      video: widget.post!.video!,
      imageFormat: ImageFormat.JPEG,
      timeMs: 5000
    );
    if(mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {

    int postIndex = postController.postsList.indexOf(widget.post!);
    if(controller!.value.isInitialized){
      if(widget.currentPos == postIndex) {
        //controller!.seekTo(Duration.zero);
        controller!.play();
      }
    }

    return Container(
      color: Colors.red,
      height: 400,
      width: 400,
      child: GestureDetector(
        child: controller!.value.isInitialized
            ? VisibilityDetector(
              key: Key('$postIndex'),
              onVisibilityChanged: (VisibilityInfo info){
                if(info.visibleFraction == 0){
                  controller!.pause();
                }
                else{
                  controller!.play();
                }
              },
              child: AspectRatio(
                aspectRatio: controller!.value.aspectRatio,
                child: VideoPlayer(controller!),
              ),
            )
            : Container(),
        onTap: (){
          /*if(controller!.value.isInitialized) {
            if(!controller!.value.isPlaying && widget.isInView){
              controller!.play();
            }
          }*/
        },
      ),
    );
  }
}
