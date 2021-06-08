import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/posts/data-like.dart';
import '../../utils/constants/utils.dart';

class UnlikeButton extends StatefulWidget {
  UnlikeButton({
    Key key,
    @required this.token,
    @required this.onLikeButtonChanged,
    this.isChecked,
    this.postId,
    this.id,
    this.likes,
  }) : super(key: key);

  final String token;
  final bool isChecked;
  final String postId;
  final String id;
  final List<LikeData> likes;
  final Function(List<LikeData>, bool) onLikeButtonChanged;

  @override
  _UnlikeButtonState createState() => _UnlikeButtonState();
}

class _UnlikeButtonState extends State<UnlikeButton> {
  final GlobalKey _buttonKey = GlobalKey();

  bool _isChecked = false;
  int _numLikes = 0;

  void _init() {
    _isChecked = widget.isChecked;
    _numLikes = widget.likes.length;
  }

  @override
  void didUpdateWidget(UnlikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: Material(
        color: Colors.grey.shade400,
        child: InkWell(
          key: _buttonKey,
          onTap: () {
            print('onTapped: $_isChecked');
            if (!_isChecked) {
              if (widget.likes.length == 0) {
                likePost().then((value) {
                  Iterable body = jsonDecode(value);
                  var newData =
                      body.map((data) => LikeData.fromJsonMap(data)).toList();
                  widget.onLikeButtonChanged(newData, true);
                  setState(() {
                    print('setStateif');
                    _isChecked = true;
                    _numLikes++;
                  });
                });
              } else {
                bool flag = false;
                for (var like in widget.likes) {
                  if (like.likerId == widget.id) {
                    flag = true;
                  }
                }
                if (!flag) {
                  likePost().then((value) {
                    Iterable body = jsonDecode(value);
                    var newData =
                        body.map((data) => LikeData.fromJsonMap(data)).toList();
                    widget.onLikeButtonChanged(newData, true);
                    setState(() {
                      print('setStateelse');
                      _isChecked = true;
                      _numLikes++;
                    });
                  });
                }
              }
            }
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
                  FontAwesomeIcons.solidThumbsUp,
                  color: _isChecked ? colorPrimary : Colors.black,
                  size: 12.0,
                ),
                SizedBox(
                  width: 4.0,
                ),
                Visibility(
                  visible: (_numLikes > 0) ? true : false,
                  child: Text(
                    '$_numLikes',
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
    );
  }

  Future<String> likePost() async {
    final url = Uri.parse('$secretHollowsEndPoint/api/posts/like/${widget.postId}');
    final response = await http.put(
      url,
      headers: {
        'x-auth-token': widget.token,
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to like post!");
    }
  }
}
