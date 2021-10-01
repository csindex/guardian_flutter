import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../main.dart';
import '../../utils/constants/utils.dart';
import '../../utils/loading.dart';
import '../../utils/helpers/navigation-helper.dart';
import '../../data/messenger/data-responder.dart';
import '../../provider/messenger/viewmodel-conversation.dart';
import '../../provider/messenger/viewmodel-conversations-list.dart';
import '../../widgets/messenger/chat-head.dart';
import '../../widgets/messenger/online-responders.dart';
import '../../services/socket-service.dart';
import './conversation-screen.dart';

class MessengerMain extends StatefulWidget {
  final String token;
  final String userId;

  MessengerMain({Key key, this.token, this.userId}) : super(key: key);

  @override
  _MessengerMainState createState() => _MessengerMainState();
}

class _MessengerMainState extends State<MessengerMain>
    with AutomaticKeepAliveClientMixin<MessengerMain> {

  SocketService _socketService;
  IO.Socket _socket;

  String _opcenId;
  List<ResponderData> _oRList = <ResponderData>[];
  List<ConversationViewModel> _cList = <ConversationViewModel>[];

  bool _isLoading = true;
  bool _isConversation = false;

  Future<ResponderData> _fetchOpcenIdApi() async {
    final url = Uri.parse('$secretHollowsEndPoint/api/responder/user/${widget.userId}');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'x-auth-token': widget.token,
      },
    );
    if (response.statusCode == 200) {
      print('resp - ${response.body}');
      final Iterable body = jsonDecode(response.body);
      return body.map((it) => ResponderData.fromJsonMap(it)).first;
    } else {
      throw Exception("Failed to fetch resp!");
    }
  }

  void _fetchOpcenId() {
    _fetchOpcenIdApi().then((value) {
      setState(() {
        _opcenId = value.opcen;
      });
    });
  }

  void _fetchConversations() {
    final vm = Provider.of<ConversationsListViewModel>(context, listen: false);
    vm.fetchConversations(widget.token, widget.userId).then((value) {
      print('conv: $value');
      setState(() {
        _cList.clear();
        _cList.addAll(value);
        _isLoading = false;
      });
    });
  }

  Future<List<ResponderData>> _fetchOpcenRespondersApi() async {
    final url = Uri.parse('$secretHollowsEndPoint/api/responder/$_opcenId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'x-auth-token': widget.token,
      },
    );
    if (response.statusCode == 200) {
      print('opcen resp - ${response.body}');
      final Iterable body = jsonDecode(response.body);
      return body.map((it) => ResponderData.fromJsonMap(it)).toList();
    } else {
      throw Exception("Failed to fetch opcen resp!");
    }
  }

  void _fetchOpcenResponders(List<OnlineResponder> rList) {
    _fetchOpcenRespondersApi().then((value) {
      final List<ResponderData> tmpList = <ResponderData>[];
      tmpList.addAll(value);
      final List<ResponderData> tmpORList = <ResponderData>[];
      for (int i = 0; i < rList.length; i++) {
        var or = rList[i];
        for (var x in tmpList) {
          if (or.respId == x.rUser.userId && or.respId != widget.userId) {
            print('ben${or.respId} x ${x.rUser.userId} x ben${widget.userId}');
            tmpORList.add(x);
          }
        }
      }
      setState(() {
        _isLoading = false;
        _oRList.clear();
        _oRList.addAll(tmpORList);
      });
    });
    // });
  }

  Future<void> _refresh() {
    setState(() {
      print('ONLINE ${_oRList.length}');
      _isLoading = true;
    });
    print('refresh called');
    _fetchConversations();
    return Future.value();
  }

  Future<void> _refresh2() {
    // setState(() {
    //   print('ONLINE ${_oRList.length}');
    //   _isLoading = true;
    // });
    print('refresh2 called');
    _fetchConversations();
    return Future.value();
  }

  void _openConversation(ConversationViewModel c) {
    if(c != null) {
      NavigationHelper.openConversations(context, widget.token, widget.userId,
        c.conversationId, c.resp, c.messages, _fetchConversations, _socket);
    } else {

    }
  }

  Widget _createConversationItem(int index) {
    var c = _cList[index];
    return GestureDetector(
      onTap: () {
        print('tap ta tap ta tap!');
        _openConversation(c);
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 4.0,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0,),
          child: Row(
            children: [
              ChatHead(url: c.senderProfilePic),
              hSpacer(16.0),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.senderName,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: colorPrimary
                      ),
                    ),
                    Text(
                      c.lastMsg,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _fetchOpcenId();

    _socketService = injector.get<SocketService>();

    _socket = _socketService.createSocketConnection();

    _socket.onConnect((h) {
      print('socket connected - $h');
      _socket.emit('addUser', ['${widget.userId}']);
    });
    _socket.onError((data) => print('socket error - $data'));
    _socket.onDisconnect((_) => print('socket disconnected'));

    _socket.on('getMessage', (val) {
      print('getMessage $val');
      _refresh2();
    });

    _socket.on('getUsers', (resp) {
      print('r Online - ${resp.toString()
          .replaceAll("user", "\"user\"")
          .replaceAll("socketId", "\"socketId\"")
          .replaceAll(": ", ": \"").replaceAll("},", "\"},")
          .replaceAll(", \"", "\", \"").replaceAll("}]", "\"}]")}');
      final Iterable body = jsonDecode(resp.toString()
          .replaceAll("user", "\"user\"")
          .replaceAll("socketId", "\"socketId\"")
          .replaceAll(": ", ": \"").replaceAll("},", "\"},")
          .replaceAll(", \"", "\", \"").replaceAll("}]", "\"}]"));
      final rList = body.map((data) => OnlineResponder.fromJsonMap(data)).toList();
      _fetchOpcenResponders(rList);
      // setState(() {
      //   _oRList.clear();
      //   _oRList.addAll(rList);
      // });
    });

    _fetchConversations();
  }

  @override
  void dispose() {
    _socketService.clearSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _isLoading ?
    Loading() : _isConversation ?
    ConversationScreen() :
    RefreshIndicator(
      color: Colors.white,
      backgroundColor: colorPrimary,
      onRefresh: _refresh,
      child: Container(
        color: Colors.grey.shade100,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return (index == 0) ?
            Container(
              color: colorPrimary,
              padding: EdgeInsets.symmetric(vertical: 8.0,),
              child: Center(
                child: Text(
                  'Online Responders',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ) : (index == 1) ?
            OnlineResponders(
                oRList: _oRList, token: widget.token, opcenId: _opcenId) :
            (_cList.isEmpty) ?
            Container(
              child : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Choose a TEAM member/group to start a conversation.',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ) : _createConversationItem(index - 2);
          },
          itemCount: (_cList.isEmpty) ? 3 : _cList.length + 2,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
        ),
      ),
    );
  }
}

class OnlineResponder {

  String socketId;
  String respId;

  OnlineResponder.fromJsonMap(Map<String, dynamic> map) :
        socketId = map["socketId"],
        respId = map["user"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = respId;
    data['socketId'] = socketId;
    return data;
  }

}