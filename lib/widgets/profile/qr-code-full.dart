import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/constants/utils.dart';

class QrCodeFull extends StatelessWidget {
  final String userId;

  QrCodeFull({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: colorPrimary,
        child: Center(
          child: QrImage(
            data: userId,
            version: QrVersions.auto,
            gapless: false,
            embeddedImage: AssetImage('assets/images/guardian.png'),
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: Size(64.0, 64.0),
            ),
          ),
        ),
      ),
    );
  }
}
