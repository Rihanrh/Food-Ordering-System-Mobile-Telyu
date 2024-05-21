class CartItemModel {
  int? id;
  final int idTenant;
  final int idMenu;
  int _quantity;
  final int harga;

  CartItemModel({
    this.id,
    required this.idTenant,
    required this.idMenu,
    required int quantity, // Assign the quantity parameter to the _quantity field
    required this.harga,
  }) : _quantity = quantity; // Initialize _quantity in the initializer list

  int get quantity => _quantity;

  set quantity(int value) {
    _quantity = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idTenant': idTenant,
      'idMenu': idMenu,
      'quantity': quantity,
      'harga': harga,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      idTenant: json['idTenant'],
      idMenu: json['idMenu'],
      quantity: json['quantity'], // Assign the quantity from JSON to the _quantity field
      harga: json['harga'],
    );
  }
}