import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

import './announcements.dart';
import './utils/constants/utils.dart';
import './provider/viewmodel-notification-list.dart';

class Notification extends StatelessWidget {
  final List<NotificationViewModel> notifications;

  Notification({this.notifications});

  final defaultInitialReaction = Reaction( // ignore: missing_required_param
    previewIcon: _buildLikePreviewIcon(),
    icon: _buildLikeIcon(
      Text(
        'Like',
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    ),
  );

  final facebookReactions = [
    Reaction( // ignore: missing_required_param
      previewIcon: _buildPreviewIcon('assets/like.gif'),
      icon: _buildLikeIconFill(
        Text(
          'Like',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: colorPrimary,
          ),
        ),
      ),
    ),
    Reaction( // ignore: missing_required_param
      previewIcon: _buildPreviewIcon('assets/love.gif'),
      icon: _buildIcon(
        'assets/love.png',
        Text(
          'Love',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Color(0XFFed5168),
          ),
        ),
      ),
    ),
    Reaction( // ignore: missing_required_param
      previewIcon: _buildPreviewIcon('assets/wow.gif'),
      icon: _buildIcon(
        'assets/wow.png',
        Text(
          'Wow',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Color(0XFFffda6b),
          ),
        ),
      ),
    ),
    Reaction( // ignore: missing_required_param
      previewIcon: _buildPreviewIcon('assets/haha.gif'),
      icon: _buildIcon(
        'assets/haha.png',
        Text(
          'Haha',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Color(0XFFffda6b),
          ),
        ),
      ),
    ),
    Reaction( // ignore: missing_required_param
      previewIcon: _buildPreviewIcon('assets/sad.gif'),
      icon: _buildIcon(
        'assets/sad.png',
        Text(
          'Sad',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Color(0XFFffda6b),
          ),
        ),
      ),
    ),
    Reaction( // ignore: missing_required_param
      previewIcon: _buildPreviewIcon('assets/angry.gif'),
      icon: _buildIcon(
        'assets/angry.png',
        Text(
          'Angry',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Color(0XFFf05766),
          ),
        ),
      ),
    ),
  ];

  static Widget _buildPreviewIcon(String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
      child: Image.asset(path, height: 40),
    );
  }

  static Widget _buildIcon(String path, Text text) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Image.asset(path, height: 20),
          SizedBox(
            width: 16.0,
          ),
          text,
        ],
      ),
    );
  }

  static Widget _buildLikePreviewIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
      child: Icon(Icons.thumb_up, size: 40.0),
    );
  }

  static Widget _buildLikeIcon(Text text) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.thumb_up,
            size: 20.0,
            color: Colors.grey.shade600,
          ),
          SizedBox(
            width: 16.0,
          ),
          text,
        ],
      ),
    );
  }

  static Widget _buildLikeIconFill(Text text) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.thumb_up,
            size: 20.0,
            color: Color(0xff205A72),
          ),
          SizedBox(
            width: 16.0,
          ),
          text,
        ],
      ),
    );
  }

  Widget _createSampleNewsFeedData(int index) {
    var notification = notifications[index];
//    print('${notification.uploads.length} X $index');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 4.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 56.0,
                    width: 56.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorPrimary,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/guardian.png'),
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'GUARDIAN COMMAND AND CONTROL',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: colorPrimary),
                      ),
                      Text(
                        notification.date,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: colorPrimary,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              ClipOval(
                child: Material(
                  color: Colors.white, // button color
                  child: InkWell(
                    splashColor: Colors.grey.shade300, // inkwell color
                    child: SizedBox(
                      width: 36.0,
                      height: 36.0,
                      child: Icon(
                        Icons.menu,
                        color: colorPrimary,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: (notification.uploads.length == 0) ? false : true,
          child: Flexible(
            fit: FlexFit.loose,
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/loading.gif',
              image: (notification.uploads.length == 0)
                  ? 'https://vignette.wikia.nocookie.net/codegeass/images/7/7'
                  'e/1295504746.jpg/revision/latest/scale-to-width-down/340?'
                  'cb=20140311192830'
                  : notification.uploads[0].fileFullPath,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          color: Colors.grey.shade300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                notification.title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              Text(
                'Affected/Reference Area',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              Text(
                (notification.affectedAreas.length == 0)
                    ? 'N/A'
                    : notification.affectedAreas[0].location,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey.shade500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    (notification.body == null)
                        ? ''
                        : notification.body,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Text(
                    'read more...',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: colorPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey.shade500,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/love.png',
                    height: 12.0,
                    width: 12.0,
                  ),
                  Image.asset(
                    'assets/haha.png',
                    height: 12.0,
                    width: 12.0,
                  ),
                  Image.asset(
                    'assets/wow.png',
                    height: 12.0,
                    width: 12.0,
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    '3.7K',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: colorPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '323 Comments',
                style: TextStyle(
                  fontSize: 12.0,
                  color: colorPrimary,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '260 Shares',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: colorPrimary,
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Text(
                    '1M Views',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: colorPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey.shade500,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlutterReactionButtonCheck(
                onReactionChanged: (reaction, isChecked) {
                  print('reaction changed at ${reaction.id}');
                },
                reactions: facebookReactions,
                initialReaction: defaultInitialReaction,
                selectedReaction: Reaction( // ignore: missing_required_param
                  icon: _buildLikeIconFill(
                    Text(
                      'Like',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: colorPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(pi),
                      child: Icon(
                        Icons.message,
                        color: colorPrimary,
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      'Comment',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: colorPrimary),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 36.0,
                      width: 36.0,
                      padding: EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/upload.svg',
                        color: colorPrimary,
                        height: 16.0,
                        width: 16.0,
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      'Share',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: colorPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 4.0,
          width: double.infinity,
          color: Colors.grey.shade500,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return (index == 0)
            ? SizedBox(
                child: Announcements(228.0),
                height: 228.0,
              )
            : _createSampleNewsFeedData(index - 1);
      },
      itemCount: notifications.length + 1,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
    );
  }
}
