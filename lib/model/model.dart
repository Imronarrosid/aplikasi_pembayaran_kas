class Person {
  final int? id;
  final String name;
  final String paid;
  final String notPaid;
  String? createdAt;

  Person(
      {this.id,
      required this.name,
      required this.paid,
      required this.notPaid,
      this.createdAt});

  factory Person.fromMap(Map<String, dynamic> json) => Person(
        id: json['id'],
        name: json['name'],
        paid: json['paid'],
        notPaid: json['not_paid'],
        createdAt: json['created_at']

      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'paid': paid,
      'not_paid': notPaid,
      'created_at':createdAt
    };
  }
}
