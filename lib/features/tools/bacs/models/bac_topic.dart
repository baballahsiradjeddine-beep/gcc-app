import 'dart:ui';

class BacTopic {
  final int id;
  final String name;
  final List<Color> colors;

  BacTopic({
    required this.id,
    required this.name,
    required this.colors,
  });

  factory BacTopic.fromJson(Map<String, dynamic> json) {
    return BacTopic(
      id: json['id'] as int,
      name: json['name'] as String,
      colors: (json['colors'] as List<dynamic>?)
              ?.map((e) => Color(
                  int.parse((e as String).replaceFirst('#', ''), radix: 16) +
                      0xFF000000))
              .toList() ??
          [],
    );
  }
}
