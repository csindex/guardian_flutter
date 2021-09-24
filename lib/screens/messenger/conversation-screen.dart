import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../utils/constants/utils.dart';
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

  ConversationScreen({this.token, this.userId, this.cId,
    this.rData, this.msgList, this.refresh});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  
  double _msgWidth = 0.0;

  Widget _createConversationItem(int index) {
    // ex. index = 0.
    var length = widget.msgList.length;
    var newIndex = length - 1 - index;
    var x = widget.msgList[newIndex];
    if (x.msg.endsWith('.png') || x.msg.endsWith('.mp4')) {
      if (x.senderId == widget.userId) {
        return _getMsgUSolo(x);
      } else {
        return _getMsgRSolo(x);
      }
    } else {
      if (x.senderId == widget.userId) {
        var ni = l - 2 - i;
        if (newI == 0 && l != 1) {
          if (ni > -1) {
            var nxtI = widget.msgList[ni];
            if (nxtI.senderId == widget.userId) {
              var format = DateFormat("HH:mm");
              var one = format.parse(x.updatedAt);
              var two = format.parse(nxtI.updatedAt);
              print('${one.difference(two)}');
              return _getMsgUSolo(x);
            } else {
              return _getMsgUSolo(x);
            }
          } else {
            var li = l - i;
            if (li != l) {
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
                  return _getMsgULst(x);
                } else {
                  return _getMsgUSolo(x);
                }
              } else {
                return _getMsgUSolo(x);
              }
            } else {
              return _getMsgUSolo(x);
            }
          }
        } else if (newI != (l - 1)) {
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
              var pi = l - i;
              if (pi != l) {
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
                    return _getMsgUMid(x);
                  } else {
                    return _getMsgUFrst(x);
                  }
                } else {
                  return _getMsgUFrst(x);
                }
              } else {
                return _getMsgUSolo(x);
              }
            } else {
              var pi = l - i;
              if (pi != l) {
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
                    return _getMsgULst(x);
                  } else {
                    return _getMsgUSolo(x);
                  }
                } else {
                  return _getMsgUFrst(x);
                }
              } else {
                return _getMsgUSolo(x);
              }
            }
          } else {
            var pi = l - i;
            if (pi != l) {
              var prvI = widget.msgList[pi];
              if (prvI.senderId == widget.userId) {
                return _getMsgULst(x);
              } else {
                return _getMsgUSolo(x);
              }
            } else {
              return _getMsgUSolo(x);
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
              var pi = l - i;
              if (pi != l) {
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
                    return _getMsgUMid(x);
                  } else {
                    return _getMsgUFrst(x);
                  }
                } else {
                  return _getMsgUFrst(x);
                }
              } else {
                return _getMsgUFrst(x);
              }
            } else {
              return _getMsgUSolo(x);
            }
          } else {
            return _getMsgUSolo(x);
          }
        }
      } else {
        var rId = widget.rData.rUser.userId;
        if (newI == 0 && l != 1) {
          var ni = l - 2 - i;
          if (ni > -1) {
            var nxtI = widget.msgList[l - 2 - i];
            if (nxtI.senderId == rId) {
              var format = DateFormat("MMMM d, y hh:mm:ss a");
              var one = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                  DateTime.parse(x.updatedAt)));
              var two = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                  DateTime.parse(nxtI.updatedAt)));
              print('${one.difference(two)}');
              return _getMsgRSolo(x);
            } else {
              return _getMsgRSolo(x);
            }
          } else {
            var pi = l - i;
            if (pi != l) {
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
                  return _getMsgRLst(x);
                } else {
                  return _getMsgRSolo(x);
                }
              } else {
                return _getMsgRSolo(x);
              }
            } else {
              return _getMsgRSolo(x);
            }
          }
        } else if (newI != (l - 1)) {
          var nxtI = widget.msgList[l - 2 - i];
          if (nxtI.senderId == rId) {
            var format = DateFormat("MMMM d, y hh:mm:ss a");
            var one = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                DateTime.parse(x.updatedAt)));
            var two = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                DateTime.parse(nxtI.updatedAt)));
            if (one
                .difference(two)
                .inSeconds < 60) {
              var pi = l - i;
              if (pi != l) {
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
                    return _getMsgRMid(x);
                  } else {
                    return _getMsgRFrst(x);
                  }
                } else {
                  return _getMsgRFrst(x);
                }
              } else {
                return _getMsgRSolo(x);
              }
            } else {
              var pi = l - i;
              if (pi != l) {
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
                    return _getMsgRLst(x);
                  } else {
                    return _getMsgRSolo(x);
                  }
                } else {
                  return _getMsgRFrst(x);
                }
              } else {
                return _getMsgRSolo(x);
              }
            }
          } else {
            var li = l - i;
            if (li != l) {
              var prvI = widget.msgList[li];
              if (prvI.senderId == rId) {
                return _getMsgRLst(x);
              } else {
                return _getMsgRSolo(x);
              }
            } else {
              return _getMsgRSolo(x);
            }
          }
        } else {
          var ni = l - 2 - i;
          if (ni > -1) {
            var nxtI = widget.msgList[l - 2 - i];
            if (nxtI.senderId == rId) {
              var format = DateFormat("MMMM d, y hh:mm:ss a");
              var one = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                  DateTime.parse(x.updatedAt)));
              var two = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                  DateTime.parse(nxtI.updatedAt)));
              if (one
                  .difference(two)
                  .inSeconds < 60) {
                var pi = l - i;
                if (pi != l) {
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
                      return _getMsgRMid(x);
                    } else {
                      return _getMsgRFrst(x);
                    }
                  } else {
                    return _getMsgRFrst(x);
                  }
                } else {
                  return _getMsgRFrst(x);
                }
              } else {
                return _getMsgRSolo(x);
              }
            } else {
              return _getMsgRSolo(x);
            }
          } else {
            var pi = l - i;
            if (pi != l) {
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
                  return _getMsgRLst(x);
                } else {
                  return _getMsgRSolo(x);
                }
              } else {
                return _getMsgRSolo(x);
              }
            } else {
              return _getMsgRFrst(x);
            }
          }
        }
      }
    }
  }

  Widget _createConversationItem2(int i) {
    var l = widget.msgList.length;
    var newI = l - 1 - i;
    var x = widget.msgList[newI];
    if (x.msg.endsWith('.png') || x.msg.endsWith('.mp4')) {
      if (x.senderId == widget.userId) {
        return _getMsgUSolo(x);
      } else {
        return _getMsgRSolo(x);
      }
    } else {
      if (x.senderId == widget.userId) {
        var ni = l - 2 - i;
        if (newI == 0 && l != 1) {
          if (ni > -1) {
            var nxtI = widget.msgList[ni];
            if (nxtI.senderId == widget.userId) {
              var format = DateFormat("HH:mm");
              var one = format.parse(x.updatedAt);
              var two = format.parse(nxtI.updatedAt);
              print('${one.difference(two)}');
              return _getMsgUSolo(x);
            } else {
              return _getMsgUSolo(x);
            }
          } else {
            var li = l - i;
            if (li != l) {
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
                  return _getMsgULst(x);
                } else {
                  return _getMsgUSolo(x);
                }
              } else {
                return _getMsgUSolo(x);
              }
            } else {
              return _getMsgUSolo(x);
            }
          }
        } else if (newI != (l - 1)) {
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
              var pi = l - i;
              if (pi != l) {
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
                    return _getMsgUMid(x);
                  } else {
                    return _getMsgUFrst(x);
                  }
                } else {
                  return _getMsgUFrst(x);
                }
              } else {
                return _getMsgUSolo(x);
              }
            } else {
              var pi = l - i;
              if (pi != l) {
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
                    return _getMsgULst(x);
                  } else {
                    return _getMsgUSolo(x);
                  }
                } else {
                  return _getMsgUFrst(x);
                }
              } else {
                return _getMsgUSolo(x);
              }
            }
          } else {
            var pi = l - i;
            if (pi != l) {
              var prvI = widget.msgList[pi];
              if (prvI.senderId == widget.userId) {
                return _getMsgULst(x);
              } else {
                return _getMsgUSolo(x);
              }
            } else {
              return _getMsgUSolo(x);
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
              var pi = l - i;
              if (pi != l) {
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
                    return _getMsgUMid(x);
                  } else {
                    return _getMsgUFrst(x);
                  }
                } else {
                  return _getMsgUFrst(x);
                }
              } else {
                return _getMsgUFrst(x);
              }
            } else {
              return _getMsgUSolo(x);
            }
          } else {
            return _getMsgUSolo(x);
          }
        }
      } else {
        var rId = widget.rData.rUser.userId;
        if (newI == 0 && l != 1) {
          var ni = l - 2 - i;
          if (ni > -1) {
            var nxtI = widget.msgList[l - 2 - i];
            if (nxtI.senderId == rId) {
              var format = DateFormat("MMMM d, y hh:mm:ss a");
              var one = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                  DateTime.parse(x.updatedAt)));
              var two = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                  DateTime.parse(nxtI.updatedAt)));
              print('${one.difference(two)}');
              return _getMsgRSolo(x);
            } else {
              return _getMsgRSolo(x);
            }
          } else {
            var pi = l - i;
            if (pi != l) {
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
                  return _getMsgRLst(x);
                } else {
                  return _getMsgRSolo(x);
                }
              } else {
                return _getMsgRSolo(x);
              }
            } else {
              return _getMsgRSolo(x);
            }
          }
        } else if (newI != (l - 1)) {
          var nxtI = widget.msgList[l - 2 - i];
          if (nxtI.senderId == rId) {
            var format = DateFormat("MMMM d, y hh:mm:ss a");
            var one = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                DateTime.parse(x.updatedAt)));
            var two = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                DateTime.parse(nxtI.updatedAt)));
            if (one
                .difference(two)
                .inSeconds < 60) {
              var pi = l - i;
              if (pi != l) {
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
                    return _getMsgRMid(x);
                  } else {
                    return _getMsgRFrst(x);
                  }
                } else {
                  return _getMsgRFrst(x);
                }
              } else {
                return _getMsgRSolo(x);
              }
            } else {
              var pi = l - i;
              if (pi != l) {
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
                    return _getMsgRLst(x);
                  } else {
                    return _getMsgRSolo(x);
                  }
                } else {
                  return _getMsgRFrst(x);
                }
              } else {
                return _getMsgRSolo(x);
              }
            }
          } else {
            var li = l - i;
            if (li != l) {
              var prvI = widget.msgList[li];
              if (prvI.senderId == rId) {
                return _getMsgRLst(x);
              } else {
                return _getMsgRSolo(x);
              }
            } else {
              return _getMsgRSolo(x);
            }
          }
        } else {
          var ni = l - 2 - i;
          if (ni > -1) {
            var nxtI = widget.msgList[l - 2 - i];
            if (nxtI.senderId == rId) {
              var format = DateFormat("MMMM d, y hh:mm:ss a");
              var one = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                  DateTime.parse(x.updatedAt)));
              var two = format.parse(DateFormat("MMMM d, y hh:mm:ss a").format(
                  DateTime.parse(nxtI.updatedAt)));
              if (one
                  .difference(two)
                  .inSeconds < 60) {
                var pi = l - i;
                if (pi != l) {
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
                      return _getMsgRMid(x);
                    } else {
                      return _getMsgRFrst(x);
                    }
                  } else {
                    return _getMsgRFrst(x);
                  }
                } else {
                  return _getMsgRFrst(x);
                }
              } else {
                return _getMsgRSolo(x);
              }
            } else {
              return _getMsgRSolo(x);
            }
          } else {
            var pi = l - i;
            if (pi != l) {
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
                  return _getMsgRLst(x);
                } else {
                  return _getMsgRSolo(x);
                }
              } else {
                return _getMsgRSolo(x);
              }
            } else {
              return _getMsgRFrst(x);
            }
          }
        }
      }
    }
  }

  Widget _getMsgLayout(MessageData c, int type) => (c.senderId == widget.userId) ?
  Align(
    alignment: Alignment.centerRight,
    child: c.msg.endsWith('.png') ?
    Container(
      constraints: BoxConstraints(
        minHeight: (_msgWidth * 0.75), minWidth: (_msgWidth * 0.5),
        maxHeight: (_msgWidth * 1.25), maxWidth: (_msgWidth * 0.75),
      ),
      margin: EdgeInsets.only(bottom: 4.0, top: 4.0,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
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
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
      child: ChatVideo(url: '$secretHollowsEndPoint5/${c.msg}'),
    ) :
    Container(
      constraints: BoxConstraints(maxWidth: _msgWidth,),
      margin: EdgeInsets.only(bottom: 4.0, top: 4.0,),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0,),
      decoration: BoxDecoration(
        color: colorPrimary,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
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
  ) : Container(
    margin: EdgeInsets.only(top: 4.0, bottom: 4.0,),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 16.0,
          foregroundImage: NetworkImage('$secretHollowsEndPoint5/${widget.rData.profile.profilePic}'),
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
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
            ),
            child: ChatVideo(url: '$secretHollowsEndPoint5/${c.msg}')
        ) :
        Container(
          constraints: BoxConstraints(maxWidth: _msgWidth,),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0,),
          decoration: BoxDecoration(
              color: dialogColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),)
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

  Widget _getMsgUSolo(MessageData c) => Align(
    alignment: Alignment.centerRight,
    child: c.msg.endsWith('.png') ?
    Container(
      constraints: BoxConstraints(
        minHeight: (_msgWidth * 0.75), minWidth: (_msgWidth * 0.5),
        maxHeight: (_msgWidth * 1.25), maxWidth: (_msgWidth * 0.75),
      ),
      margin: EdgeInsets.only(bottom: 4.0, top: 4.0,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
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
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
      child: ChatVideo(url: '$secretHollowsEndPoint5/${c.msg}'),
    ) :
    Container(
      constraints: BoxConstraints(maxWidth: _msgWidth,),
      margin: EdgeInsets.only(bottom: 4.0, top: 4.0,),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0,),
      decoration: BoxDecoration(
        color: colorPrimary,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
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
  );

  Widget _getMsgULst(MessageData c) => Align(
    alignment: Alignment.centerRight,
    child: Container(
      constraints: BoxConstraints(maxWidth: _msgWidth,),
      margin: EdgeInsets.only(bottom: 2.0, top: 4.0,),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0,),
      decoration: BoxDecoration(
          color: colorPrimary,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0), bottomRight: Radius.circular(4.0),
            bottomLeft: Radius.circular(20.0),)
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
  );

  Widget _getMsgUMid(MessageData c) => Align(
    alignment: Alignment.centerRight,
    child: Container(
      constraints: BoxConstraints(maxWidth: _msgWidth,),
      margin: EdgeInsets.only(bottom: 2.0,),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0,),
      decoration: BoxDecoration(
          color: colorPrimary,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
            topRight: Radius.circular(4.0), bottomRight: Radius.circular(4.0),
            bottomLeft: Radius.circular(20.0),)
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
  );

  Widget _getMsgUFrst(MessageData c) => Align(
    alignment: Alignment.centerRight,
    child: Container(
      constraints: BoxConstraints(maxWidth: _msgWidth,),
      margin: EdgeInsets.only(bottom: 4.0,),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0,),
      decoration: BoxDecoration(
          color: colorPrimary,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
            topRight: Radius.circular(4.0), bottomRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),)
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
  );

  Widget _getMsgRSolo(MessageData c) => Container(
    margin: EdgeInsets.only(top: 4.0, bottom: 4.0,),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 16.0,
          foregroundImage: NetworkImage('$secretHollowsEndPoint5/${widget.rData.profile.profilePic}'),
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
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
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
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
            ),
          ),
          child: ChatVideo(url: '$secretHollowsEndPoint5/${c.msg}')
        ) :
        Container(
          constraints: BoxConstraints(maxWidth: _msgWidth,),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0,),
          decoration: BoxDecoration(
              color: dialogColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),)
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

  Widget _getMsgRLst(MessageData c) => Container(
    margin: EdgeInsets.only(top: 4.0, bottom: 2.0,),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        /*CircleAvatar(
          radius: 16.0,
          foregroundImage: NetworkImage('$secretHollowsEndPoint5/${widget.rData.profile.profilePic}'),
          backgroundImage: AssetImage('assets/images/guardian.png'),
        ),*/
        hSpacer(40.0),
        Container(
          constraints: BoxConstraints(maxWidth: _msgWidth,),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0,),
          decoration: BoxDecoration(
              color: dialogColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(4.0),)
          ),
          child: Text(
            c.msg,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _getMsgRMid(MessageData c) => Container(
    margin: EdgeInsets.only(bottom: 2.0,),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        /*CircleAvatar(
          radius: 16.0,
          foregroundImage: NetworkImage('$secretHollowsEndPoint5/${widget.rData.profile.profilePic}'),
          backgroundImage: AssetImage('assets/images/guardian.png'),
        ),*/
        hSpacer(40.0),
        Container(
          constraints: BoxConstraints(maxWidth: _msgWidth,),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0,),
          decoration: BoxDecoration(
              color: dialogColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0),
                topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(4.0),)
          ),
          child: Text(
            c.msg,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _getMsgRFrst(MessageData c) => Container(
    margin: EdgeInsets.only(bottom: 4.0,),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 16.0,
          foregroundImage: NetworkImage('$secretHollowsEndPoint5/${widget.rData.profile.profilePic}'),
          backgroundImage: AssetImage('assets/images/guardian.png'),
        ),
        hSpacer(8.0),
        Container(
          constraints: BoxConstraints(maxWidth: _msgWidth,),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0,),
          decoration: BoxDecoration(
              color: dialogColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0),
                topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),)
          ),
          child: Text(
            c.msg,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                  SizedBox(width: 8.0),
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
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0,),
                color: Colors.grey.shade100,
                child: ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return /*Container(
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
                    ) : */_createConversationItem(index);
                  },
                  itemCount: widget.msgList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              ),
            ),
            Container(height: 56.0, color: colorPrimary,),
          ],
        ),
      ),
    );
  }
  
}
