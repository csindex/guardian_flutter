import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget _icon(double icW, double icH) => Image.asset(
      'assets/images/guardian.png',
      height: icH,
      width: icW,
      fit: BoxFit.fitWidth,
    );

Widget _label() => Column(
      children: [
        Text(
          'GUARDIAN',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2.5,
          ),
        ),
        Text(
          'Emergency Response',
          style: TextStyle(
            fontSize: 10.0,
            color: Colors.white,
            letterSpacing: 2.5,
            wordSpacing: 4.0,
          ),
        ),
      ],
    );

Widget header(double icW, double icH) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 32.0,
        ),
        // TODO : Icon
        _icon(icW, icH),
        SizedBox(
          height: 16.0,
        ),
        // TODO : Label
        _label(),
      ],
    );
