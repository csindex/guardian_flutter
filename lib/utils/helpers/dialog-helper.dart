import '../../reporting/dialog-search-opcen.dart';
import '../../utils/dialogs/dialog-create-account.dart';
import '../../utils/dialogs/dialog-send-otp2.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static login(context) =>
      showDialog(context: context, builder: (context) => CreateAccountDialog());

  static createAccount(context) =>
      showDialog(context: context, builder: (context) => SendOtpDialog2());

  static sendRegCode(context, isLoading) =>
      showDialog(context: context, builder: (context) => SendOtpDialog2());

  static sendReport(context, location, type) => showDialog(
      context: context,
      builder: (context) => SearchOpcenDialog(location, type));
}
