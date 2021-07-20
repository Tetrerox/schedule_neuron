import 'package:equatable/equatable.dart';

class SingleStickyNote extends Equatable{
  final String text;
  final String category;

  SingleStickyNote({required this.text, required this.category});

  @override
  List<Object> get props => [text, category];

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'category': category,
    };
  }

  SingleStickyNote.fromMap(Map<dynamic, dynamic> map)
      : text = map['text'],
        category = map['category'];

  String toString() {
    return '($text, $category)';
  }
}
