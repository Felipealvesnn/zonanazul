// import 'package:android_intent_plus/android_intent.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/utils/funcoesutilsd.dart';

Future<void> IniciarGetStorages() async {
  //usuario
  await GetStorage.init('cpfCnpj');
  await GetStorage.init('token');
  await GetStorage.init('boxUserLogado');
  await GetStorage.init('boxcamposValidadosEstacionar');

  /*  await GetStorage.init('boxUserLogadoSenha');
  await GetStorage.init('boxUserLogadoEmail'); */
  await GetStorage.init('nomeUsuario');
  await GetStorage.init('emailUsuario');
  await GetStorage.init('senhaUsuario');
  await GetStorage.init('saldo');
  await GetStorage.init('boxListVeic');
  await GetStorage.init('boxListCartoes');
  await GetStorage.init('boxListHistorico');
  await GetStorage.init('boxalertaSelecionado');
  await GetStorage.init('boxvalorAlertaSelecionado');
  await GetStorage.init('boxExibirTelaIntroducao');

  //regras do app
  await GetStorage.init('timer');
  await GetStorage.init("boxDataInicio");
  await GetStorage.init("boxDataFim");
  await GetStorage.init('tipoVeic');
  await GetStorage.init('biometria');
  await GetStorage.init('boxBotaoCarro');
  await GetStorage.init('boxBotaoRegra');
  await GetStorage.init('CamposValidadosEstacionar');
  await GetStorage.init('listRegras');
  await GetStorage.init('boxCartaoSelecionado');
  await GetStorage.init('boxEstacionamentoAtual');
  await GetStorage.init('boxEstacionadoComSucesso');
  await GetStorage.init('boxEstacionado');
  await GetStorage.init("boxIsEstacionado");
  await GetStorage.init("boxbotaoEstacionarHabilitado");
  await GetStorage.init("boxCustomRadioCartoesValue");
  await GetStorage.init("boxAdicionar1HoraButton");
  await GetStorage.init("boxBotaoVeiculoButton");
  await GetStorage.init("boxTema");
  await GetStorage.init("boxDateTimeAlarm");
  await GetStorage.init("boxSetor");

  await pedirPermissao();
  // const intent = AndroidIntent(
  //   action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
  // );
  // await intent.launch();
}

zerarCampos() {
  Storagerds.boxBotaoCarro.write('placaBotao', "Selecione");
  Storagerds.boxBotaoCarro.write('marcaBotao', "");
  Storagerds.boxBotao.write('placaBotao', "Selecione");
  Storagerds.boxBotao.write('marcaBotao', "");
  Storagerds.boxBotaoRegra.write('descricaoBotao', "Selecione");
  Storagerds.boxcamposValidadosEstacionar.write('placa', "Selecione");
  Storagerds.boxcamposValidadosEstacionar.write('onTapLat', 0.0);
  Storagerds.boxcamposValidadosEstacionar.write('onTapLang', 0);
  Storagerds.boxcamposValidadosEstacionar.write('searchLat', 0);
  Storagerds.boxcamposValidadosEstacionar.write('searchLang', 0);
  Storagerds.boxcamposValidadosEstacionar.write('hasEnderecoTap', false);
  Storagerds.boxcamposValidadosEstacionar.write('hasEnderecoSearch', false);
  Storagerds.boxcamposValidadosEstacionar.write('hasEnderecoSearch', false);
  Storagerds.boxcamposValidadosEstacionar.write('enderecoExtenso', null);
  Storagerds.boxcamposValidadosEstacionar.write('qtdCADsolicitado', "1");
  Storagerds.boxTimer.write('timer', 0);

  Storagerds.boxListPagamentoButton
      .write('boxListPagamentoButton', "Selecione");
  Storagerds.boxCartaoSelecionado.write('boxCartaoSelecionado', false);
  Storagerds.boxEstacionamentoAtual.write('estacionamentoAtual', 0);
  Storagerds.boxEstacionadoComSucesso.write('boxEstacionadoComSucesso', false);
  //boxvalorAlertaSelecionado.write('boxvalorAlertaSelecionado', 10);

  Storagerds.boxEstacionado.write('placa', "");
  Storagerds.boxEstacionado.write('valor', "");
  Storagerds.boxEstacionado.write('regra', "");
  Storagerds.boxEstacionado.write('regraDescricao', "");
  Storagerds.boxEstacionado.write('tempoDeEstacionamento', "");
  Storagerds.boxEstacionado.write('dataInicio', "");
  Storagerds.boxEstacionado.write('dataFim', "");
  Storagerds.boxEstacionado.write('localCard', "");
  Storagerds.boxEstacionado.write('chaveAutenticacao', "chave");
  Storagerds.boxIsEstacionado.write('boxIsEstacionado', false);

  Storagerds.boxbotaoEstacionarHabilitado
      .write('boxbotaoEstacionarHabilitado', true);
  // boxCustomRadioCartoesValue.write('boxCustomRadioCartoesValue', 1);
}

class Storagerds {
  static final boxSetor = GetStorage("boxSetor");
  static final boxTema = GetStorage("boxTema");
  static final boxnomeUsuario = GetStorage('nomeUsuario');
  static final boxEmailUsuario = GetStorage('emailUsuario');
  static final boxSenhalUsuario = GetStorage('senhaUsuario');

  static final boxExibirTelaIntroducao = GetStorage("boxExibirTelaIntroducao");
  static final boxcpf = GetStorage('cpfCnpj');
  static final boxBiometria = GetStorage('biometria');

  static final boxToken = GetStorage('token');
  //instanciação usuario
  static final boxSaldo = GetStorage('saldo');
  static final boxtipoVeic = GetStorage('tipoVeic');
  static final listaVeic = GetStorage('listaVeic');
  static final boxListCad = GetStorage('boxListCad');
  static final boxUserLogado = GetStorage('boxUserLogado');
  static final boxBotaoCarro = GetStorage('boxBotaoCarro');
  static final boxListRegras = GetStorage('listRegras');

  static final boxListCartoes = GetStorage('boxListCartoes');
  static final boxListCartoesDebito = GetStorage('boxListCartoesDebito');
  static final boxListCartoesCredito = GetStorage('boxListCartoesCredito');

  static final boxListVeic = GetStorage('boxListVeic');
  static final boxListHistorico = GetStorage('boxListHistorico');
  static final boxalertaSelecionado = GetStorage('boxalertaSelecionado');
  static final boxvalorAlertaSelecionado =
      GetStorage('boxvalorAlertaSelecionado');

  //instanciaçao regras do app
  static final boxBotao = GetStorage('boxBotaoCarro');
  static final boxBotaoRegra = GetStorage('boxBotaoRegra');
  static final boxcamposValidadosEstacionar =
      GetStorage('CamposValidadosEstacionar');
  static final boxTimer = GetStorage('timer');
  static final boxDataInicio = GetStorage('boxDataInicio');
  static final boxDataFim = GetStorage('boxDataFim');
  static final boxCustomRadioCartoesValue =
      GetStorage('boxCustomRadioCartoesValue');

  /*  CameraPosition posicaoCamera= CameraPosition(target: LatLng(-23.563999, -46.653256));  */

  static final boxListPagamentoButton = GetStorage('boxListPagamentoButton');
  static final boxCartaoSelecionado = GetStorage('boxCartaoSelecionado');
  static final boxEstacionamentoAtual = GetStorage('boxEstacionamentoAtual');
  static final boxEstacionadoComSucesso =
      GetStorage('boxEstacionadoComSucesso');
  static final boxEstacionado = GetStorage('boxEstacionado');
  static final boxIsEstacionado = GetStorage('boxIsEstacionado');
  static final boxbotaoEstacionarHabilitado =
      GetStorage('boxbotaoEstacionarHabilitado');
  static final boxAdicionar1HoraButton = GetStorage('boxAdicionar1HoraButton');
  static final boxBotaoVeiculoButton = GetStorage("boxBotaoVeiculoButton");

  static final boxDateTimeAlarm = GetStorage("boxDateTimeAlarm");
}
