import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/constants/utils.dart';
import '../data/user/data-experience.dart';

class ExpandableDropDownExperience extends StatefulWidget {
  ExpandableDropDownExperience(this.experience);

  final List<ExperienceData> experience;

  @override
  _ExpandableDropDownExperienceState createState() =>
      new _ExpandableDropDownExperienceState();
}

class _ExpandableDropDownExperienceState
    extends State<ExpandableDropDownExperience>
    with TickerProviderStateMixin<ExpandableDropDownExperience> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    var expCtr = widget.experience.length;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.grey)),
        padding: EdgeInsets.all(16.0),
        child: (expCtr == 0)
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Experiences / Trainings',
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
                        'Experiences / Trainings',
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
                    duration: const Duration(milliseconds: 350),
                    child: new ConstrainedBox(
                      constraints: _isExpanded
                          ? new BoxConstraints()
                          : new BoxConstraints(maxHeight: 0.0),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return _createExperienceItem(index);
                        },
                        itemCount: expCtr,
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

  Widget _createExperienceItem(int index) {
    var item = widget.experience[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: (index != 0),
          child: Column(
            children: [
              SizedBox(
                height: 8.0,
              ),
              Container(
                color: Colors.grey,
                height: 0.5,
              ),
              SizedBox(
                height: 8.0,
              ),
            ],
          ),
        ),
        Text(
          item.company,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Position',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 4.0,
            ),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Location',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 4.0,
            ),
            Text(
              item.location,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
