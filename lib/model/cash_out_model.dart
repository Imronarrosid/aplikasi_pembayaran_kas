class CashOut {
  final int? id;
  final String description;
  final int amount;
  String? createdAt;

  CashOut(
      {this.id,
      required this.description,
      required this.amount,
      this.createdAt});

  factory CashOut.fromMap(Map<String, dynamic> json) => CashOut(
        id: json['id'],
        description: json['description'],
        amount: json['amount'],
        createdAt: json['created_at']

      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'created_at':createdAt
    };
  }
}
