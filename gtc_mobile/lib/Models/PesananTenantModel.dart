class PesananTenantModel {
  final int? id; 
  final int idTenant;
  final int idMenu;
  final int? idPesanan; 
  final int quantity;
  final int totalHarga;
  final String metodePembayaran;
  final String statusPesanan;
  final int nomorMeja;
  final String opsiKonsumsi;
  final int? queue;
  final int? idPembeli;

  PesananTenantModel({
    this.id, 
    required this.idTenant,
    required this.idMenu,
    this.idPesanan, 
    required this.quantity,
    required this.totalHarga,
    required this.metodePembayaran,
    required this.statusPesanan,
    required this.nomorMeja,
    required this.opsiKonsumsi,
    this.queue,
    this.idPembeli,
  });

  // Factory method to create a PesananTenant from a JSON map
  factory PesananTenantModel.fromJson(Map<String, dynamic> json) {
    return PesananTenantModel(
      id: json['id'],
      idTenant: json['idTenant'],
      idMenu: json['idMenu'],
      idPesanan: json['idPesanan'],
      quantity: json['quantity'],
      totalHarga: json['totalHarga'],
      metodePembayaran: json['metodePembayaran'],
      statusPesanan: json['statusPesanan'],
      nomorMeja: json['nomorMeja'],
      opsiKonsumsi: json['opsiKonsumsi'],
      queue: json['queue'],
      idPembeli: json['idPembeli'],
    );
  }

  // Method to convert a PesananTenant instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idTenant': idTenant,
      'idMenu': idMenu,
      'idPesanan': idPesanan,
      'quantity': quantity,
      'totalHarga': totalHarga,
      'metodePembayaran': metodePembayaran,
      'statusPesanan': statusPesanan,
      'nomorMeja': nomorMeja,
      'opsiKonsumsi': opsiKonsumsi,
      'queue': queue,
      'idPembeli': idPembeli,
    };
  }
}
