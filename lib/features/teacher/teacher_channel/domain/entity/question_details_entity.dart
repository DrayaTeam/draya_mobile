import "package:draya_mobile/features/teacher/teacher_channel/domain/entity/question_entity.dart";
import "package:draya_mobile/features/teacher/teacher_channel/domain/entity/reply_entity.dart";

class QuestionDetailsEntity {
  final QuestionEntity question;
  final List<ReplyEntity> replies;

  const QuestionDetailsEntity({
    required this.question,
    required this.replies,
  });
}
