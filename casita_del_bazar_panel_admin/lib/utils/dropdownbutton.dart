import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatelessWidget {
  final String hintTextValue;
  final double hintFontSize;
  final double iconSize;
  final double fontSize;
  final ValueChanged<T> onChanged;
  final List<DropdownMenuItem<T>> items;
  final T value;

  DropdownWidget(
      {this.fontSize = 17,
      this.hintFontSize = 20,
      this.hintTextValue = '',
      this.iconSize = 35,
      this.onChanged,
      this.value,
      @required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 311,
      // width: double.infinity,
      child: DropdownButtonFormField<T>(
          value: value,
          //elevation: 16,
          isExpanded: true,
          dropdownColor: Colors.white,
          //isDense: false,
          icon: Icon(
            Icons.arrow_downward,
          ),
          hint: Text(hintTextValue),
          style: TextStyle(
            fontSize: fontSize,
          ),
          onChanged: onChanged,
          items: items),
    );
  }
}
