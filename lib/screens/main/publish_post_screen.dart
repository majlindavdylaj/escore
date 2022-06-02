import 'dart:io';
import 'dart:typed_data';

import 'package:escore/api/rest_api.dart';
import 'package:escore/helper/colors.dart';
import 'package:escore/helper/get_message.dart';
import 'package:escore/helper/loading.dart';
import 'package:escore/widgets/app_button.dart';
import 'package:escore/widgets/app_scaffold.dart';
import 'package:escore/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:http/http.dart' as http;

class PublishPostScreen extends StatefulWidget {
  const PublishPostScreen({Key? key}) : super(key: key);

  @override
  State<PublishPostScreen> createState() => _PublishPostScreenState();
}

class _PublishPostScreenState extends State<PublishPostScreen> {

  PickedFile? video;
  final _formKey = GlobalKey<FormState>();

  TextEditingController descriptionController = TextEditingController();

  final picker = ImagePicker();
  VideoPlayerController? controller;

  List<Uint8List?> thumbnails = [];
  Uint8List? selectedImage;

  int videoMaxDuration = 2 * 60;
  
  _pickVideo() async {
    var pickedVideo = await picker.getVideo(source: ImageSource.gallery, maxDuration: Duration(seconds: videoMaxDuration));
    if(pickedVideo != null) {
      setState(() {
        video = pickedVideo;
        initController();
      });
    }
  }

  initController(){
    controller = VideoPlayerController.file(File(video!.path))
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..play();
  }

  getThumbnail() async {
    if(thumbnails.isEmpty) {
      int time = (controller!.value.duration.inMilliseconds / 2).floor();
      for(int i = 0; i < 3; i++){
        Uint8List? image = await VideoThumbnail.thumbnailData(
            video: video!.path,
            imageFormat: ImageFormat.PNG,
            timeMs: time * i
        );
        thumbnails.add(image);
      }
      selectedImage = thumbnails.first;
      if (mounted) {
        setState(() {});
      }
    }
  }

  createPost() async {
    Loading.show(context);
    String description = descriptionController.text.trim();

    Map<String, String> params = {
      //"description": description
    };

    List<http.MultipartFile> files = [
      http.MultipartFile.fromBytes(
          'video',
          await video!.readAsBytes(),
          filename: 'IMG${(DateTime.now().microsecondsSinceEpoch).round()}'
      ),
      http.MultipartFile.fromBytes(
          'thumbnail',
          selectedImage!,
          filename: 'IMG${(DateTime.now().microsecondsSinceEpoch).round()}'
      )
    ];

    await RestApi(context).createPost(
        files,
        params,
        onResponse: (data) {
          debugPrint(data.toString());
          Loading.hide(context);

          GetMessage.snackbarMessage('Success', data.toString());

          /*Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const MainScreen()
          ));*/
        },
        onError: (error) {
          Loading.hide(context);
          GetMessage.snackbarMessage('Error', error);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasAppBar: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _video(),
            if(thumbnails.isNotEmpty)
              _thumbnails(),
            if(video != null && thumbnails.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            _form(),
            AppButton(
              text: 'Upload',
              icon: Icons.upload_sharp,
              onClick: (){
                createPost();
              },
            )
          ],
        ),
      )
    );
  }

  Widget _video(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AspectRatio(
        aspectRatio: 16/9,
        child: ClipRRect (
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              color: backgroundLight,
              child: video == null ? Center(
                child: AppButton(
                  backgroundColor: Colors.white,
                  text: 'Select Video',
                  icon: Icons.video_call,
                  onClick: (){
                    _pickVideo();
                  },
                )
              )
              : _videoValidator()
            )
        ),
      ),
    );
  }

  Widget _videoValidator(){
    if(controller!.value.isInitialized){
      if(controller!.value.aspectRatio != 16/9){
        WidgetsBinding.instance.addPostFrameCallback((_){
          GetMessage.snackbarMessage('Error', 'Video format need to be 16:9');
          setState((){
            video = null;
          });
        });
        return Container();
      } else if(controller!.value.duration.inSeconds > videoMaxDuration) {
        GetMessage.snackbarMessage('Error', 'Max video length 2 minutes');
        WidgetsBinding.instance.addPostFrameCallback((_){
          setState((){
            video = null;
          });
        });
        return Container();
      } else if(controller!.value.duration.inSeconds < 3) {
        GetMessage.snackbarMessage('Error', 'Min video length 3 seconds');
        WidgetsBinding.instance.addPostFrameCallback((_){
          setState((){
            video = null;
          });
        });
        return Container();
      } else {
        getThumbnail();
        return VideoPlayer(controller!);
      }
    }
    return const Center(
        child: CircularProgressIndicator()
    );
  }

  Widget _thumbnails(){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        children: [
          for(Uint8List? image in thumbnails)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: selectedImage == image ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: InkWell(
                        child: Image.memory(image!),
                        onTap: (){
                          setState((){
                            selectedImage = image;
                          });
                        },
                      )
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _form(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            controller: descriptionController,
            hint: "Video Description",
            keyboardType: TextInputType.text,
            //icon: Icons.description,
            maxLines: 4,
            maxLength: 400,
            validator: (value){
              /*if(!GetUtils.isEmail(value.toString())){
                        return "Email is required\n";
                      }*/
              return null;
            },
          ),
        ],
      ),
    );
  }
}
