import 'package:flutter/material.dart';

import '../utils/constants/utils.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text);

  final String text;

  @override
  _ExpandableTextState createState() => new _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    var textLength = widget.text.length;
    var textNumLines = '\n'.allMatches(widget.text).length + 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 350),
          child: new ConstrainedBox(
            constraints: _isExpanded
                ? new BoxConstraints()
                : new BoxConstraints(maxHeight: 56.0),
            child: GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: new Text(
                widget.text,
                softWrap: true,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: (textNumLines > 4 || textLength > 100) ? true : false,
          child: GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Text(
              _isExpanded ? '' : 'read more...',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: colorPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
