import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/constants/utils.dart';
import '../data/user/data-education.dart';

class ExpandableDropDownEducation extends StatefulWidget {
  ExpandableDropDownEducation(this.education);

  final List<EducationData> education;

  @override
  _ExpandableDropDownEducationState createState() =>
      new _ExpandableDropDownEducationState();
}

class _ExpandableDropDownEducationState
    extends State<ExpandableDropDownEducation>
    with TickerProviderStateMixin<ExpandableDropDownEducation> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    var edCtr = widget.education.length;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey),
        ),
        padding: EdgeInsets.all(16.0),
        child: (edCtr == 0)
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Education',
                    style: TextStyle(
                      color: colorPrimary,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    'Nothing to show',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Education',
                        style: TextStyle(
                          color: colorPrimary,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ClipOval(
                        child: Material(
                          color: Colors.grey.shade100, // button color
                          child: InkWell(
                            splashColor: Colors.grey, // inkwell color
                            child: SizedBox(
                              width: 36.0,
                              height: 36.0,
                              child: Icon(
                                (_isExpanded)
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: colorPrimary,
                              ),
                            ),
                            onTap: () =>
                                setState(() => _isExpanded = !_isExpanded),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  AnimatedSize(
                    vsync: this,
                    duration: Duration(milliseconds: 350),
                    child: ConstrainedBox(
                      constraints: _isExpanded
                          ? BoxConstraints()
                          : BoxConstraints(maxHeight: 0.0),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return _createEducationItem(index);
                        },
                        itemCount: edCtr,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _createEducationItem(int index) {
    var item = widget.education[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.school,
          style: TextStyle(
            fontSize: 18.0,
            color: colorPrimary1,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          (item.current || item.dateTo == null)
              ? '${DateFormat('yyyy/MM/dd').format(DateTime.parse(item.dateFrom))} - Now'
              : '${DateFormat('yyyy/MM/dd').format(DateTime.parse(item.dateFrom))} - '
                  '${DateFormat('yyyy/MM/dd').format(DateTime.parse(item.dateTo))}',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Degree',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 4.0,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                item.degree,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Field of Study',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 4.0,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                item.fieldOfStudy,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Description',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 4.0,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                item.description,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
