import 'package:json_annotation/json_annotation.dart';

part 'community.g.dart';

@JsonSerializable(fieldRename:FieldRename.snake)
class QuestionPreview {
  /// The generated code assumes these values exist in JSON.
  final int id, type, category;
  final String title, content;
  final DateTime createdAt;

  final DateTime? deadline;

  /// The generated code below handles if the corresponding JSON value doesn't
  /// exist or is empty.

  QuestionPreview({
    required this.id,
    required this.type,
    required this.category,
    required this.title,
    required this.content,
    required this.createdAt,
    this.deadline,
  });

  /// Connect the generated [_$QuestionPreviewFromJson] function to the `fromJson`
  /// factory.
  factory QuestionPreview.fromJson(Map<String, dynamic> json) =>
      _$QuestionPreviewFromJson(json);

  /// Connect the generated [_$QuestionPreviewToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QuestionPreviewToJson(this);
}
