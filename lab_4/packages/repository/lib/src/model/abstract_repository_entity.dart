import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part '../../generated/src/model/abstract_repository_entity.g.dart';


@immutable
@HiveType(typeId: 0)
@JsonSerializable()
class AbstractRepositoryEntity extends Equatable{
  const AbstractRepositoryEntity({
    required this.id,
    required this.userId,
    required this.updatedAt
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String updatedAt;

  Map<String, dynamic> toJson() => _$AbstractRepositoryEntityToJson(this);

  factory AbstractRepositoryEntity.fromJson(Map<String, dynamic>? entity)
    => _$AbstractRepositoryEntityFromJson(entity!);

  @override
  List<Object?> get props => [id, userId, updatedAt];

}