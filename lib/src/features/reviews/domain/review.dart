import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
/// Product review data
class Review {
  const Review({
    required this.score,
    required this.comment,
    required this.date,
  });
  final double score; // from 1 to 5
  final String comment;
  final DateTime date;

  @override
  String toString() => 'Review(score: $score, comment: $comment, date: $date)';

  @override
  bool operator ==(covariant Review other) {
    if (identical(this, other)) return true;

    return other.score == score &&
        other.comment == comment &&
        other.date == date;
  }

  @override
  int get hashCode => score.hashCode ^ comment.hashCode ^ date.hashCode;

  Review copyWith({
    double? score,
    String? comment,
    DateTime? date,
  }) {
    return Review(
      score: score ?? this.score,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'score': score,
      'comment': comment,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      score: map['score'] as double,
      comment: map['comment'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) =>
      Review.fromMap(json.decode(source) as Map<String, dynamic>);
}
