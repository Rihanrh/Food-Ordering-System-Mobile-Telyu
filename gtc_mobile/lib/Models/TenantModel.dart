class TenantModel{
  final int id;
  final String nama_tenant;

  TenantModel({required this.id, required this.nama_tenant});

  factory TenantModel.fromJson(Map<String, dynamic> json){
    return TenantModel(
      id: json['id'],
      nama_tenant: json['nama_tenant']
    );
  }

  factory TenantModel.fromMap(Map<String, dynamic> map) {
    return TenantModel(
      id: map['id'],
      nama_tenant: map['nama_tenant'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_tenant': nama_tenant,
    };
  }
}