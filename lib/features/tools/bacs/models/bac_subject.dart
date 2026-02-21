class BacSubject {
  final int id;
  final String name;
  final String description;
  final int materialId;
  final String pdf;

  BacSubject({
    required this.id,
    required this.name,
    required this.description,
    required this.materialId,
    required this.pdf,
  });

  factory BacSubject.fromJson(Map<String, dynamic> json) {
    return BacSubject(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      materialId: json['materialId'] as int,
      pdf: json['pdf'] as String,
    );
  }
}
