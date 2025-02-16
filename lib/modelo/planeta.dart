class Planeta {
  int? id;
  String nome;
  double distanciaSol;
  double tamanho;
  String? apelido;

  Planeta({
    this.id,
    required this.nome,
    required this.distanciaSol,
    required this.tamanho,
    this.apelido,
  });

  // Converte um objeto Planeta para um Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'distanciaSol': distanciaSol,
      'tamanho': tamanho,
      'apelido': apelido,
    };
  }

  // Cria um objeto Planeta a partir de um Map (para ler do banco)
  factory Planeta.fromMap(Map<String, dynamic> map) {
    return Planeta(
      id: map['id'],
      nome: map['nome'],
      distanciaSol: map['distanciaSol'],
      tamanho: map['tamanho'],
      apelido: map['apelido'],
    );
  }
}
