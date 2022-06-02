import 'package:escore/controllers/post_controller.dart';
import 'package:escore/items/home_item.dart';
import 'package:escore/models/post.dart';
import 'package:escore/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PostController postController = Get.find();

  late PreloadPageController _pageController;
  Duration pageTurnDuration = const Duration(milliseconds: 500);
  Curve pageTurnCurve = Curves.ease;
  int currentPos = 0;

  @override
  void initState() {
    postController.fetchPosts(context);
    _pageController = PreloadPageController();
    super.initState();
  }

  void _goForward() {
    _pageController.nextPage(duration: pageTurnDuration, curve: pageTurnCurve);
  }

  void _goBack() {
    _pageController.previousPage(duration: pageTurnDuration, curve: pageTurnCurve);
  }

  @override
  Widget build(BuildContext context) {

    return AppScaffold(
        child: Obx(() =>
        !postController.isLoading.value
            ? postController.postsList.isNotEmpty
            ? GestureDetector(
              child: PreloadPageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:  postController.postsList.length,
                scrollDirection: Axis.vertical,
                preloadPagesCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  Post post = postController.postsList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Container(
                      color: Colors.red,
                      height: 200,
                      child: HomeItem(currentPos, post: post),
                    ),
                  );
                },
                onPageChanged: (int index){
                  setState((){
                    currentPos = index;
                  });
                },
              ),
              onVerticalDragUpdate: (details){
                int sensitivity = 8;
                if (details.delta.dy > sensitivity) {
                  _goBack();
                } else if(details.delta.dy < -sensitivity){
                  _goForward();
                }
              },
            )
            : const Center(child: Text("Empty"))
            : const Center(child: CircularProgressIndicator()),
        )
    );
  }
}
