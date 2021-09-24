import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/utils.dart';
import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../provider/posts/viewmodel-posts-list.dart';
import '../../provider/posts/viewmodel-post.dart';
import '../../widgets/posts/posts.dart';

class PostsList extends StatefulWidget {
  final String token;
  final UserViewModel viewModel;
  final UserProfileViewModel userProfileVM;
  final List<UserProfileViewModel> userList;

  PostsList({
    this.token, this.viewModel, this.userList, this.userProfileVM});

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  List<PostViewModel> posts = <PostViewModel>[];

  void _fetchPosts() {
    final vm = Provider.of<PostsListViewModel>(context, listen: false);
    vm.fetchPosts(widget.token).then((value) {
      print('post: $value');
      setState(() {
        posts.clear();
        posts.addAll(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    print('token- ${widget.token}');
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: colorPrimary,
      onRefresh: refresh,
      child: Posts(
        posts: posts,
        viewModel: widget.viewModel,
        token: widget.token,
        userList: widget.userList,
        userVM: widget.userProfileVM,
      ),
    );
  }

  Future<void> refresh() {
    _fetchPosts();
    return Future.value();
  }
}
