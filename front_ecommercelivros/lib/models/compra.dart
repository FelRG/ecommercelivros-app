class Compra {
  final int? id;
  final int usuarioId;
  final String dataCompra;
  final double total;

  Compra({
    this.id,
    required this.usuarioId,
    required this.dataCompra,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'data_compra': dataCompra,
      'total': total,
    };
  }

  factory Compra.fromMap(Map<String, dynamic> map) {
    return Compra(
      id: map['id'],
      usuarioId: map['usuario_id'],
      dataCompra: map['data_compra'],
      total: map['total'],
    );
  }
}
