import 'package:equatable/equatable.dart';
import 'package:hukum_pro/generated/json/base/json_convert_content.dart';

class VersionEntity extends Equatable with JsonConvert<VersionEntity> {
  late final VersionDetailEntity? detail;
  late final int? milis;
  late final String? timestamp;

  @override
  List<Object?> get props => [detail, milis, timestamp];
}

class VersionDetailEntity extends Equatable with JsonConvert<VersionDetailEntity> {
  late final List<String>? filenames;

  @override
  List<Object?> get props => [filenames];
}
