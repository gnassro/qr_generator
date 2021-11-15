import 'package:flutter/material.dart';
import 'package:qrgenerator/library/global_colors.dart' as global_colors;


class InputCompo {

  Widget builder ({void Function(String)? onChanged}) {
    return IntrinsicWidth(
        child: TextFormField(
          onChanged: (text) {onChanged!(text);},
          decoration:  InputDecoration(
            fillColor: global_colors.whiteColor!,
            filled: true,
            labelText: 'Text to Generate',
            labelStyle: const TextStyle(
              color: global_colors.primaryColor,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: global_colors.primaryFadedColor!,
                width: 1
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: global_colors.primaryFadedColor!,
                  width: 1.8
              ),
            )
          ),
        )
    );
  }
}