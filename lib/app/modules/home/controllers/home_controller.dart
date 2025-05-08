import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/data/global/constants.dart';

import 'package:zona_azul/app/data/models/cad.dart';
import 'package:zona_azul/app/data/models/historico_estacionamento_model.dart';
import 'package:zona_azul/app/data/models/regra_estacionamento.dart';
import 'package:zona_azul/app/data/models/usuario_model.dart';
import 'package:zona_azul/app/data/provider/cad_provider.dart';
import 'package:zona_azul/app/data/repository/cad_repository.dart';
import 'package:zona_azul/app/data/repository/conta_repository.dart';
import 'package:zona_azul/app/data/repository/historicoEstacionamento_repository.dart';
import 'package:zona_azul/app/data/repository/login_repository.dart';
import 'package:zona_azul/app/modules/cadastroUsuarioEditar/controllers/cadastro_usuario_editar_controller.dart';
import 'package:zona_azul/app/modules/cadastroUsuarioEditar/views/cadastro_usuario_editar_view.dart';
import 'package:zona_azul/app/modules/configuracoes/controllers/configuracoes_controller.dart';
import 'package:zona_azul/app/modules/estacionar/controllers/estacionar_controller.dart';
import 'package:zona_azul/app/modules/historico/controllers/historico_controller.dart';
import 'package:zona_azul/app/modules/historico/models/historicoInfo.dart';
import 'package:zona_azul/app/modules/home/views/widgets/componentsBody/contador.dart';

//import 'package:zona_azul/app/modules/login_page/controllers/login_page_controller.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/theme/tema.dart';
import 'package:zona_azul/app/utils/funcoesutilsd.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class HomeController extends GetxController {
  // Repositórios - agrupados para melhor organização
  final ContaRepository contaRepository = ContaRepository();
  final HistoricoEstacionamentoRepository histoEstaRepository = HistoricoEstacionamentoRepository();
  final repository = Get.put(LoginRepository());
  final cadsRepository = CadRepository();
  
  // Controllers
  final CadastroUsuarioEditarController cadastroUsuarioEditarController = CadastroUsuarioEditarController();
  final ConfiguracoesController configuracoesController = ConfiguracoesController();
  late HistoricoController historicoController;
  
  // Navegação
  late PageController _pageController;
  RxInt currentIndex = 0.obs;
  PageController get pageController => _pageController;
  int get currentIndexGet => currentIndex.value;
  
  // Estado da tela
  RxBool isLoadingHome = false.obs;
  RxBool detailUserPressed = false.obs;
  RxString posicaoView = "".obs;
  RxBool corButtonAddVeic = true.obs;
  RxInt botaoVAlor = 0.obs;
  
  // Dados do usuário e veículos
  Usuario user = Usuario();
  RxList<Cad> listcad = <Cad>[].obs;
  RxList<HistoricoEstacionamento> historico = <HistoricoEstacionamento>[].obs;
  RxString saldoCad = "--".obs;
  
  // Dados de veículo selecionado
  RxString placaButton = "".obs;
  RxString marcaButton = "".obs;
  List? listagemManualVeic;
  
  // Configurações e tema
  RxBool temaEscuro = false.obs;
  RxBool exibirTelaIntroducao = true.obs;
  RxString cidade = "Crato".obs;
  var isSwitched = false;
  final switchDataController = GetStorage();
  
  // Sistema de alertas
  RxBool alertaSelecionado = false.obs;
  RxInt valorAlertaSelecionado = 600.obs; // 10 minutos
  
  // Estacionamento atual
  RxBool estacionadoAtual = false.obs;
  late RxBool isEstacionado;
  RxString placaEstacionamentoAtual = "".obs;
  RxString valorEstacionamentoAtual = "".obs;
  RxString regraEstacionamentoAtual = "".obs;
  RxString tempoDeEstacionamentoEstacionamentoAtual = "".obs;
  RxString dataInicioEstacionamentoAtual = "".obs;
  RxString dataFimEstacionamentoAtual = "".obs;
  RxString localEstacionamentoAtual = "".obs;
  var dataInicio = DateTime.now();
  var dataFim = DateTime.now();
  RxInt startContador = 0.obs;
  RxString colorTimer = "blue".obs;
  final historicoInfo = HistoricoInfo();
  GlobalKey<CircularCountDownTimerState> countDownKey = GlobalKey();
  
  // Storage
  final boxalertaSelecionado = GetStorage('boxalertaSelecionado');
  final boxCamposValidadosEstacionar = GetStorage('CamposValidadosEstacionar');
  final boxbotaoEstacionarHabilitado = GetStorage("boxbotaoEstacionarHabilitado");
  
  // Métodos do ciclo de vida
  @override
  void onInit() async {
    super.onInit();
    
    // Inicializações
    isEstacionado = false.obs;
    _initNavigation(
      pageController: PageController(initialPage: 0, keepPage: true),
      initialPage: 0,
    );
    
    // Carregamento inicial de dados
    _loadInitialData();
  }
  
  @override
  void onReady() async {
    super.onReady();
    await carregarCad();
  }
  
  @override
  void onClose() {
    zerarCampos();
    super.onClose();
  }
  
  // Inicialização de dados
  Future<void> _loadInitialData() async {
    // Carregar saldo
    if (Storagerds.boxSaldo.read("saldo") != null) {
      saldoCad.value = Storagerds.boxSaldo.read("saldo").toString();
    }
    
    // Carregar configurações de alerta
    valorAlertaSelecionado.value = Storagerds.boxvalorAlertaSelecionado
        .read('boxvalorAlertaSelecionado') ?? 600;
    Storagerds.boxvalorAlertaSelecionado
        .write('boxvalorAlertaSelecionado', valorAlertaSelecionado.value);
    
    // Carregar configuração de tela de introdução
    exibirTelaIntroducao.value =
        Storagerds.boxExibirTelaIntroducao.read('boxExibirTelaIntroducao') ?? true;
    Storagerds.boxExibirTelaIntroducao
        .write('boxExibirTelaIntroducao', exibirTelaIntroducao.value);
        
    // Iniciar carregamento da home
    await loadingHomeINici();
  }

  // Navegação
  void _initNavigation({
    required PageController pageController,
    required int initialPage
  }) {
    _pageController = pageController;
    currentIndex = initialPage.obs;
  }

  Future<void> navigationPageview(int page) async {
    if (page == currentIndex.value) return;
    currentIndex.value = page;
    _pageController.jumpToPage(page);
  }
  
  // Carregamento da tela inicial
  Future<void> loadingHomeINici() async {
    try {
      isLoadingHome.value = false;
        await Future.wait<bool>([
        _loadUltimoHistoricoEstacionamentoWrapper(),
        _loadSaldoWrapper()
      ]);
    } catch (e) {
      print('Erro durante a carga da página inicial: $e');
      FuncoesParaAjudar.logger.e('Erro durante a carga da página inicial: $e');
    } finally {
      isLoadingHome.value = true;
    }
  }
   Future<bool> _loadUltimoHistoricoEstacionamentoWrapper() async {
    await loadUltimoHistoricoEstacionamento();
    return true;
  }
   Future<bool> _loadSaldoWrapper() async {
     loadSaldo();
    return true;
  }
  
  // Gestão de estacionamento
  Future<void> functionAtualizarHistoricoEstacionamento() async {
    try {
      final cpf = Storagerds.boxcpf.read('cpfCnpj');
      final token = Storagerds.boxToken.read('token');
      
      if (cpf == null || token == null) {
        printError(info: 'CPF ou token não encontrados');
        return;
      }

      final updatedHistorico = await histoEstaRepository
          .listarUltimoHistoricoEstacionamento(cpf, token);

      if (updatedHistorico.isNotEmpty) {
        Storagerds.boxListHistorico.write('boxListHistorico', updatedHistorico);
        historico.assignAll(updatedHistorico);
      } else {
        printError(info: 'O histórico atualizado está vazio');
        FuncoesParaAjudar.logger.w('O histórico atualizado está vazio');
      }
    } catch (e) {
      printError(info: 'Erro ao atualizar histórico: $e');
      FuncoesParaAjudar.logger.w('Erro ao atualizar histórico: $e');
    }
  }

  Future<void> loadUltimoHistoricoEstacionamento() async {
    await functionAtualizarHistoricoEstacionamento();
    
    final historicoValido = historico.firstWhereOrNull(
      (element) => element.status == "VÁLIDO" && element.tempoEstacionamento! >= 0,
    );

    if (historicoValido == null || historicoValido.tempoEstacionamento! < 0) {
      isEstacionado.value = false;
      return;
    }

    final tempocount = historicoValido.tempoEstacionamento!;
    await FuncoesParaAjudar.renovarNotificacao(tempocount);
    await carregarVariaveis(historicoValido);

    // Programar exibição do diálogo quando o tempo acabar
    Future.delayed(Duration(seconds: tempocount), () {
      if (isEstacionado.value) { // Verifica se ainda está estacionado
        isEstacionado.value = false;
        exibirDialogo();
      }
    });
  }

  Future<void> carregarVariaveis(HistoricoEstacionamento historicoAtual) async {
    isEstacionado.value = true;

    final String endereco = historicoAtual.local == "null - "
        ? await devolverEndereco(
            historicoAtual.latitude!, historicoAtual.longitude!)
        : historicoAtual.local!;

    historicoInfo.localEstacionado?.value = endereco;
    historicoInfo.placa!.value = historicoAtual.placa ?? '';
    historicoInfo.valor!.value = historicoAtual.valor?.toString() ?? '';
    historicoInfo.regra!.value = historicoAtual.regraEstacionamento ?? '';
    historicoInfo.localchaveAutenticacao!.value =
        historicoAtual.chaveAutenticacao ?? '';
    
    countDownKey = GlobalKey();
    dataInicio = historicoAtual.dataHoraInicio!;
    historicoInfo.definirDataInicio(dataInicio);
    
    dataFim = historicoAtual.dataHoraFim!;
    historicoInfo.definirdataFim(dataFim);
    
    // Inicializa contador
    _iniciarContadorEstacionamento(historicoAtual);
  }
  
  void _iniciarContadorEstacionamento(HistoricoEstacionamento historicoAtual) {
    // Calcula o tempo inicial do contador
    startContador.value = (dataFim.difference(dataInicio).inSeconds -
        (historicoAtual.tempoEstacionamento ?? 0));
    
    // Programa uma atualização periódica
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isEstacionado.value) {
        timer.cancel();
        return;
      }
      
      startContador.value = (dataFim.difference(dataInicio).inSeconds -
          (dataFim.difference(DateTime.now()).inSeconds));
          
      if (startContador.value <= 0) {
        timer.cancel();
      }
    });
  }
  
  // Gestão de CADs
  Future<void> carregarCad() async {
    // Limpa os dados existentes
    Storagerds.boxListCad.erase();

    // Obtém CPF e token
    final String? cpf = Storagerds.boxcpf.read('cpfCnpj');
    final String? token = Storagerds.boxToken.read('token');

    if (cpf == null || token == null) {
      print('CPF ou token não disponíveis.');
      return;
    }

    try {
      // Busca os CADs usando o repositório
      final List<Cad> cads = await cadsRepository.listarCads(token);

      // Grava os dados recuperados no box
      Storagerds.boxListCad.write('boxListCad', cads);

      // Atualiza a lista observável listcad
      listcad.value = cads;
    } catch (e) {
      print('Erro ao carregar CADs: $e');
      FuncoesParaAjudar.logger.e('Erro ao carregar CADs: $e');
    }
  }

  Future<void> comprarCad(int qtdCads, String numeroCartao, String tipoPagamento,
      double valor) async {
    try {
      final cpf = Storagerds.boxcpf.read('cpfCnpj');
      final token = Storagerds.boxToken.read('token');
      
      if (cpf == null || token == null) {
        throw Exception('CPF ou token não disponíveis');
      }

      final cad = await cadsRepository.pagarCads(
          qtdCads, cpf, token, numeroCartao, tipoPagamento, valor);

      print("Compra realizada com sucesso: $cad");
      await loadCadsaldoApi(); // Atualiza o saldo após a compra
    } catch (e) {
      print("Erro ao comprar CADs: $e");
      FuncoesParaAjudar.logger.e("Erro ao comprar CADs: $e");
      rethrow; // Propaga o erro para tratamento na UI
    }
  }
  
  // Gestão de saldos
  void loadSaldo() {
    if (Storagerds.boxSaldo.read('saldo') != null) {
      saldoCad.value = Storagerds.boxSaldo.read("saldo").toString();
    }
  }

  Future<void> loadCadsaldoApi() async {
    try {
      final cpf = Storagerds.boxcpf.read('cpfCnpj');
      final token = Storagerds.boxToken.read('token');
      
      if (cpf == null || token == null) {
        throw Exception('CPF ou token não disponíveis');
      }
      
      final conta = await contaRepository.getConta(token, cpf);
      Storagerds.boxSaldo.write('saldo', conta.saldo);
      saldoCad.value = conta.saldo.toString();
    } catch (e) {
      print("Erro ao carregar saldo: $e");
      FuncoesParaAjudar.logger.e("Erro ao carregar saldo: $e");
    }
  }
  
  // Gestão de Tema
  void GetXSwitchState() {
    if (switchDataController.read('getxIsSwitched') != null) {
      isSwitched = switchDataController.read('getxIsSwitched');
      update();
    }
  }

  void changeSwitchSate(bool value) {
    isSwitched = value;
    switchDataController.write('getxIsSwitched', isSwitched);
    Get.changeTheme(isSwitched ? ThemeData.dark() : ThemeData());
    update();
  }

  void setTema() {
    final temaAtual = Storagerds.boxTema.read('boxTema');
    if (temaAtual == "dark") {
      Get.changeTheme(appTemaDark);
    } else {
      Get.changeTheme(appTema); // Padrão ou "light"
    }
  }
  
  // Funções do perfil de usuário
  Future<void> carregaDadosUserUpdate(BuildContext context) async {
    _mostrarLoadingDialog(context);

    Get.put(CadastroUsuarioEditarController());
    final cpf = Storagerds.boxcpf.read('cpfCnpj');
    final token = Storagerds.boxToken.read('token');
    
    if (cpf == null || token == null) {
      Get.back(); // Remove o diálogo de loading
      Get.snackbar(
        "Erro", 
        "Informações de usuário não disponíveis",
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: const Duration(seconds: 3)
      );
      return;
    }

    try {
      final user = await repository.getUsuario(token, cpf);
      if (user?.cpfcnpj != null) {
        Get.back(); // Remove o diálogo de loading
        Get.to(CadastroUsuarioEditarView(
          nomeAtual: user!.nome,
          cpfAtual: user.cpfcnpj,
          celularAtual: user.celular,
          emailAtual: user.email,
        ));
        detailUserPressed.value = false;
      } else {
        Get.back(); // Remove o diálogo de loading
        Get.snackbar(
          "Erro", 
          "Não foi possível obter dados do usuário",
          colorText: Colors.white,
          backgroundColor: errorColor,
          duration: const Duration(seconds: 3)
        );
      }
    } catch (e) {
      Get.back(); // Remove o diálogo de loading
      Get.snackbar(
        "Erro", 
        e.toString(),
        colorText: Colors.white,
        backgroundColor: errorColor,
        duration: const Duration(seconds: 3)
      );
    }
  }
  
  void _mostrarLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SimpleDialog(
          backgroundColor: Colors.transparent,
          children: [
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      }
    );
  }
  
  // Logout e utilitários
  Future<void> logout() async {
    // Lista de operações de limpeza
    final storageOperations = [
      Storagerds.boxcpf.erase(),
      Storagerds.boxToken.erase(),
      Storagerds.boxUserLogado.erase(),
      boxalertaSelecionado.erase(),
      Storagerds.boxvalorAlertaSelecionado.erase(),
      Storagerds.boxBiometria.erase(),
      Storagerds.boxExibirTelaIntroducao.erase(),
      Storagerds.boxListCartoes.erase(),
      Storagerds.boxListCartoesCredito.erase(),
      Storagerds.boxListCartoesDebito.erase(),
      Storagerds.boxListHistorico.erase(),
      Storagerds.boxEstacionado.erase(),
      Storagerds.boxIsEstacionado.write('boxIsEstacionado', false),
      boxbotaoEstacionarHabilitado.write('boxbotaoEstacionarHabilitado', true),
      Storagerds.boxTimer.write('timer', 0)
    ];
    
    // Executa todas as operações em paralelo
    await Future.wait(storageOperations);
    
    // Navegação após logout
    await Get.offAllNamed(Routes.WELCOME);
  }

  Future<void> show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }
}

// Função para exibir diálogo
void exibirDialogo() {
  Get.defaultDialog(
    backgroundColor: Colors.white,
    title: "Atenção",
    middleText: "Seu tempo de estacionamento acabou",
    barrierDismissible: false,
    confirm: ElevatedButton(
      onPressed: () {
        Get.back();
      },
      child: const Text(
        "OK",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}