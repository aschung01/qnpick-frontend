// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionPreview _$QuestionPreviewFromJson(Map<String, dynamic> json) =>
    QuestionPreview(
      id: json['id'] as int,
      type: json['type'] as int,
      category: json['category'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
    );

Map<String, dynamic> _$QuestionPreviewToJson(QuestionPreview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'category': instance.category,
      'title': instance.title,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'deadline': instance.deadline?.toIso8601String(),
    };
