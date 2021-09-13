import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../utils/constants/utils.dart';
import '../../utils/helpers/navigation-helper.dart';
import '../../services/socket-service.dart';

class MessengerMain extends StatefulWidget {
  final String token;

  MessengerMain({Key key, this.token,}) : super(key: key);

  @override
  _MessengerMainState createState() => _MessengerMainState();
}

class _MessengerMainState extends State<MessengerMain>
    with AutomaticKeepAliveClientMixin<MessengerMain> {

  SocketService socketService;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    socketService = injector.get<SocketService>();
    socketService.createSocketConnection();
  }

  @override
  void dispose() {
    socketService.clearSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: colorPrimary,
      onRefresh: (){},
      child: Container(
        color: Colors.grey.shade100,
      ),
    );
  }
}
