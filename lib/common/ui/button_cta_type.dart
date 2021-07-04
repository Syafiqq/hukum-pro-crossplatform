import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'button_cta_type.freezed.dart';

@freezed
class ButtonCtaType with _$ButtonCtaType {
  const factory ButtonCtaType.outline(bool disabled, Color color) =
      ButtonCtaTypeOutline;

  const factory ButtonCtaType.solid(bool disabled, Color color) =
      ButtonCtaTypeSolid;
}
