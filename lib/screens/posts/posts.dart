import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../utils/constants/utils.dart';
import '../../utils/helpers/navigation-helper.dart';
import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../provider/posts/viewmodel-posts-list.dart';
import '../../provider/posts/viewmodel-post.dart';
import '../../widgets/ExpandableText.dart';
import '../../widgets/posts/controls-overlay.dart';
import '../../data/posts/data-like.dart';
import 'like-button.dart';

class Posts extends StatefulWidget {
  final String token;
  final UserViewModel vm;
  final UserProfileViewModel userProfileVM;
  final Function openProfileScreen;
  final List<UserProfileViewModel> userList;

  Posts(
      {Key key,
      @required this.openProfileScreen,
      this.token,
      this.vm,
      this.userProfileVM,
      this.userList})
      : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts>
    with AutomaticKeepAliveClientMixin<Posts> {
  List<PostViewModel> _posts = <PostViewModel>[];
  List<VideoPlayerController> _videoCntrllrs = <VideoPlayerController>[];
  List<int> _vCntrllrsCtr = <int>[];

  void _fetchPosts() {
    if (_videoCntrllrs.length > 0) {
      for (int i = 0; i < _videoCntrllrs.length; i++) {
        _videoCntrllrs[i].dispose();
      }
      _videoCntrllrs.clear();
      _vCntrllrsCtr.clear();
    }
    final vm = Provider.of<PostsListViewModel>(context, listen: false);
    vm.fetchPosts(widget.token).then((value) {
      print('post: $value');
      if (mounted) {
        int ctr = 0;
        for (var v in value) {
          if (v.articleImage.contains('mp4')) {
            print('video--${v.articleImage}');
            _videoCntrllrs.add(new VideoPlayerController.network('http://dev.guardian.ph:5000/Post-1630391108659.mp4'/*v.articleImage*/)
              ..initialize().then((_) {
              }));
          }
          _vCntrllrsCtr.add(ctr);
          ctr++;
        }
        setState(() {
          _posts.clear();
          _posts.addAll(value);
        });
      }
    });
  }

  Future<void> _refresh() {
    print('refresh called');
    _fetchPosts();
    return Future.value();
  }

  openProfileScreen2(var u) {
    NavigationHelper.openProfileScreen2(
        context, widget.vm, u, widget.userProfileVM, widget.token, 'post');
  }

  Widget _createPostItem(int index) {
    // print('${notification.uploads.length} X $index');
    // print('path : ${_post.avatar}');
    return Container(
      margin: EdgeInsets.only(
        bottom: 4.0,
      ),
      // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.grey.shade400),
      //   borderRadius: BorderRadius.circular(4.0),
      // ),
      child: _thirdDesign(index),
    );
  }

  Widget _thirdDesign(int index) {
    var _post = _posts[index];
    var _postLikes = _post.likes;
    var _isLiker = false;
    for (var like in _post.likes) {
      if (like.likerId == widget.vm.id) {
        _isLiker = true;
      }
    }
    var _profilePic = '';
    var _fullName = '';
    var _user;
    if (_post.articleImage.contains('.mp4')) {
      print('AS-${_videoCntrllrs[_vCntrllrsCtr[index]].value.aspectRatio}\n'
          'W-${_videoCntrllrs[_vCntrllrsCtr[index]].value.size.width}\n'
          'H-${_videoCntrllrs[_vCntrllrsCtr[index]].value.size.height}');
    }
    for (var user in widget.userList) {
      if (user.user.id == _post.authorId) {
        _profilePic = user.profilePic;
        _fullName = '${user.user.name} ${user.user.lname}';
        _user = user;
      } else if (widget.vm.id == _post.authorId) {
        _profilePic = (widget.userProfileVM != null)
            ? (widget.userProfileVM.profilePic != null ||
                    !widget.userProfileVM.profilePic.contains('null'))
                ? widget.userProfileVM.profilePic
                : '$secretHollowsEndPoint/img/Spotter.png'
            : '$secretHollowsEndPoint/img/Spotter.png';
        _fullName = (widget.userProfileVM != null)
            ? (widget.userProfileVM.user.name != null)
                ? '${widget.userProfileVM.user.name} ${widget.userProfileVM.user.lname}'
                : '${widget.vm.name}'
            : '${widget.vm.name}';
        _user = widget.userProfileVM;
      }
    }
    if (widget.vm.id == _post.authorId) {
      _profilePic = (widget.userProfileVM != null)
          ? (widget.userProfileVM.profilePic != null ||
                  !widget.userProfileVM.profilePic.contains('null'))
              ? widget.userProfileVM.profilePic
              : '$secretHollowsEndPoint/img/Spotter.png'
          : '$secretHollowsEndPoint/img/Spotter.png';
      _fullName = (widget.userProfileVM != null)
          ? (widget.userProfileVM.user.name != null)
              ? '${widget.userProfileVM.user.name} ${widget.userProfileVM.user.lname}'
              : '${widget.vm.name}'
          : '${widget.vm.name}';
      _user = widget.userProfileVM;
    }
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(
        top: 16.0,
        bottom: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              openProfileScreen2(_user);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade900,
                        spreadRadius: 1.0,
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 18.0,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 17.5,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(_profilePic),
                    ),
                  ), /*ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: _getProfilePic(_post.authorId),
                      fit: BoxFit.cover,
                      height: 36.0,
                      width: 36.0,
                    ),
                  ),*/
                ),
                SizedBox(width: 16.0),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _fullName,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: colorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _post.date,
                      style: TextStyle(
                          fontSize: 12.0, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            height: 1.0,
            color: Colors.grey.shade400,
            margin: EdgeInsets.symmetric(
              horizontal: 1.0,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ExpandableText((_post.text == null) ? '' : _post.text),
          ),
          SizedBox(
            height: 8.0,
          ),
          (_post.articleImage.contains('.mp4')) ?
          Container(
            height: 220.0,
            color: Colors.grey.shade100,
            padding: EdgeInsets.all(4.0),
            child: _videoCntrllrs[_vCntrllrsCtr[index]].value.isInitialized ?
            AspectRatio(
              aspectRatio: _videoCntrllrs[_vCntrllrsCtr[index]].value.size.width / _videoCntrllrs[_vCntrllrsCtr[index]].value.size.height,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  VideoPlayer(_videoCntrllrs[_vCntrllrsCtr[index]]),
                  ControlsOverlay(controller: _videoCntrllrs[_vCntrllrsCtr[index]]),
                  VideoProgressIndicator(_videoCntrllrs[_vCntrllrsCtr[index]], allowScrubbing: true),
                ],
              ),
            ) : CircularProgressIndicator(),
          ) :
          Visibility(
            visible: true,
            child: GestureDetector(
              onTap: () {
                NavigationHelper.openImageFull(context, _post.articleImage);
              },
              child: Container(
                height: 220.0,
                color: Colors.grey.shade100,
                padding: EdgeInsets.all(4.0),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: (_post.articleImage == '')
                      ? 'https://vignette.wikia.nocookie.net/codegeass/images/7/7'
                          'e/1295504746.jpg/revision/latest/scale-to-width-down/340?'
                          'cb=20140311192830'
                      : _post
                          .articleImage, //notification.uploads[0].fileFullPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: (widget.vm.id == _post.authorId)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /*Expanded(
                  child: */
                      LikeButton(
                        token: widget.token,
                        isChecked: _isLiker,
                        id: widget.vm.id,
                        postId: _post.id,
                        likes: _postLikes,
                        onLikeButtonChanged: (_likes, isChecked) {
                          if (isChecked) {
                            _posts[index].likes.clear();
                            _posts[index].likes.addAll(_likes);
                          }
                        },
                      ),
                      // ),
                      /*Expanded(
                  child: */
                      ClipRRect(
                        // borderRadius: BorderRadius.circular(4.0),
                        child: Material(
                          // color: Colors.grey.shade400,
                          child: InkWell(
                            onTap: () {
                              // if (_isLiker) {
                              // print('isLiker $_isLiker');
                              unlikePost(_post.id).then((value) {
                                Iterable body = jsonDecode(value);
                                var newData = body
                                    .map((data) => LikeData.fromJsonMap(data))
                                    .toList();
                                if (newData.isEmpty) {
                                  _posts[index].likes.clear();
                                } else {
                                  _posts[index].likes.clear();
                                  _posts[index].likes.addAll(newData);
                                }
                                setState(() {
                                  _isLiker = false;
                                });
                              });
                              // }
                            },
                            splashColor: Colors.grey.shade700,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.thumbsDown,
                                    color: Colors.black,
                                    size: 12.0,
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    'Unlike',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Visibility(
                                    // visible: (post.likes.length > 0) ? true : false,
                                    visible: false,
                                    child: SizedBox(
                                      width: 8.0,
                                    ),
                                  ),
                                  Visibility(
                                    // visible: (post.likes.length > 0) ? true : false,
                                    visible: false,
                                    child: Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // ),
                      /*Expanded(
                  child: */
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Material(
                          // color: colorPrimary,
                          child: InkWell(
                            onTap: () {
                              NavigationHelper.openComments(
                                context,
                                widget.token,
                                widget.vm,
                                widget.userProfileVM,
                                widget.userList,
                                _post,
                                _refresh,
                              );
                            },
                            splashColor: Colors.grey.shade700,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.comment,
                                    color: Colors.black,
                                    size: 12.0,
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    'Comments',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Visibility(
                                    visible: (_post.comments.length > 0)
                                        ? true
                                        : false,
                                    child: SizedBox(
                                      width: 4.0,
                                    ),
                                  ),
                                  Visibility(
                                    visible: (_post.comments.length > 0)
                                        ? true
                                        : false,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(2.0),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 2.0,
                                          vertical: 2.0,
                                        ),
                                        color: colorPrimary,
                                        child: Text(
                                          '${_post.comments.length}',
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Material(
                          // color: colorPrimary,
                          child: InkWell(
                            onTap: () {
                              print('HOY GISING!');
                            },
                            splashColor: Colors.grey.shade700,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.shareSquare,
                                    color: Colors.black,
                                    size: 12.0,
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    'Share',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      /*(widget.viewModel.id == _post.authorId)
                    ? */ /*Expanded(
                  child: */
                      Visibility(
                        visible:
                            (widget.vm.id == _post.authorId) ? true : false,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Material(
                            // color: Colors.redAccent,
                            child: InkWell(
                              onTap: () {
                                // TODO: DELETE POST
                                deletePost(_post.id).then((value) {
                                  print('DELETE - $value');
                                  if (value.contains('removed')) {
                                    _refresh();
                                  }
                                });
                              },
                              splashColor: Colors.grey.shade700,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 8.0,
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.trashAlt,
                                  color: Colors.black,
                                  size: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // )
                      /*: Visibility(visible: false, child: Container(),),*/
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /*Expanded(
                  child: */
                      LikeButton(
                        token: widget.token,
                        isChecked: _isLiker,
                        id: widget.vm.id,
                        postId: _post.id,
                        likes: _postLikes,
                        onLikeButtonChanged: (_likes, isChecked) {
                          if (isChecked) {
                            _posts[index].likes.clear();
                            _posts[index].likes.addAll(_likes);
                          }
                        },
                      ),
                      // ),
                      /*Expanded(
                  child: */
                      ClipRRect(
                        // borderRadius: BorderRadius.circular(4.0),
                        child: Material(
                          // color: Colors.grey.shade400,
                          child: InkWell(
                            onTap: () {
                              // if (_isLiker) {
                              // print('isLiker $_isLiker');
                              unlikePost(_post.id).then((value) {
                                Iterable body = jsonDecode(value);
                                var newData = body
                                    .map((data) => LikeData.fromJsonMap(data))
                                    .toList();
                                if (newData.isEmpty) {
                                  _posts[index].likes.clear();
                                } else {
                                  _posts[index].likes.clear();
                                  _posts[index].likes.addAll(newData);
                                }
                                setState(() {
                                  _isLiker = false;
                                });
                              });
                              // }
                            },
                            splashColor: Colors.grey.shade700,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.thumbsDown,
                                    color: Colors.black,
                                    size: 12.0,
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    'Unlike',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Visibility(
                                    // visible: (post.likes.length > 0) ? true : false,
                                    visible: false,
                                    child: SizedBox(
                                      width: 8.0,
                                    ),
                                  ),
                                  Visibility(
                                    // visible: (post.likes.length > 0) ? true : false,
                                    visible: false,
                                    child: Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // ),
                      /*Expanded(
                  child: */
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Material(
                          // color: colorPrimary,
                          child: InkWell(
                            onTap: () {
                              NavigationHelper.openComments(
                                context,
                                widget.token,
                                widget.vm,
                                widget.userProfileVM,
                                widget.userList,
                                _post,
                                _refresh,
                              );
                            },
                            splashColor: Colors.grey.shade700,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.comment,
                                    color: Colors.black,
                                    size: 12.0,
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    'Comments',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Visibility(
                                    visible: (_post.comments.length > 0)
                                        ? true
                                        : false,
                                    child: SizedBox(
                                      width: 4.0,
                                    ),
                                  ),
                                  Visibility(
                                    visible: (_post.comments.length > 0)
                                        ? true
                                        : false,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(2.0),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 2.0,
                                          vertical: 2.0,
                                        ),
                                        color: colorPrimary,
                                        child: Text(
                                          '${_post.comments.length}',
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Material(
                          // color: colorPrimary,
                          child: InkWell(
                            onTap: () {},
                            splashColor: Colors.grey.shade700,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.shareSquare,
                                    color: Colors.black,
                                    size: 12.0,
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    'Share',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Future<String> unlikePost(String postId) async {
    final url = Uri.parse('$secretHollowsEndPoint/api/posts/unlike/$postId');
    final response = await http.put(
      url,
      headers: {
        'x-auth-token': widget.token,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('${response.body}');
      throw Exception("Failed to unlike post!");
    }
  }

  Future<String> deletePost(String postId) async {
    final url = Uri.parse('$secretHollowsEndPoint/api/posts/$postId');
    final response = await http.delete(
      url,
      headers: {
        'x-auth-token': widget.token,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('${response.body}');
      throw Exception("Failed to delete post!");
    }
  }

  Widget get _header => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.solidUser,
            color: Colors.grey.shade700,
            size: 16.0,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            'Welcome to GUARDIAN community',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey.shade900,
            ),
          ),
        ],
      );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  void dispose() {
    super.dispose();
    if (_videoCntrllrs.length > 0) {
      for (int i = 0; i < _videoCntrllrs.length; i++) {
        _videoCntrllrs[i].dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: colorPrimary,
      onRefresh: _refresh,
      child: Container(
        color: Colors.grey.shade100,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            // return (index == 0) ?
            // Padding(
            //   padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            //   child: _header,
            // ) : (index == 1) ?
            // ExpandableCreatePostForm(token: widget.token, refresh: _refresh) :
            // _createPostItem(index - 2);
            return (index == 0)
                ? vSpacer(
                    h: 16.0,
                  )
                : _createPostItem(index - 1);
          },
          itemCount: _posts.length + 1,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
        ),
      ),
    );
  }
}
