import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

import '../../utils/constants/utils.dart';
import '../../services/web-service.dart';
import '../../data/messenger/data-responder.dart';
import '../../data/messenger/data-message.dart';
import '../../widgets/messenger/chat-video.dart';


class ConversationScreen extends StatefulWidget {

  final String token;
  final String userId;
  final String cId;
  final ResponderData rData;
  final List<MessageData> msgList;
  final Function refresh;
  final IO.Socket socket;
  // final Function isTyping;
  // final ValueChanged<bool> startTyping;

  ConversationScreen({this.token, this.userId, this.cId,
    this.rData, this.msgList, this.refresh, this.socket});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  IO.Socket _s;
  
  double _msgWidth = 0.0;

  List<MessageData> tmpLst = <MessageData>[];

  String _msg = '';

  TextEditingController _msgController;
  bool _isLoading = false;

  Widget _createConversationItem(int index) {
    var length = tmpLst.length;
    var newIndex = length - 1 - index;
    var currItem = tmpLst[newIndex];
    if (currItem.msg.endsWith('.png') ||
        currItem.msg.endsWith('.mp4') ||
        length == 1) {
      print('if 1');
      return _getMsgLayout(currItem, 0);
    } else {
      print('else 1 - ${currItem.msg}');
      var nextIndex = length - 2 - index;
      var prevIndex = length - index;
      var currItemSender = currItem.senderId;

      var format = DateFormat("MMMM d, y hh:mm:ss a");

      print('INDEX: $prevIndex - $newIndex - $nextIndex - $length');

      if (prevIndex < length) {
        var prevItem = tmpLst[prevIndex];
        if (nextIndex > 0) {
          var nextItem = tmpLst[nextIndex];
          if ((prevItem.msg.endsWith('.png') || prevItem.msg.endsWith('.mp4'))
              && (nextItem.msg.endsWith('.png') ||
                  nextItem.msg.endsWith('.mp4'))) {
            return _getMsgLayout(currItem, 0);
          } else if (prevItem.msg.endsWith('.png') ||
              prevItem.msg.endsWith('.mp4')) {
            var nextItemSender = nextItem.senderId;
            if (currItemSender == nextItemSender) {
              var currItemTime = format.parse(format.format(
                DateTime.parse(currItem.updatedAt),),);
              var nextItemTime = format.parse(format.format(
                DateTime.parse(nextItem.updatedAt),),);
              var diffCurrNext = currItemTime
                  .difference(nextItemTime)
                  .inSeconds;
              if (diffCurrNext < 60) {
                return _getMsgLayout(currItem, 1);
              } else {
                return _getMsgLayout(currItem, 0);
              }
            } else {
              return _getMsgLayout(currItem, 0);
            }
          } else if (nextItem.msg.endsWith('.png') ||
              nextItem.msg.endsWith('.png')) {
            var prevItemSender = prevItem.senderId;
            if (prevItemSender == currItemSender) {
              var prevItemTime = format.parse(format.format(
                DateTime.parse(prevItem.updatedAt),),);
              var currItemTime = format.parse(format.format(
                DateTime.parse(currItem.updatedAt),),);
              var diffPrevCurr = prevItemTime
                  .difference(currItemTime)
                  .inSeconds;
              if (diffPrevCurr < 60) {
                return _getMsgLayout(currItem, 10);
              } else {
                return _getMsgLayout(currItem, 0);
              }
            } else {
              return _getMsgLayout(currItem, 0);
            }
          } else {
            var prevItemSender = prevItem.senderId;
            var nextItemSender = nextItem.senderId;
            if (prevItemSender == currItemSender &&
                currItemSender == nextItemSender) {
              var prevItemTime = format.parse(format.format(
                DateTime.parse(prevItem.updatedAt),),);
              var currItemTime = format.parse(format.format(
                DateTime.parse(currItem.updatedAt),),);
              var nextItemTime = format.parse(format.format(
                DateTime.parse(nextItem.updatedAt),),);
              var diffPrevCurr = prevItemTime.difference(currItemTime).inSeconds;
              var diffCurrNext = currItemTime.difference(nextItemTime).inSeconds;
              print('Prev-$diffPrevCurr x Next-$diffCurrNext');
              if ((diffPrevCurr < 60) && (diffCurrNext < 60)) {
                return _getMsgLayout(currItem, 5);
              } else if (diffPrevCurr < 60 && diffCurrNext > 59) {
                return _getMsgLayout(currItem, 10);
              } else if (diffPrevCurr > 59 && diffCurrNext < 60) {
                return _getMsgLayout(currItem, 1);
              } else {
                return _getMsgLayout(currItem, 0);
              }
            } else if (prevItemSender != currItemSender &&
                currItemSender == nextItemSender) {
              var currItemTime = format.parse(format.format(
                DateTime.parse(currItem.updatedAt),),);
              var nextItemTime = format.parse(format.format(
                DateTime.parse(nextItem.updatedAt),),);
              var diffCurrNext = currItemTime.difference(nextItemTime).inSeconds;
              if (diffCurrNext < 60) {
                return _getMsgLayout(currItem, 1);
              } else {
                return _getMsgLayout(currItem, 0);
              }
            } else if (prevItemSender == currItemSender &&
                currItemSender != nextItemSender) {
              var prevItemTime = format.parse(format.format(
                DateTime.parse(prevItem.updatedAt),),);
              var currItemTime = format.parse(format.format(
                DateTime.parse(currItem.updatedAt),),);
              var diffPrevCurr = prevItemTime.difference(currItemTime).inSeconds;
              if (diffPrevCurr < 60) {
                return _getMsgLayout(currItem, 10);
              } else {
                return _getMsgLayout(currItem, 0);
              }
            } else {
              return _getMsgLayout(currItem, 0);
            }
          }
        } else {
          if (prevItem.msg.endsWith('.png') || prevItem.msg.endsWith('.mp4')) {
            return _getMsgLayout(currItem, 0);
          } else {
            var prevItemSender = prevItem.senderId;
            if (prevItemSender == currItemSender) {
              var prevItemTime = format.parse(format.format(
                DateTime.parse(prevItem.updatedAt),),);
              var currItemTime = format.parse(format.format(
                DateTime.parse(currItem.updatedAt),),);
              var diffPrevCurr = prevItemTime.difference(currItemTime).inSeconds;
              if (diffPrevCurr < 60) {
                return _getMsgLayout(currItem, 10);
              } else {
                return _getMsgLayout(currItem, 0);
              }
            } else {
              return _getMsgLayout(currItem, 0);
            }
          }
        }
      } else {
        var nextItem = tmpLst[nextIndex];
        if (nextItem.msg.endsWith('.png') || nextItem.msg.endsWith('.mp4')) {
          return _getMsgLayout(currItem, 0);
        } else {
          var nextItemSender = nextItem.senderId;
          if (currItemSender == nextItemSender) {
            var currItemTime = format.parse(format.format(
              DateTime.parse(currItem.updatedAt),),);
            var nextItemTime = format.parse(format.format(
              DateTime.parse(nextItem.updatedAt),),);
            var diffCurrNext = currItemTime.difference(nextItemTime).inSeconds;
            if (diffCurrNext < 60) {
              return _getMsgLayout(currItem, 1);
            } else {
              return _getMsgLayout(currItem, 0);
            }
          } else {
            return _getMsgLayout(currItem, 0);
          }
        }
      }
    }
  }

  /*Widget _createConversationItem2(int index) {
    // ex. index = 0.
    var length = widget.msgList.length;
    var newIndex = length - 1 - index;
    var x = widget.msgList[newIndex];
    if (x.msg.endsWith('.png') || x.msg.endsWith('.mp4')) {
      return _getMsgLayout(x, 0,);
    } else {
      if (x.senderId == widget.userId) {
        var ni = length - 2 - index;
        if (newIndex == 0 && length != 1) {
          if (ni > -1) {
            var nxtI = widget.msgList[ni];
            if (nxtI.senderId == widget.userId) {
              var format = DateFormat("HH:mm");
              var one = format.parse(x.updatedAt);
              var two = format.parse(nxtI.updatedAt);
              print('${one.difference(two)}');
              return _getMsgLayout(x, 0);
            } else {
              return _getMsgLayout(x, 0);
            }
          } else {
            var li = length - index;
            if (li != length) {
              var prvI = widget.msgList[li];
              if (prvI.senderId == widget.userId) {
                var format = DateFormat("MMMM d, y hh:mm:ss a");
                var one = format.parse(
                    DateFormat("MMMM d, y hh:mm:ss a").format(
                        DateTime.parse(prvI.updatedAt)));
                var two = format.parse(
                    DateFormat("MMMM d, y hh:mm:ss a").format(
                        DateTime.parse(x.updatedAt)));
                if (one
                    .difference(two)
                    .inSeconds < 60) {
                  return _getMsgLayout(x, 10);
                } else {
                  return _getMsgLayout(x, 0);
                }
              } else {
                return _getMsgLayout(x, 0);
              }
            } else {
              return _getMsgLayout(x, 0);
            }
          }
        } else if (newIndex != (length - 1)) {
          var nxtI = widget.msgList[ni];
          if (nxtI.senderId == widget.userId) {
            var format = DateFormat("MMMM d, y hh:mm:ss a");
            var one = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                DateTime.parse(x.updatedAt)));
            var two = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                DateTime.parse(nxtI.updatedAt)));
            if (one
                .difference(two)
                .inSeconds < 60) {
              var pi = length - index;
              if (pi != length) {
                var prvI = widget.msgList[pi];
                if (prvI.senderId == widget.userId) {
                  var format = DateFormat("MMMM d, y hh:mm:ss a");
                  var one = format.parse(
                      DateFormat("MMMM d, y hh:mm:ss a").format(
                          DateTime.parse(prvI.updatedAt)));
                  var two = format.parse(
                      DateFormat("MMMM d, y hh:mm:ss a").format(
                          DateTime.parse(x.updatedAt)));
                  if (one
                      .difference(two)
                      .inSeconds < 60) {
                    return _getMsgLayout(x, 5);
                  } else {
                    return _getMsgLayout(x, 1);
                  }
                } else {
                  return _getMsgLayout(x, 0);
                }
              } else {
                return _getMsgLayout(x, 0);
              }
            } else {
              var pi = length - index;
              if (pi != length) {
                var prvI = widget.msgList[pi];
                if (prvI.senderId == widget.userId) {
                  var format = DateFormat("MMMM d, y hh:mm:ss a");
                  var one = format.parse(
                      DateFormat("MMMM d, y hh:mm:ss a").format(
                          DateTime.parse(prvI.updatedAt)));
                  var two = format.parse(
                      DateFormat("MMMM d, y hh:mm:ss a").format(
                          DateTime.parse(x.updatedAt)));
                  if (one
                      .difference(two)
                      .inSeconds < 60) {
                    return _getMsgLayout(x, 10);
                  } else {
                    return _getMsgLayout(x, 0);
                  }
                } else {
                  return _getMsgLayout(x, 1);
                }
              } else {
                return _getMsgLayout(x, 0);
              }
            }
          } else {
            var pi = length - index;
            if (pi != length) {
              var prvI = widget.msgList[pi];
              if (prvI.senderId == widget.userId) {
                return _getMsgLayout(x, 10);
              } else {
                return _getMsgLayout(x, 0);
              }
            } else {
              return _getMsgLayout(x, 0);
            }
          }
        } else {
          var nxtI = widget.msgList[ni];
          if (nxtI.senderId == widget.userId) {
            var format = DateFormat("MMMM d, y hh:mm:ss a");
            var one = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                DateTime.parse(x.updatedAt)));
            var two = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                DateTime.parse(nxtI.updatedAt)));
            if (one
                .difference(two)
                .inSeconds < 60) {
              var pi = length - index;
              if (pi != length) {
                var prvI = widget.msgList[pi];
                if (prvI.senderId == widget.userId) {
                  var format = DateFormat("MMMM d, y hh:mm:ss a");
                  var one = format.parse(
                      DateFormat("MMMM d, y hh:mm:ss a").format(
                          DateTime.parse(prvI.updatedAt)));
                  var two = format.parse(
                      DateFormat("MMMM d, y hh:mm:ss a").format(
                          DateTime.parse(x.updatedAt)));
                  if (one
                      .difference(two)
                      .inSeconds < 60) {
                    return _getMsgLayout(x, 5);
                  } else {
                    return _getMsgLayout(x, 1);
                  }
                } else {
                  return _getMsgLayout(x, 1);
                }
              } else {
                return _getMsgLayout(x, 1);
              }
            } else {
              return _getMsgLayout(x, 0);
            }
          } else {
            return _getMsgLayout(x, 0);
          }
        }
      } else {
        var rId = widget.rData.rUser.userId;
        if (newIndex == 0 && length != 1) {
          var ni = length - 2 - index;
          if (ni > -1) {
            var nxtI = widget.msgList[length - 2 - index];
            if (nxtI.senderId == rId) {
              var format = DateFormat("MMMM d, y hh:mm:ss a");
              var one = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                  DateTime.parse(x.updatedAt)));
              var two = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                  DateTime.parse(nxtI.updatedAt)));
              print('${one.difference(two)}');
              return _getMsgLayout(x, 0);
            } else {
              return _getMsgLayout(x, 0);
            }
          } else {
            var pi = length - index;
            if (pi != length) {
              var prvI = widget.msgList[pi];
              if (prvI.senderId == rId) {
                var format = DateFormat("MMMM d, y hh:mm:ss a");
                var one = format.parse(
                    DateFormat("MMMM d, y hh:mm:ss a").format(
                        DateTime.parse(prvI.updatedAt)));
                var two = format.parse(
                    DateFormat("MMMM d, y hh:mm:ss a").format(
                        DateTime.parse(x.updatedAt)));
                if (one
                    .difference(two)
                    .inSeconds < 60) {
                  return _getMsgLayout(x, 10);
                } else {
                  return _getMsgLayout(x, 0);
                }
              } else {
                return _getMsgLayout(x, 0);
              }
            } else {
              return _getMsgLayout(x, 0);
            }
          }
        } else if (newIndex != (length - 1)) {
          var nxtI = widget.msgList[length - 2 - index];
          if (nxtI.senderId == rId) {
            var format = DateFormat("MMMM d, y hh:mm:ss a");
            var one = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                DateTime.parse(x.updatedAt)));
            var two = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                DateTime.parse(nxtI.updatedAt)));
            if (one
                .difference(two)
                .inSeconds < 60) {
              var pi = length - index;
              if (pi != length) {
                var prvI = widget.msgList[pi];
                if (prvI.senderId == rId) {
                  var format = DateFormat("MMMM d, y hh:mm:ss a");
                  var one = format.parse(
                      DateFormat("MMMM d, y hh:mm:ss a").format(
                          DateTime.parse(prvI.updatedAt)));
                  var two = format.parse(
                      DateFormat("MMMM d, y hh:mm:ss a").format(
                          DateTime.parse(x.updatedAt)));
                  if (one
                      .difference(two)
                      .inSeconds < 60) {
                    return _getMsgLayout(x, 5);
                  } else {
                    return _getMsgLayout(x, 1);
                  }
                } else {
                  return _getMsgLayout(x, 1);
                }
              } else {
                return _getMsgLayout(x, 0);
              }
            } else {
              var pi = length - index;
              if (pi != length) {
                var prvI = widget.msgList[pi];
                if (prvI.senderId == rId) {
                  var format = DateFormat("MMMM d, y hh:mm:ss a");
                  var one = format.parse(
                      DateFormat("MMMM d, y hh:mm:ss a").format(
                          DateTime.parse(prvI.updatedAt)));
                  var two = format.parse(
                      DateFormat("MMMM d, y hh:mm:ss a").format(
                          DateTime.parse(x.updatedAt)));
                  if (one.difference(two).inSeconds < 60) {
                    return _getMsgLayout(x, 10);
                  } else {
                    return _getMsgLayout(x, 0);
                  }
                } else {
                  return _getMsgLayout(x, 1);
                }
              } else {
                return _getMsgLayout(x, 0);
              }
            }
          } else {
            var li = length - index;
            if (li != length) {
              var prvI = widget.msgList[li];
              if (prvI.senderId == rId) {
                return _getMsgLayout(x, 10);
              } else {
                return _getMsgLayout(x, 0);
              }
            } else {
              return _getMsgLayout(x, 0);
            }
          }
        } else {
          var ni = length - 2 - index;
          if (ni > -1) {
            var nxtI = widget.msgList[length - 2 - index];
            if (nxtI.senderId == rId) {
              var format = DateFormat("MMMM d, y hh:mm:ss a");
              var one = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                  DateTime.parse(x.updatedAt)));
              var two = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                  DateTime.parse(nxtI.updatedAt)));
              if (one.difference(two).inSeconds < 60) {
                var pi = length - index;
                if (pi != length) {
                  var prvI = widget.msgList[pi];
                  if (prvI.senderId == rId) {
                    var format = DateFormat("MMMM d, y hh:mm:ss a");
                    var one = format.parse(
                        DateFormat("MMMM d, y hh:mm:ss a").format(
                            DateTime.parse(prvI.updatedAt)));
                    var two = format.parse(
                        DateFormat("MMMM d, y hh:mm:ss a").format(
                            DateTime.parse(x.updatedAt)));
                    if (one.difference(two).inSeconds < 60) {
                      return _getMsgLayout(x, 5);
                    } else {
                      return _getMsgLayout(x, 1);
                    }
                  } else {
                    return _getMsgLayout(x, 1);
                  }
                } else {
                  return _getMsgLayout(x, 1);
                }
              } else {
                return _getMsgLayout(x, 0);
              }
            } else {
              return _getMsgLayout(x, 0);
            }
          } else {
            var pi = length - index;
            if (pi != length) {
              var prvI = widget.msgList[pi];
              if (prvI.senderId == rId) {
                var format = DateFormat("MMMM d, y hh:mm:ss a");
                var one = format.parse(
                    DateFormat("MMMM d, y hh:mm:ss a").format(
                        DateTime.parse(prvI.updatedAt)));
                var two = format.parse(
                    DateFormat("MMMM d, y hh:mm:ss a").format(
                        DateTime.parse(x.updatedAt)));
                if (one
                    .difference(two)
                    .inSeconds < 60) {
                  return _getMsgLayout(x, 10);
                } else {
                  return _getMsgLayout(x, 0);
                }
              } else {
                return _getMsgLayout(x, 0);
              }
            } else {
              return _getMsgLayout(x, 1);
            }
          }
        }
      }
    }
  }*/

  Widget _getMsgLayout(MessageData c, int type) {
    var r = 24.0;
    return (c.senderId == widget.userId) ?
    Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: c.msg.endsWith('.png') ?
        Container(
          constraints: BoxConstraints(
            minHeight: (_msgWidth * 0.75), minWidth: (_msgWidth * 0.5),
            maxHeight: (_msgWidth * 1.25), maxWidth: (_msgWidth * 0.75),
          ),
          margin: EdgeInsets.only(bottom: 4.0, top: 4.0,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(r),
              topRight: Radius.circular(r),
              bottomRight: Radius.circular(r),
              bottomLeft: Radius.circular(r),
            ),
          ),
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/loading.gif',
            image: '$secretHollowsEndPoint5/${c.msg}',
            fit: BoxFit.contain,
          ),
        ) : (c.msg.endsWith('.mp4')) ?
        Container(
          constraints: BoxConstraints(
            minHeight: (_msgWidth * 0.75), minWidth: (_msgWidth * 0.5),
            maxHeight: (_msgWidth * 1.5), maxWidth: _msgWidth,
          ),
          margin: EdgeInsets.only(bottom: 4.0, top: 4.0,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(r),
              topRight: Radius.circular(r),
              bottomRight: Radius.circular(r),
              bottomLeft: Radius.circular(r),
            ),
          ),
          child: ChatVideo(url: '$secretHollowsEndPoint5/${c.msg}'),
        ) :
        Container(
          constraints: BoxConstraints(maxWidth: _msgWidth,),
          margin: (type == 10) ? EdgeInsets.only(bottom: 2.0, top: 4.0,) :
          (type == 1) ? EdgeInsets.only(bottom: 4.0,) :
          (type == 5) ? EdgeInsets.only(bottom: 2.0,) :
          EdgeInsets.only(bottom: 4.0, top: 4.0,),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0,),
          decoration: BoxDecoration(
            color: colorPrimary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(r),
              topRight: (type == 1 || type == 5) ?
              Radius.circular(4.0) : Radius.circular(r),
              bottomRight: (type == 10 || type == 5) ?
              Radius.circular(4.0) : Radius.circular(r),
              bottomLeft: Radius.circular(r),
            ),
          ),
          child: Text(
            c.msg,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ) : Container(
      padding: EdgeInsets.only(left: 16.0,),
      margin: (type == 10) ? EdgeInsets.only(bottom: 2.0, top: 4.0,) :
      (type == 1) ? EdgeInsets.only(bottom: 4.0,) :
      (type == 5) ? EdgeInsets.only(bottom: 2.0,) :
      EdgeInsets.only(bottom: 4.0, top: 4.0,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          (type == 10 || type == 5) ? hSpacer(32.0,) :
          CircleAvatar(
            radius: 16.0,
            foregroundImage: NetworkImage('$secretHollowsEndPoint5/'
                '${widget.rData.profile.profilePic}'),
            backgroundImage: AssetImage('assets/images/guardian.png'),
          ),
          hSpacer(8.0),
          c.msg.endsWith('.png') ?
          Container(
            constraints: BoxConstraints(
              minHeight: (_msgWidth * 0.75), minWidth: (_msgWidth * 0.5),
              maxHeight: (_msgWidth * 1.25), maxWidth: (_msgWidth * 0.75),
            ),
            margin: EdgeInsets.only(bottom: 4.0, top: 4.0,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(r),
                topRight: Radius.circular(r),
                bottomRight: Radius.circular(r),
                bottomLeft: Radius.circular(r),
              ),
            ),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/loading.gif',
              image: '$secretHollowsEndPoint5/${c.msg}',
              fit: BoxFit.contain,
            ),
          ) : (c.msg.endsWith('.mp4')) ?
          Container(
              constraints: BoxConstraints(
                minHeight: (_msgWidth * 0.75), minWidth: (_msgWidth * 0.5),
                maxHeight: (_msgWidth * 1.25), maxWidth: (_msgWidth * 0.75),
              ),
              margin: EdgeInsets.only(bottom: 4.0, top: 4.0,),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(r),
                  topRight: Radius.circular(r),
                  bottomRight: Radius.circular(r),
                  bottomLeft: Radius.circular(r),
                ),
              ),
              child: ChatVideo(url: '$secretHollowsEndPoint5/${c.msg}'),
          ) :
          Container(
            constraints: BoxConstraints(maxWidth: _msgWidth,),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0,),
            decoration: BoxDecoration(
                color: dialogColor,
                borderRadius: BorderRadius.only(
                  topLeft: (type == 1 || type == 5) ?
                  Radius.circular(4.0) : Radius.circular(r),
                  topRight: Radius.circular(r),
                  bottomRight: Radius.circular(r),
                  bottomLeft: (type == 10 || type == 5) ?
                  Radius.circular(4.0) : Radius.circular(r),
                ),
            ),
            child: Flexible(
              child: Text(
                c.msg,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshMessages() async {
    final msgList = await Webservice().fetchMessages(widget.token, widget.cId);
    if (msgList.isNotEmpty) {
      setState(() {
        tmpLst.clear();
        tmpLst.addAll(msgList);
      });
    }
    return Future.value();
  }

  Future<String> _sendMessageApi() async {
    var url = Uri.parse('$secretHollowsEndPoint/api/messages_res');
    Map data = {
      'sender': widget.userId,
      "text": _msg,
      "conversationId": widget.cId,
    };
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
    print('report r: $response X ${response.body}');
    return response.body;
  }

  void _sendMessage() {
    setState(() {
      _isLoading = true;
    });
    _sendMessageApi().then((val) {
      if (!val.contains('error')) {
        Map<String, String> p = {
          'senderId': widget.userId,
          'receiverId': widget.rData.rUser.userId,
          'text': _msg,
        };
        _s.emit('sendMessage', p);
        setState(() {
          _isLoading = false;
          _msgController.clear();
        });
        _refreshMessages();
      }
    });
  }

  @override
  void initState() {
    print('init');
    tmpLst = widget.msgList;
    _s = widget.socket;
    _s.on('getUsers', (resp) {
      print('conversation-screen - ${resp.toString()
          .replaceAll("user", "\"user\"")
          .replaceAll("socketId", "\"socketId\"")
          .replaceAll(": ", ": \"").replaceAll("},", "\"},")
          .replaceAll(", \"", "\", \"").replaceAll("}]", "\"}]")}');
    });
    _s.on('getMessage', (val) {
      print('getMessageCon $val');
      _refreshMessages();
    });
    _s.on('typing', (val) {
      print('typing--$val');
    });
    _msgController = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _msgWidth = (MediaQuery.of(context).size.width * 2.0) / 3.0;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 56.0,
              color: colorPrimary,
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  hSpacer(8.0),
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
                            color: Colors.white,
                            size: 24.0,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  hSpacer(8.0),
                  Expanded(
                    child: Text(
                      '${widget.rData.rUser.name} ${widget.rData.rUser.lname}',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0,),
                color: Colors.grey.shade100,
                child: ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return _createConversationItem(index);
                  },
                  itemCount: widget.msgList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0,),
              height: 48.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(36.0),
                  topRight: Radius.circular(36.0), bottomRight: Radius.circular(36.0),
                  bottomLeft: Radius.circular(36.0),
                ),
                color: Colors.grey.shade300,
              ),
              child: Row(
                children: [
                  hSpacer(8.0),
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
                            FontAwesomeIcons.camera,
                            color: colorPrimary,
                            size: 24.0,
                          ),
                        ),
                        onTap: () {
                          // Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  // hSpacer(2.0),
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
                            FontAwesomeIcons.paperclip,
                            color: colorPrimary,
                            size: 24.0,
                          ),
                        ),
                        onTap: () {
                          // Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  hSpacer(4.0),
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      onChanged: (val) {
                        setState(() {
                          _msg = val;
                        });
                      },
                      decoration: new InputDecoration.collapsed(
                        hintText: 'Type a message',
                      ),
                    ),
                  ),
                  hSpacer(8.0),
                  /*ClipOval(
                    child: Material(
                      color: colorPrimary, // button color
                      child: InkWell(
                        splashColor: Colors.grey, // inkwell color
                        child: Container(
                          width: 36.0,
                          height: 36.0,
                          alignment: Alignment.center,
                          child: FaIcon(
                            FontAwesomeIcons.solidPaperPlane,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                        onTap: () {
                          // Navigator.pop(context);
                        },
                      ),
                    ),
                  ),*/
                  GestureDetector(
                    onTap: () {
                      _sendMessage();
                      // print('send button pressed'
                      //     '\n{senderId: ${widget.userId}, ${widget.rData.rUser.userId}, text: sampolll}');
                      // Map<String, String> p = {
                      //   'senderId': widget.userId,
                      //   'receiverId': widget.rData.rUser.userId,
                      //   'text': 'sampoooollll',
                      // };
                      // _s.emit('sendMessage', p);
                    },
                    child: Container(
                      height: 36.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(36.0),
                          topRight: Radius.circular(36.0), bottomRight: Radius.circular(36.0),
                          bottomLeft: Radius.circular(36.0),
                        ),
                        color: colorPrimary,
                      ),
                      child: _isLoading ?
                      CircularProgressIndicator() :
                      Row(
                        children: [
                          hSpacer(8.0),
                          FaIcon(
                            FontAwesomeIcons.solidPaperPlane,
                            color: Colors.white,
                            size: 12.0,
                          ),
                          hSpacer(8.0),
                          Text(
                            'Send',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          hSpacer(12.0),
                        ],
                      ),
                    ),
                  ),
                  hSpacer(8.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
