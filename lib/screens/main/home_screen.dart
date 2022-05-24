import 'package:carousel_slider/carousel_slider.dart';
import 'package:escore/controllers/post_controller.dart';
import 'package:escore/items/home_item.dart';
import 'package:escore/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PostController postController = Get.find();

  @override
  void initState() {
    postController.fetchPosts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Obx(() =>
      !postController.isLoading.value
          ? postController.postsList.isNotEmpty
          ? CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              scrollDirection: Axis.vertical,
              enableInfiniteScroll: false,
              disableCenter: true,
              viewportFraction: 1,
              onPageChanged: (i, _){
                debugPrint('$i');
              },
            ),
            items: postController.postsList.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return HomeItem(post: i);
                },
              );
            }).toList(),
          )
          : const Center(child: Text("Empty"))
          : const Center(child: CircularProgressIndicator()),
      )
    );
  }
}
