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


class Responder extends StatefulWidget {
  final List<UserProfileViewModel> responderList;
  final UserProfileViewModel userVM;
  final UserViewModel vm;
  final String token;
  final String origin;

  Responder({
    this.responderList, this.vm, this.token, this.userVM, this.origin});

  @override
  _ResponderState createState() => _ResponderState();
}

class _ResponderState extends State<Responder> {
  Widget _createResponderItem(int index) {
    return GestureDetector(
      onTap: () {
        // print('clicked ${widget.responderList[index].user.name}');
        NavigationHelper.openProfileScreen2(
            context, widget.vm, widget.responderList[index],
            widget.userVM, widget.token, 'post');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 4.0,),
        child: _thirdDesign(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return (index == 0) ?
          Container(child: _header, margin: EdgeInsets.all(16.0),) :
          _createResponderItem(index - 1);
        },
        itemCount: widget.responderList.length + 1,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    );
  }

  Widget get _header => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      FaIcon(
        FontAwesomeIcons.connectdevelop,
        color: Colors.grey.shade700,
        size: 16.0,
      ),
      SizedBox(
        width: 8.0,
      ),
      Text(
        'Connect with other Volunteers',
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.grey.shade900,
        ),
      ),
    ],
  );

  Widget _thirdDesign(int index) {
    var _responder = widget.responderList[index];
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
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(24.0),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade900,
                  spreadRadius:1.0,
                  blurRadius: 4.0,
                  offset: Offset(4.0, 6.0),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 100.0,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 99.0,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(_responder.profilePic),
              ),
            ),
          ),
          SizedBox(height: 16.0,),
          Text(
            '${_responder.user.name} ${_responder.user.lname}',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0,),
          Visibility(
            visible: (_responder.positionStatus != null),
            child: Text(
              _responder.positionStatus ?? '',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Visibility(
            visible: (_responder.positionStatus != null),
            child: SizedBox(height: 8.0,),
          ),
          Visibility(
            visible: (_responder.positionStatus != null),
            child: Text(
              (_responder.company != null) ? '@ ${_responder.company}' : '',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
          Visibility(
            visible: (_responder.positionStatus != null),
            child: SizedBox(height: 8.0,),
          ),
          Visibility(
            visible: (_responder.positionStatus != null),
            child: Text(
              _responder.location ?? '',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/*Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 16.0,
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
                Expanded(
                  child: LikeButton(
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
                Expanded(
                  child: ClipRRect(
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
                Expanded(
                  child: ClipRRect(
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
                (widget.viewModel.id == _post.authorId)
                    ? Expanded(
                  child: Visibility(
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
                    : Visibility(visible: false, child: Container(),),
              ],
            ),
          ),*/