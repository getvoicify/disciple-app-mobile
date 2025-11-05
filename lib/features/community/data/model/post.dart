import 'package:disciple/features/notes/data/model/scripture_reference.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
abstract class Post with _$Post {
  const factory Post({
    String? id,
    String? title,
    String? content,
    String? authorId,
    String? churchId,
    String? status,
    DateTime? publishedAt,
    String? image,
    @Default([]) List<String> tags,
    @Default([]) List<String> categories,
    @Default([]) List<ScriptureReference> scriptureReferences,
    String? seriesId,
    String? seriesName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
