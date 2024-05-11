class TenantMenuModel{
  final int id;
  final String fotoProduk;
  final String namaProduk;
  final String hargaProduk;

  TenantMenuModel({required this.id, required this.fotoProduk, required this.namaProduk, required this.hargaProduk});

  factory TenantMenuModel.fromJson(Map<String, dynamic> json){
    return TenantMenuModel(
      id: json['id'],
      fotoProduk: json['fotoProduk'],
      namaProduk: json['namaProduk'],
      hargaProduk: json['hargaProduk']
    );
  }
}