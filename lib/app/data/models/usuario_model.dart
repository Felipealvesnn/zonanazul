import 'package:zona_azul/app/data/models/cartao_credito_debito_model.dart';
import 'package:zona_azul/app/data/models/conta_model.dart';
import 'package:zona_azul/app/data/models/historico_estacionamento_model.dart';
import 'package:zona_azul/app/data/models/veiculo_model.dart';

class Usuario {
  String? nome;
  String? cpfcnpj;
  String? email;
  String? senha;
  String? celular;
  String? token;
  String? dataCadastro;
  List<CartaoCreditoDebito>? cartaoCreditoDebito;
  List<Conta>? conta;
  List<HistoricoEstacionamento>? historicoEstacionamento;
  //List<Null>? logPagamento;
  List<Veiculo>? veiculo;

  Usuario(
      {this.nome,
      this.cpfcnpj,
      this.email,
      this.senha,
      this.celular,
      this.token,
      this.dataCadastro,
      this.cartaoCreditoDebito,
      this.conta,
      this.historicoEstacionamento,
      //this.logPagamento,
      this.veiculo});

  Usuario.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    cpfcnpj = json['cpfcnpj'];
    email = json['email'];
    senha = json['senha'];
    celular = json['celular'];
    token = json['token'];
    dataCadastro = json['dataCadastro'];
    if (json['CartaoCreditoDebito'] != null) {
      cartaoCreditoDebito = <CartaoCreditoDebito>[];
      json['CartaoCreditoDebito'].forEach((v) {
        cartaoCreditoDebito?.add(CartaoCreditoDebito.fromJson(v));
      });
    }
    if (json['Conta'] != null) {
      conta = <Conta>[];
      json['Conta'].forEach((v) {
        conta!.add(Conta.fromJson(v));
      });
    }
    if (json['HistoricoEstacionamento'] != null) {
      historicoEstacionamento = <HistoricoEstacionamento>[];
      json['HistoricoEstacionamento'].forEach((v) {
        historicoEstacionamento?.add(HistoricoEstacionamento.fromJson(v));
      });
    }
    //-----------------------------ATENÇÃO POSTERIOMENTE AQUI----------------------
    /*
    if (json['LogPagamento'] != null) {
      logPagamento = <Null>[];
      json['LogPagamento'].forEach((v) {
        logPagamento.add(Null.fromJson(v));
      });
    } */
    //------------------------------------------------------------------------------
    if (json['Veiculo'] != null) {
      veiculo = <Veiculo>[];
      json['Veiculo'].forEach((v) {
        veiculo?.add(Veiculo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nome'] = nome;
    data['cpfcnpj'] = cpfcnpj;
    data['email'] = email;
    data['senha'] = senha;
    data['celular'] = celular;
    data['token'] = token;
    data['dataCadastro'] = dataCadastro;
    if (cartaoCreditoDebito != null) {
      data['CartaoCreditoDebito'] =
          cartaoCreditoDebito?.map((v) => v.toJson()).toList();
    }
    if (conta != null) {
      data['Conta'] = conta?.map((v) => v.toJson()).toList();
    }
    if (historicoEstacionamento != null) {
      data['HistoricoEstacionamento'] =
          historicoEstacionamento?.map((v) => v.toJson()).toList();
    }
    //-----------------------------ATENÇÃO POSTERIOR----------------------
/*

    if (logPagamento != null) {
      data['LogPagamento'] = logPagamento?.map((v) => v.toJson()).toList();
    }

*/
    //////////////////////////////////////////////////////////////////
    if (veiculo != null) {
      data['Veiculo'] = veiculo?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
