class PersonPayment {
  final int? id;
  final String name;
  final int amount;
  String? createdAt;

  PersonPayment(
      {this.id,
      required this.name,
      required this.amount,
      this.createdAt});

  factory PersonPayment.fromMap(Map<String, dynamic> json) => PersonPayment(
        id: json['id'],
        name: json['name'],
        amount: json['amount'],
        createdAt: json['created_at']

      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'created_at':createdAt
    };
  }
}
