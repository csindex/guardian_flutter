import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants/utils.dart';
import '../../utils/loading.dart';
import '../../data/messenger/data-responder.dart';
import '../../widgets/messenger/chat-head.dart';
import '../../screens/messenger/messenger-main.dart';


class OnlineResponders extends StatefulWidget {

  final List<ResponderData> oRList;
  final String opcenId;
  final String token;

  OnlineResponders({this.oRList, this.opcenId, this.token});

  @override
  _OnlineRespondersState createState() => _OnlineRespondersState();
}

class _OnlineRespondersState extends State<OnlineResponders> {

  bool _isLoading = false;
  // List<ResponderData> _oRList = <ResponderData>[];

  Widget _createOnlineResponderItem(int index) {
    var r = widget.oRList[index];
    print('o-r $r');
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 4.0, horizontal: 16.0,
      ),
      child: ChatHead(
        url: r.profile.profilePic,
        fName: r.rUser.name,
        lName: r.rUser.lname,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('o-r build ${widget.oRList.length}');
    return _isLoading ?
    Loading() : (widget.oRList.isEmpty) ?
    Container(
      height: 120.0,
      color: Colors.grey.shade100,
      child: Center(
        child: Text(
          'Oops! It seems that responders are offline.',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    ) :
    Container(
      height: 120.0,
      color: Colors.grey.shade100,
      margin: EdgeInsets.only(top: 4.0,),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return _createOnlineResponderItem(index);
        },
        itemCount: widget.oRList.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    );
  }

}
