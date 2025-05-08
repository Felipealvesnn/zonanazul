import 'package:zona_azul/app/data/models/log_transferencia_cad.dart';
import 'package:zona_azul/app/data/models/usuario_model.dart';

class Conta {
  String? contaID;
  int? saldo;
  String? cpfcnpj;
  String? dataUltimaRecarga;
  String? dataCriacao;
  String? tipoUsuarioID;
  Usuario? usuario;
  String? tipoUsuario;
  List<LogTransferenciaCad>? logTranferenciaCad;

  Conta(
      {this.contaID,
      this.saldo,
      this.cpfcnpj,
      this.dataUltimaRecarga,
      this.dataCriacao,
      this.tipoUsuarioID,
      this.usuario,
      this.tipoUsuario,
      this.logTranferenciaCad});

  Conta.fromJson(Map<String, dynamic> json) {
    contaID =  json['contaID'].toString();
    saldo = json['saldo'];
    cpfcnpj = json['cpfcnpj'];
    dataUltimaRecarga = json['dataUltimaRecarga'];
    dataCriacao = json['dataCriacao'];
    tipoUsuarioID = json['tipoUsuarioID'];
    usuario = json['Usuario'];
    tipoUsuario = json['TipoUsuario'];
    if (json['logTranferenciaCad'] != null) {
      logTranferenciaCad = <LogTransferenciaCad>[];
      json['logTranferenciaCad'].forEach((v) {
        logTranferenciaCad!.add(LogTransferenciaCad.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contaID'] = contaID;
    data['saldo'] = saldo;
    data['cpfcnpj'] = cpfcnpj;
    data['dataUltimaRecarga'] = dataUltimaRecarga;
    data['dataCriacao'] = dataCriacao;
    data['tipoUsuarioID'] = tipoUsuarioID;
    data['Usuario'] = usuario;
    data['TipoUsuario'] = tipoUsuario;
    if (logTranferenciaCad != null) {
      data['logTranferenciaCad'] =
          logTranferenciaCad!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}







/* class Conta {
  String? contaID;
  int? saldo;
  String? cpfcnpj;
  String? dataUltimaRecarga;
  String? dataCriacao;
  String? tipoUsuarioID;
  Usuario? usuario;
  String? tipoUsuario;
  List<LogTransferenciaCad>? logTranferenciaCad;

  Conta(
      {this.contaID,
      this.saldo,
      this.cpfcnpj,
      this.dataUltimaRecarga,
      this.dataCriacao,
      this.tipoUsuarioID,
      this.usuario,
      this.tipoUsuario,
      this.logTranferenciaCad});

  Conta.fromJson(Map<String, dynamic> json) {
    contaID = json['contaID'];
    saldo = json['saldo'];
    cpfcnpj = json['cpfcnpj'];
    dataUltimaRecarga = json['dataUltimaRecarga'];
    dataCriacao = json['dataCriacao'];
    tipoUsuarioID = json['tipoUsuarioID'];
    usuario = json['Usuario'];
    tipoUsuario = json['TipoUsuario'];
    if (json['logTranferenciaCad'] != null) {
      logTranferenciaCad = <LogTransferenciaCad>[];
      json['logTranferenciaCad'].forEach((v) {
        logTranferenciaCad!.add(new LogTransferenciaCad.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contaID'] = this.contaID;
    data['saldo'] = this.saldo;
    data['cpfcnpj'] = this.cpfcnpj;
    data['dataUltimaRecarga'] = this.dataUltimaRecarga;
    data['dataCriacao'] = this.dataCriacao;
    data['tipoUsuarioID'] = this.tipoUsuarioID;
    data['Usuario'] = this.usuario;
    data['TipoUsuario'] = this.tipoUsuario;
    if (this.logTranferenciaCad != null) {
      data['logTranferenciaCad'] =
          this.logTranferenciaCad!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


 */


// OLD/////////////////////////////////////////////////////////////////

/* class Conta {
  String? contaID;
  int? saldo;
  String? cpfcnpj;
  String? dataUltimaRecarga;
  String? dataCriacao;
  dynamic usuario;

  Conta(
      {this.contaID,
      this.saldo,
      this.cpfcnpj,
      this.dataUltimaRecarga,
      this.dataCriacao,
      this.usuario});

  Conta.fromJson(Map<String, dynamic> json) {
    contaID = json['contaID'];
    saldo = json['saldo'];
    cpfcnpj = json['cpfcnpj'];
    dataUltimaRecarga = json['dataUltimaRecarga'];
    dataCriacao = json['dataCriacao'];
    usuario = json['Usuario'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['contaID'] = contaID;
    data['saldo'] = saldo;
    data['cpfcnpj'] = cpfcnpj;
    data['dataUltimaRecarga'] = dataUltimaRecarga;
    data['dataCriacao'] = dataCriacao;
    data['Usuario'] = usuario;
    return data;
  }
}
 */