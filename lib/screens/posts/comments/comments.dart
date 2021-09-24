import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guardian_flutter/utils/small-loading.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

import '../../../utils/constants/utils.dart';
import '../../../utils/constants/common-methods.dart';
import '../../../utils/helpers/navigation-helper.dart';
import '../../../provider/user/viewmodel-user.dart';
import '../../../provider/user/viewmodel-user-profile.dart';
import '../../../provider/posts/viewmodel-post.dart';
import '../../../widgets/ExpandableText.dart';
import '../../../data/posts/data-post.dart';
import '../../../data/posts/data-like.dart';
import '../like-button.dart';
import 'comments-box.dart';

class Comments extends StatefulWidget {
  final String token;
  final UserViewModel vm;
  final UserProfileViewModel userVM;

  final Function refresh;
  final List<UserProfileViewModel> userList;
  final PostViewModel post;

  Comments({
    Key key,
    this.token,
    this.vm,
    this.userVM,
    this.userList,
    this.post,
    this.refresh,
  }) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> with
    SingleTickerProviderStateMixin {
  PostViewModel _cP;
  AnimationController _controller;
  // Animation _animation;
  FocusNode _focusNode = FocusNode();
  var _errorComment;

  final _formPageKey = GlobalKey<FormState>();

  String _comment = '';

  TextEditingController _commentController;

  Future<void> _refresh() {
    _fetchPost().then((value) {
      print('post after comment: $value');
      PostViewModel p = PostViewModel(post: value);
      setState(() {
        _cP = p;
        _commentController.clear();
        _errorComment = null;
      });
      widget.refresh();
    });
    return Future.value();
  }

  bool _validateCommentForm() {
    bool flag = true;
    String errorMsg = '';
    if (_comment.isEmpty) {
      errorMsg = '- comment is empty.';
      _errorComment = 'error';
      flag = false;
    } else {
      _errorComment = null;
    }
    if(!flag) {
      showMessageDialog(context, 'Comment', errorMsg);
    }
    return flag;
  }

  @override
  void initState() {
    super.initState();
    _cP = widget.post;
    _commentController = TextEditingController(text: '');
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // _animation = Tween(begin: 300.0, end: 50.0).animate(_controller)
    //   ..addListener(() {
    //     setState(() {});
    //   });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  Widget _createPostItem(BuildContext ctx) {
    // print('${notification.uploads.length} X $index');
    // print('path : ${_post.avatar}');
    return Container(
      margin: EdgeInsets.only(
        bottom: 4.0,
      ),
      child: _postDesign(ctx),
    );
  }

  Widget _postDesign(BuildContext context) {
    var _profilePic = '';
    var _fullName = '';
    var _user;
    // var _postLikes = _cP.likes;
    var _isLiker = false;
    for (var like in _cP.likes) {
      if (like.likerId == widget.vm.id) {
        _isLiker = true;
      }
    }
    for (var user in widget.userList) {
      if (user.user.id == _cP.authorId) {
        _profilePic = user.profilePic;
        _fullName = '${user.user.name} ${user.user.lname}';
        _user = user;
      } else if (widget.vm.id == _cP.authorId) {
        _profilePic = (widget.userVM != null)
            ? (widget.userVM.profilePic != null || !widget.userVM.profilePic.contains('null'))
                ? widget.userVM.profilePic
                : '$secretHollowsEndPoint/img/Spotter.png'
            : '$secretHollowsEndPoint/img/Spotter.png';
        _fullName = (widget.userVM != null)
            ? (widget.userVM.user.name != null)
                ? '${widget.userVM.user.name} ${widget.userVM.user.lname}'
                : '${widget.vm.name}'
            : '${widget.vm.name}';
        _user = widget.userVM;
      }
    }
    if (widget.vm.id == _cP.authorId) {
      _profilePic = (widget.userVM != null)
          ? (widget.userVM.profilePic != null || !widget.userVM.profilePic.contains('null'))
              ? widget.userVM.profilePic
              : '$secretHollowsEndPoint/img/Spotter.png'
          : '$secretHollowsEndPoint/img/Spotter.png';
      _fullName = (widget.userVM != null)
          ? (widget.userVM.user.name != null)
              ? '${widget.userVM.user.name} ${widget.userVM.user.lname}'
              : '${widget.vm.name}'
          : '${widget.vm.name}';
      _user = widget.userVM;
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
              NavigationHelper.openProfileScreen2(
                  context, widget.vm, _user, widget.userVM, widget.token, 'post');
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
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 16.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fullName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _cP.date,
                          style: TextStyle(
                              fontSize: 12.0, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.0,
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
            child: ExpandableText((_cP.text == null) ? '' : _cP.text),
          ),
          SizedBox(
            height: 8.0,
          ),
          Visibility(
            visible: true,
            child: GestureDetector(
              onTap: () {
                NavigationHelper.openImageFull(context, _cP.articleImage);
              },
              child: Container(
                height: 220.0,
                color: Colors.grey.shade100,
                padding: EdgeInsets.all(4.0),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: (_cP.articleImage == '')
                      ? 'https://vignette.wikia.nocookie.net/codegeass/images/7/7'
                          'e/1295504746.jpg/revision/latest/scale-to-width-down/340?'
                          'cb=20140311192830'
                      : _cP.articleImage,
                  //notification.uploads[0].fileFullPath,
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
            child: (widget.vm.id == _cP.authorId) ?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /*Expanded(
                  child: */LikeButton(
                  token: widget.token,
                  isChecked: _isLiker,
                  id: widget.vm.id,
                  postId: _cP.id,
                  likes: _cP.likes,
                  onLikeButtonChanged: (_likes, isChecked) {
                    widget.refresh();
                    if (isChecked) {
                      _cP.likes.clear();
                      _cP.likes.addAll(_likes);
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
                        unlikePost(_cP.id).then((value) {
                          Iterable body = jsonDecode(value);
                          var newData = body
                              .map((data) => LikeData.fromJsonMap(data))
                              .toList();
                          if (newData.isEmpty) {
                            _cP.likes.clear();
                          } else {
                            _cP.likes.clear();
                            _cP.likes.addAll(newData);
                          }
                          setState(() {
                            _isLiker = false;
                          });
                          widget.refresh();
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
                              visible: (_cP.comments.length > 0) ? true : false,
                              child: SizedBox(
                                width: 4.0,
                              ),
                            ),
                            Visibility(
                              visible: (_cP.comments.length > 0) ? true : false,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 2.0,),
                                  color: colorPrimary,
                                  child: Text(
                                    '${_cP.comments.length}',
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
                    ? *//*Expanded(
                  child: */Visibility(
                  visible: (widget.vm.id == _cP.authorId) ? true : false,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Material(
                      // color: Colors.redAccent,
                      child: InkWell(
                        onTap: () {
                          // TODO: DELETE POST
                          deletePost(_cP.id).then((value) {
                            print('DELETE - $value');
                            if (value.contains('removed')) {
                              _refresh();
                              Navigator.pop(context);
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
            ) :
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /*Expanded(
                  child: */LikeButton(
                  token: widget.token,
                  isChecked: _isLiker,
                  id: widget.vm.id,
                  postId: _cP.id,
                  likes: _cP.likes,
                  onLikeButtonChanged: (_likes, isChecked) {
                    widget.refresh();
                    if (isChecked) {
                      _cP.likes.clear();
                      _cP.likes.addAll(_likes);
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
                        unlikePost(_cP.id).then((value) {
                          Iterable body = jsonDecode(value);
                          var newData = body
                              .map((data) => LikeData.fromJsonMap(data))
                              .toList();
                          if (newData.isEmpty) {
                            _cP.likes.clear();
                          } else {
                            _cP.likes.clear();
                            _cP.likes.addAll(newData);
                          }
                          setState(() {
                            _isLiker = false;
                          });
                          widget.refresh();
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
                              visible: (_cP.comments.length > 0) ? true : false,
                              child: SizedBox(
                                width: 4.0,
                              ),
                            ),
                            Visibility(
                              visible: (_cP.comments.length > 0) ? true : false,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 2.0,),
                                  color: colorPrimary,
                                  child: Text(
                                    '${_cP.comments.length}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formPageKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 8.0,
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.transparent, // button color
                        child: InkWell(
                          splashColor: Colors.grey, // inkwell color
                          child: Container(
                            width: 36.0,
                            height: 36.0,
                            alignment: Alignment.center,
                            child: FaIcon(
                              FontAwesomeIcons.angleLeft,
                              color: Colors.black,
                              size: 24.0,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'Return to Posts',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: colorPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                _createPostItem(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,),
                  child: TextFormField(
                    autofocus: true,
                    key: Key('comment'),
                    validator: (value) =>
                    value.isEmpty ? 'Please enter your comment' : null,
                    controller: _commentController,
                    autovalidateMode: AutovalidateMode.disabled,
                    focusNode: _focusNode,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(width: 1, color: Colors.black),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide:
                            BorderSide(width: 1, color: Colors.grey.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(width: 1.5, color: Colors.black),
                      ),
                      border: /*InputBorder.none,*/ OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      hintText: 'Leave a comment',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                      labelText: '',
                      labelStyle: TextStyle(
                        fontSize: 0.0,
                      ),
                      errorText: _errorComment,
                      errorStyle: TextStyle(
                        letterSpacing: 1.5,
                        fontSize: 0.0,
                      ),
                      counterText: '',
                      counterStyle: TextStyle(
                        fontSize: 0.0,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: 4,
                    minLines: 4,
                    onSaved: (String val) {
                      _comment = val;
                    },
                    onChanged: (String val) {
                      _comment = val;
                    },
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0,),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0,),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        backgroundColor: colorPrimary1,
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_validateCommentForm()) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: ((BuildContext context) {
                              return Dialog(
                                backgroundColor: colorPrimary1,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Adding Comment',
                                        style: TextStyle(
                                          fontSize: 36.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      vSpacer(16.0,),
                                      CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                          _submitComment();
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 24.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),/*FlatButton(
                      color: colorPrimary1,
                      onPressed: () {
                        if (_formPageKey.currentState.validate()) {
                          _submitComment().then((value) {
                            print('value - $value');
                            if (!value.contains('error')) {
                              widget.refresh();
                            }
                          });
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ),*/
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: CommentsBox(
                    token: widget.token,
                    vm: widget.vm,
                    userVM: widget.userVM,
                    userList: widget.userList,
                    post: _cP,
                    refresh: _refresh,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitComment() {
    try {
      _submitCommentApi().then((value) {
        if (!value.contains('error')) {
          final _snackBar = SnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            content: Text(
              'Comment Added.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          );
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          _refresh();
        }
      });
    } catch (e) {
      print('submit comm: $e');
    }
  }

  Future<String> _submitCommentApi() async {
    var url = Uri.parse('$secretHollowsEndPoint/api/posts/comment/${_cP.id}');
    Map data = {'text': _comment};
    var reqBody = json.encode(data);
    var response = await http.post(
      url,
      headers: {
        'Cache-Control' : 'no-cache',
        // 'Postman-Token' : '<calculated when request is sent>',
        // 'Content-Length' : '<calculated when request is sent>',
        // 'Host' : '<calculated when request is sent>',
        'Accept' : '*/*',
        'Accept-Encoding' : 'gzip, deflate, br',
        'Connection' : 'keep-alive',
        'Content-Type': 'application/json',
        'x-auth-token': widget.token,
      },
      body: reqBody,
    );
    print('comment r: $response X ${response.body}');
    // final body = jsonDecode(response.body);
    // return body["success"];
    return response.body;
  }

  Future<PostData> _fetchPost() async {
    final url = Uri.parse('$secretHollowsEndPoint/api/posts/${_cP.id}');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': widget.token,
        'Accept': '*/*',
      },
    );
    if (response.statusCode == 200) {
      return PostData.fromJsonMap(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch post ${_cP.id}!");
    }
  }
}
