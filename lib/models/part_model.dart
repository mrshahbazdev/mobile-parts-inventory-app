class PartModel {
  final int? id;
  final int categoryId;
  final String name;
  final String? description;
  final double price;
  final int quantity;

  PartModel({
    this.id,
    required this.categoryId,
    required this.name,
    this.description,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
    };
  }

  factory PartModel.fromMap(Map<String, dynamic> map) {
    return PartModel(
      id: map['id'],
      categoryId: map['category_id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }
}
