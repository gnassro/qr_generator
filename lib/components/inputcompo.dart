import 'package:flutter/material.dart';
import '../tools/colors.dart';


class InputCompo {

  final Color? _whiteColor = HexColor().whiteColor();
  final Color? _primaryTextColor = HexColor().primaryTextColor();
  final Color? _primaryTextColorFaded = HexColor().primaryTextColorFaded();

  Widget builder ({void Function(String)? onChanged}) {
    return IntrinsicWidth(
        child: TextFormField(
          onChanged: (text) {onChanged!(text);},
          decoration:  InputDecoration(
            fillColor: _whiteColor,
            filled: true,
            labelText: 'Text to Generate',
            labelStyle: TextStyle(
              color: _primaryTextColor,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: _primaryTextColorFaded!,
                width: 1
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: _primaryTextColorFaded!,
                  width: 1.8
              ),
            )
          ),
        )
    );
  }
}