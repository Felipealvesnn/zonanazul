import 'package:zona_azul/app/data/models/conta_model.dart';
import 'package:zona_azul/app/data/models/usuario_model.dart';
import 'package:zona_azul/app/data/provider/login_provider.dart';

class LoginRepository {
  final LoginProvider apiClient = LoginProvider();

  Future<Usuario> login(String username, String password) async {
    Map<String, dynamic>? json = await apiClient.login(username, password);
    Usuario userNullo = Usuario();
    return Usuario.fromJson(json);
    }

  Future<void> enviarEmail(String email, String codigo) async {
    try {
      await apiClient.enviarEmail(email, codigo);
    } on Exception catch (e) {
      // TODO
    }
  }
   Future<void> emailResetar(String email, String codigo) async {
    try {
      await apiClient.emailResetar(email, codigo);
    } on Exception catch (e) {
      // TODO
    }
  }


  Future<Usuario> cadastrar(String nome, String cpfcnpj, String email,
      String senha, String celular) async {
    Map<String, dynamic>? json =
        await apiClient.Cadastrar(nome, cpfcnpj, email, senha, celular);
    return Usuario.fromJson(json!);
  }

  Future<Usuario?> getUsuario(String token, String cpf) async {
    Map<String, dynamic>? json = await apiClient.getUsuario(token, cpf);
    //Usuario userNullo = Usuario();
    if (json == null) {
      return null;
    } else {
      return Usuario.fromJson(json);
    }
  }

  atualizarUser(String nome, String cpfcnpj, String celular, String email,
      String senha, String token) async {
    Map<String, dynamic>? json = await apiClient.updateUsuario(
        nome, cpfcnpj, celular, email, senha, token);
    return json;
  }

  testaConexao() {
    apiClient.testaConexao();
    return true;
  }
}
