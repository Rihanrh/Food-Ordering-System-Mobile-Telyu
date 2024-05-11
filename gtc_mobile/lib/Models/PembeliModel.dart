class PembeliModel{
  final int id;
  final String device_id;

  PembeliModel({required this.id, required this.device_id});

  factory PembeliModel.fromJson(Map<String, dynamic> json){
    return PembeliModel(
      id: json['id'],
      device_id: json['device_id']
    );
  }
}