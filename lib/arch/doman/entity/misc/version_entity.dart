import 'package:equatable/equatable.dart';
import 'package:hukum_pro/generated/json/base/json_convert_content.dart';

// ignore: must_be_immutable
class VersionEntity extends Equatable with JsonConvert<VersionEntity> {
  VersionDetailEntity? detail;
  int? milis;
  String? timestamp;

  @override
  List<Object?> get props => [detail, milis, timestamp];
}

// ignore: must_be_immutable
class VersionDetailEntity extends Equatable
    with JsonConvert<VersionDetailEntity> {
  List<String>? filenames;

  @override
  List<Object?> get props => [filenames];
}
