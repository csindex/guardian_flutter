import 'package:GUARDIAN/reporting/dialog-search-opcen.dart';
import 'package:GUARDIAN/utils/dialogs/dialog-create-account.dart';
import 'package:GUARDIAN/utils/dialogs/dialog-send-otp.dart';
import 'package:flutter/material.dart';

class DialogHelper {

  static login(context) => showDialog(context: context, builder: (context) =>
      CreateAccountDialog());

  static createAccount(context) => showDialog(context: context, builder: (context) =>
      SendOtpDialog());



  static sendReport(context, location, type) => showDialog(context: context, builder: (context) =>
      SearchOpcenDialog(location, type));
}