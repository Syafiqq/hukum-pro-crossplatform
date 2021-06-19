import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'law_menu_order_entity.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class LawMenuOrderEntity extends Equatable {
  final String id;
  final String? name;
  final int? order;

  LawMenuOrderEntity(this.id, this.name, this.order);

  @override
  List<Object?> get props => [id];

  factory LawMenuOrderEntity.fromJson(Map json) =>
      _$LawMenuOrderEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LawMenuOrderEntityToJson(this);
}
