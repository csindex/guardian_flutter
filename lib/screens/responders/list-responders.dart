import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/utils.dart';
import '../../utils/constants/common-methods.dart';
import '../../provider/user/viewmodel-user.dart';
import '../../provider/user/viewmodel-user-profile.dart';
import 'responder.dart';


class RespondersList extends StatefulWidget {
  final String token;
  final UserProfileViewModel userVM;
  final UserViewModel vm;
  final String origin;
  final List<UserProfileViewModel> responderList;

  RespondersList({
    this.token, this.responderList, this.vm, this.userVM, this.origin});

  @override
  _RespondersListState createState() => _RespondersListState();
}

class _RespondersListState extends State<RespondersList> {
  List<UserProfileViewModel> _responderList = List<UserProfileViewModel>();

  void _fetchResponders() {
    fetchUsers().then((value) {
      print('fetchResponders - $value');
      setState(() {
        _responderList = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _responderList = widget.responderList;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: colorPrimary,
      onRefresh: refresh,
      child: Responder(
        responderList: _responderList,
        vm: widget.vm,
        userVM: widget.userVM,
        token: widget.token,
        origin: widget.origin,
      ),
    );
  }

  Future<void> refresh() {
    _fetchResponders();
    return Future.value();
  }
}
