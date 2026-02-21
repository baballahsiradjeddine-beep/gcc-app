class NotificationModel {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final String time;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.time,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      isRead: json['is_read'],
      time: json['time']
    );
  }


  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    bool? isRead,
    String? time,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      time: time ?? this.time,
    );
  }
  
}