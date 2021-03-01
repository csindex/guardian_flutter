import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import '../../provider/posts/viewmodel-post.dart';
import '../../widgets/posts/form-create-post.dart';
import '../../widgets/posts/like-button.dart';
import '../../widgets/ExpandableText.dart';
import '../../data/posts/data-like.dart';
import '../../utils/constants/utils.dart';
import '../../utils/helpers/navigation-helper.dart';


class Posts extends StatefulWidget {
  final List<PostViewModel> posts;
  final UserViewModel viewModel;
  final String token;
  final List<UserProfileViewModel> userList;

  Posts({this.posts, this.viewModel, this.token, this.userList});

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  Widget _createPostItem(int index) {
    // print('${notification.uploads.length} X $index');
    // print('path : ${_post.avatar}');
    return Container(
      margin: EdgeInsets.only(bottom: 4.0,),
      // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.grey.shade400),
      //   borderRadius: BorderRadius.circular(4.0),
      // ),
      child: _thirdDesign(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return (index == 0)
              ? Container(child: CreatePostForm(),)
              : _createPostItem(index - 1);
        },
        itemCount: widget.posts.length + 1,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    );
  }

  Future<String> unlikePost(String postId) async {
    final url = "$secretHollowsEndPoint/api/posts/unlike/$postId";
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

  Widget _firstDesign(int index) {
    var _post = widget.posts[index];
    var _postLikes = _post.likes;
    var _isLiker = false;
    for (var like in _post.likes) {
      if (like.likerId == widget.viewModel.id) {
        _isLiker = true;
      }
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/loading.gif',
                image: '$secretHollowsEndPoint/img/Spotter.png'/*(_post.profilePic == null)
                    ? _post.avatar
                    : _post.profilePic*/, //notification.uploads[0].fileFullPath,
                fit: BoxFit.cover,
                height: 48.0,
                width: 48.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              _post.author,
              style: TextStyle(
                fontSize: 14.0,
                color: colorPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ExpandableText((_post.text == null) ? '' : _post.text),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  _post.date,
                  style: TextStyle(fontSize: 10.0, color: Colors.grey.shade500),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LikeButton(
                      token: widget.token,
                      isChecked: _isLiker,
                      id: widget.viewModel.id,
                      postId: _post.id,
                      likes: _postLikes,
                      onLikeButtonChanged: (_likes, isChecked) {
                        if (isChecked) {
                          widget.posts[index].likes.clear();
                          widget.posts[index].likes.addAll(_likes);
                        }
                      },
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Material(
                        color: Colors.grey.shade400,
                        child: InkWell(
                          onTap: () {
                            unlikePost(_post.id).then((value) {
                              Iterable body = jsonDecode(value);
                              var newData = body
                                  .map((data) => LikeData.fromJsonMap(data))
                                  .toList();
                              if (newData.isEmpty) {
                                widget.posts[index].likes.clear();
                              } else {
                                widget.posts[index].likes.clear();
                                widget.posts[index].likes.addAll(newData);
                              }
                              setState(() {
                                _isLiker = false;
                              });
                            });
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
                                  FontAwesomeIcons.solidThumbsDown,
                                  color: Colors.black,
                                  size: 12.0,
                                ),
                                SizedBox(
                                  width: 4.0,
                                ),
                                Visibility(
                                  // visible: (post.likes.length > 0) ? true : false,
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
                    SizedBox(
                      width: 4.0,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Material(
                        color: colorPrimary,
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
                                Text(
                                  'Discussion',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 4.0,
                                ),
                                Visibility(
                                  visible: (_post.comments.length > 0)
                                      ? true
                                      : false,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      child: Text(
                                        '${_post.comments.length}',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: colorPrimary,
                                          backgroundColor:
                                              Colors.blueGrey.shade300,
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
                    SizedBox(
                      width: 4.0,
                    ),
                    Visibility(
                      visible: (widget.viewModel.id == _post.authorId)
                          ? true
                          : false,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Material(
                          color: Colors.redAccent,
                          child: InkWell(
                            onTap: () {},
                            splashColor: Colors.grey.shade700,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.times,
                                color: Colors.white,
                                size: 12.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _secondDesign(int index) {
    var _post = widget.posts[index];
    var _postLikes = _post.likes;
    var _isLiker = false;
    for (var like in _post.likes) {
      if (like.likerId == widget.viewModel.id) {
        _isLiker = true;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: _getProfilePic(_post.authorId)/*(_post.profilePic == null)
                    ? _post.avatar
                    : _post.profilePic*/, //notification.uploads[0].fileFullPath,
                fit: BoxFit.cover,
                height: 36.0,
                width: 36.0,
              ),
            ),
            SizedBox(width: 8.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _post.author,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _post.date,
                  style: TextStyle(fontSize: 10.0, color: Colors.grey.shade500),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        Visibility(
          visible: true,
          child: GestureDetector(
            onTap: () {
              NavigationHelper.openImageFull(context, _post.articleImage);
            },
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: (_post.articleImage == '')
                  ? 'https://vignette.wikia.nocookie.net/codegeass/images/7/7'
                      'e/1295504746.jpg/revision/latest/scale-to-width-down/340?'
                      'cb=20140311192830'
                  : _post.articleImage, //notification.uploads[0].fileFullPath,
              fit: BoxFit.contain,
            ),
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
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LikeButton(
                token: widget.token,
                isChecked: _isLiker,
                id: widget.viewModel.id,
                postId: _post.id,
                likes: _postLikes,
                onLikeButtonChanged: (_likes, isChecked) {
                  if (isChecked) {
                    widget.posts[index].likes.clear();
                    widget.posts[index].likes.addAll(_likes);
                  }
                },
              ),
              SizedBox(
                width: 4.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Material(
                  color: Colors.grey.shade400,
                  child: InkWell(
                    onTap: () {
                      // if (_isLiker) {
                      print('isLiker $_isLiker');
                      unlikePost(_post.id).then((value) {
                        Iterable body = jsonDecode(value);
                        var newData = body
                            .map((data) => LikeData.fromJsonMap(data))
                            .toList();
                        if (newData.isEmpty) {
                          widget.posts[index].likes.clear();
                        } else {
                          widget.posts[index].likes.clear();
                          widget.posts[index].likes.addAll(newData);
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
                            FontAwesomeIcons.solidThumbsDown,
                            color: Colors.black,
                            size: 12.0,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Visibility(
                            // visible: (post.likes.length > 0) ? true : false,
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
              SizedBox(
                width: 4.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Material(
                  color: colorPrimary,
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
                          Text(
                            'Discussion',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Visibility(
                            visible: (_post.comments.length > 0) ? true : false,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(
                                  '${_post.comments.length}',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: colorPrimary,
                                    backgroundColor: Colors.blueGrey.shade300,
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
              SizedBox(
                width: 4.0,
              ),
              Visibility(
                visible: (widget.viewModel.id == _post.authorId) ? true : false,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Material(
                    color: Colors.redAccent,
                    child: InkWell(
                      onTap: () {},
                      splashColor: Colors.grey.shade700,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.times,
                          color: Colors.white,
                          size: 12.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _thirdDesign(int index) {
    var _post = widget.posts[index];
    var _postLikes = _post.likes;
    var _isLiker = false;
    for (var like in _post.likes) {
      if (like.likerId == widget.viewModel.id) {
        _isLiker = true;
      }
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0,),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(top: 16.0, bottom: 8.0,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
                      spreadRadius:2,
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: _getProfilePic(_post.authorId),
                    fit: BoxFit.cover,
                    height: 36.0,
                    width: 36.0,
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _post.author,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _post.date,
                    style: TextStyle(fontSize: 12.0, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            height: 1.0,
            color: Colors.grey.shade400,
            margin: EdgeInsets.symmetric(horizontal: 1.0,),
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
                      : _post.articleImage, //notification.uploads[0].fileFullPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /*Expanded(
                  child: */LikeButton(
                    token: widget.token,
                    isChecked: _isLiker,
                    id: widget.viewModel.id,
                    postId: _post.id,
                    likes: _postLikes,
                    onLikeButtonChanged: (_likes, isChecked) {
                      if (isChecked) {
                        widget.posts[index].likes.clear();
                        widget.posts[index].likes.addAll(_likes);
                      }
                    },
                  ),
                // ),
                /*Expanded(
                  child: */ClipRRect(
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
                              widget.posts[index].likes.clear();
                            } else {
                              widget.posts[index].likes.clear();
                              widget.posts[index].likes.addAll(newData);
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
                  child: */ClipRRect(
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
                                visible: (_post.comments.length > 0) ? true : false,
                                child: SizedBox(
                                  width: 4.0,
                                ),
                              ),
                              Visibility(
                                visible: (_post.comments.length > 0) ? true : false,
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Text(
                                      '${_post.comments.length}',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: colorPrimary,
                                        backgroundColor: Colors.blueGrey.shade300,
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
                /*(widget.viewModel.id == _post.authorId)
                    ? *//*Expanded(
                  child: */Visibility(
                    visible: (widget.viewModel.id == _post.authorId) ? true : false,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Material(
                        color: Colors.redAccent,
                        child: InkWell(
                          onTap: () {},
                          splashColor: Colors.grey.shade700,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 8.0,
                            ),
                            child: FaIcon(
                              FontAwesomeIcons.times,
                              color: Colors.white,
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
            ),
          ),
        ],
      ),
    );
  }

  String _getProfilePic(String id) {
    // print('getProfilePic called on $id - ${widget.userList}');
    var profilePic = '';
    for (var user in widget.userList) {
      if (user.user.id == id) {
        profilePic = user.profilePic;
        // print('profile pic for $id - $profilePic');
        return profilePic;
      }
    }
    return profilePic;
  }
}
