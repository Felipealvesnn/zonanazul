class ListaVeiculosFipe {
  final int? codigo;
  final String? nome;

  ListaVeiculosFipe({
    this.codigo,
    this.nome,
  });



  factory ListaVeiculosFipe.fromJson(Map<String, dynamic> json) {
    return ListaVeiculosFipe(
      codigo: json['codigo'],
      nome: json['nome'],
    );
  }

   static List<String> devolveListaNomes(List<ListaVeiculosFipe> lista) {
    List<String> nomes = [];
    for (var veiculo in lista) {
      if (veiculo.nome != null) {
        nomes.add(veiculo.nome!);
      }
    }
    return nomes;
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'nome': nome,
    };
  }
}
