import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'utils/constants/utils.dart';


class RecommendedPages extends StatelessWidget {

  final List<String> _list = [
    'assets/images/mandaue-seal.png',
    'assets/images/mcpo.png',
    'assets/images/naga.png',
    'assets/images/talisay-city-cebu.png',
    'assets/images/talisay-city-negros-occ.jpg',
  ];

  final List<String> _name = [
    'Bantay Mandaue Command Center',
    'Mandaue City Police Office',
    'Naga CDRRMO',
    'C4 Talisay Command Center',
    'City of Talisay City Negros CDRRMO',
  ];

  final double _height;

  RecommendedPages(this._height);

  Widget _createSampleRecommendedPage() {
    final index = Random().nextInt(5);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                _list[index],
                width: 220.0,
                height: 200.0,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                _name[index],
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              Text(
                '3K Volunteers 200 Responders',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Container(
                width: 220.0,
                height: 56.0,
                child: RaisedButton(
                  child: Text(
                    'LIKE & FOLLOW',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  color: colorPrimary,
                  splashColor: Colors.grey.shade500,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: Column(
      children: <Widget>[
        Container(
          height: _height - 4.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              _createSampleRecommendedPage(),
              _createSampleRecommendedPage(),
              _createSampleRecommendedPage(),
              _createSampleRecommendedPage(),
              _createSampleRecommendedPage(),
              _createSampleRecommendedPage(),
              _createSampleRecommendedPage(),
              _createSampleRecommendedPage(),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          height: 4.0,
          color: Colors.grey,
        ),
      ],
    ),
  );

}
