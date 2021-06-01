import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:popup_menu/popup_menu.dart';

import '../../../utils/constants/utils.dart';
import '../../../utils/helpers/navigation-helper.dart';
import '../../../provider/user/viewmodel-user.dart';
import '../../../provider/user/viewmodel-user-profile.dart';
import '../../../provider/posts/viewmodel-post.dart';
import '../../../widgets/ExpandableText.dart';

class CommentsBox extends StatefulWidget {
  final String token;
  final UserViewModel vm;
  final UserProfileViewModel userVM;
  final List<UserProfileViewModel> userList;
  final PostViewModel post;
  final Function refresh;

  CommentsBox({
    Key key,
    this.token,
    this.vm,
    this.userVM,
    this.userList,
    this.post,
    this.refresh,
  }) : super(key: key);

  @override
  _CommentsBoxState createState() => _CommentsBoxState();
}

class _CommentsBoxState extends State<CommentsBox>
    with AutomaticKeepAliveClientMixin<CommentsBox> {

  String _cId;

  Future<void> _refresh() {
    // _fetchPosts();
    return Future.value();
  }

  Widget _createCommentItem(int i) {
    // print('${notification.uploads.length} X $index');
    // print('path : ${_post.avatar}');
    return Container(
      margin: EdgeInsets.only(bottom: 4.0,),
      // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.grey.shade400),
      //   borderRadius: BorderRadius.circular(4.0),
      // ),
      child: _thirdDesign(i),
    );
  }

  Widget _thirdDesign(int i) {
    var comment = widget.post.comments[i];
    var _profilePic = '';
    var _fullName = '';
    var _user;
    for (var user in widget.userList) {
      if (user.user.id == comment.authorId) {
        _profilePic = user.profilePic;
        _fullName = '${user.user.name} ${user.user.lname}';
        _user = user;
      } else if (widget.vm.id == comment.authorId) {
        _profilePic = (widget.userVM != null)
            ? (widget.userVM.profilePic != null ||
            !widget.userVM.profilePic.contains('null'))
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
    if (widget.vm.id == comment.authorId) {
      _profilePic = (widget.userVM != null)
          ? (widget.userVM.profilePic != null ||
          !widget.userVM.profilePic.contains('null'))
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
      margin: EdgeInsets.symmetric(horizontal: 16.0,),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              NavigationHelper.openProfileScreen2(
                  context, widget.vm, _user,
                  widget.userVM, widget.token, 'post');
            },
            child: Container(
              padding: EdgeInsets.only(top: 16.0, bottom: 8.0,),
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          spreadRadius:1.0,
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
                    ),/*ClipRRect(
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
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    // fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0,),
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
                            'Posted on ${DateFormat('EEEE, MMMM d, y hh:mm a').format(DateTime.parse(comment.date).add(Duration(hours: 8)))}',
                            style: TextStyle(fontSize: 12.0, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.vm.id == comment.authorId,
                    child: SizedBox(
                      width: 16.0,
                    ),
                  ),
                  Visibility(
                    visible: widget.vm.id == comment.authorId,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ClipOval(
                        child: GestureDetector(
                          onTapDown: (TapDownDetails d) {
                            _showPopupMenu(d.globalPosition);
                            setState(() {
                              _cId = comment.commentId;
                            });
                          },
                          child: Container(
                            width: 32.0,
                            height: 32.0,
                            alignment: Alignment.center,
                            child: FaIcon(
                              FontAwesomeIcons.ellipsisH,
                              color: Colors.black,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                ],
              ),
            ),
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
            child: ExpandableText((comment.text == null) ? '' : comment.text),
          ),
          SizedBox(
            height: 8.0,
          ),
        ],
      ),
    );
  }

  /*Future<String> unlikePost(String postId) async {
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
  }*/

  Future<String> deleteComment() async {
    final url = "$secretHollowsEndPoint/api/posts/comment/${widget.post.id}/$_cId";
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
      throw Exception("Failed to delete comment!");
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    PopupMenu.context = context;
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: colorPrimary,
      onRefresh: widget.refresh,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return _createCommentItem(index);
        },
        itemCount: widget.post.comments.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    );
  }

  void _showPopupMenu(Offset offset) {
    PopupMenu menu = PopupMenu(
      // backgroundColor: Colors.teal,
      // lineColor: Colors.tealAccent,
        maxColumn: 1,
        items: [
          MenuItem(
            title: 'Remove',
            image: FaIcon(
              FontAwesomeIcons.trashAlt,
              color: Colors.white,
            ),
          ),
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss);
    menu.show(rect: Rect.fromPoints(offset, offset));
  }

  void stateChanged(bool isShow) {
    // print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  void onClickMenu(MenuItemProvider item) {
    // print('Click menu -> ${item.menuTitle}');
    deleteComment().then((value) {
      print('DELETE - $value');
      if (!value.contains('error')) {
        widget.refresh();
      }
    });
  }

  void onDismiss() {
    // print('Menu is dismiss');
  }
}

