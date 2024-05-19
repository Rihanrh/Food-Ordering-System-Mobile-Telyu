class PesananTenantModel {
  final int idTenant;
  final int idMenu;
  final int idPesanan;
  final int quantity;
  final int totalHarga;
  final String metodePembayaran;
  final String statusPesanan;
  final int nomorMeja;
  final int? idPembeli; // nullable type for idPembeli

  PesananTenantModel({
    required this.idTenant,
    required this.idMenu,
    required this.idPesanan,
    required this.quantity,
    required this.totalHarga,
    required this.metodePembayaran,
    required this.statusPesanan,
    required this.nomorMeja,
    this.idPembeli,
  });

  factory PesananTenantModel.fromJson(Map<String, dynamic> json) {
    return PesananTenantModel(
      idTenant: json['idTenant'],
      idMenu: json['idMenu'],
      idPesanan: json['idPesanan'],
      quantity: json['quantity'],
      totalHarga: json['totalHarga'],
      metodePembayaran: json['metodePembayaran'],
      statusPesanan: json['statusPesanan'],
      nomorMeja: json['nomorMeja'],
      idPembeli: json['idPembeli'],
    );
  }

  Map<String, dynamic> toJson() => {
    'idTenant': idTenant,
    'idMenu': idMenu,
    'idPesanan': idPesanan,
    'quantity': quantity,
    'totalHarga': totalHarga,
    'metodePembayaran': metodePembayaran,
    'statusPesanan': statusPesanan,
    'nomorMeja': nomorMeja,
    'idPembeli': idPembeli, // include idPembeli if it's not null
  };
}
