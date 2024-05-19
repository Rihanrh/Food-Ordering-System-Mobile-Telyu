class TenantMenuModel {
  final int id;
  final String fotoProduk;
  final String namaProduk;
  final String hargaProduk;

  TenantMenuModel({
    required this.id,
    required this.fotoProduk,
    required this.namaProduk,
    required this.hargaProduk,
  });

  factory TenantMenuModel.fromJson(Map<String, dynamic> json) {
    return TenantMenuModel(
      id: json['id'],
      fotoProduk: json['fotoProduk'],
      namaProduk: json['namaProduk'],
      hargaProduk: json['hargaProduk'],
    );
  }

  factory TenantMenuModel.fromMap(Map<String, dynamic> map) {
    return TenantMenuModel(
      id: map['id'],
      fotoProduk: map['fotoProduk'],
      namaProduk: map['namaProduk'],
      hargaProduk: map['hargaProduk'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fotoProduk': fotoProduk,
      'namaProduk': namaProduk,
      'hargaProduk': hargaProduk,
    };
  }
}