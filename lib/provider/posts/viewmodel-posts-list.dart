import 'package:flutter/foundation.dart';
import 'dart:async';

import '../../services/web-service.dart';
import 'viewmodel-post.dart';

class PostsListViewModel extends ChangeNotifier {
  List<PostViewModel> posts = List<PostViewModel>();

  Future<List<PostViewModel>> fetchPosts(String token) async {
    final results = await Webservice().fetchPosts(token);
    this.posts = results.map((item) => PostViewModel(post: item)).toList();
    notifyListeners();
    return posts;
  }
}
