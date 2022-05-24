import 'package:escore/api/rest_api.dart';
import 'package:escore/models/post.dart';
import 'package:get/get.dart';

class PostController extends GetxController {

  var postsList = <Post>[].obs;
  var isLoading = true.obs;

  fetchPosts(context) async {
    isLoading(true);
    await RestApi(context).posts(
        onResponse: (response) async {
          var posts = <Post>[];
          for(var data in response){
            posts.add(Post.fromJson(data));
          }
          postsList.value = posts;
          isLoading(false);
        }
    );
  }

}