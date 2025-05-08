import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../modules/WelcomePage/bindings/welcome_page_binding.dart';
import '../modules/WelcomePage/views/welcome_page_view.dart';
import '../modules/alarmePage/bindings/alarme_page_binding.dart';
import '../modules/alarmePage/views/alarme_page_view.dart';
import '../modules/cadastroUsuarioEditar/bindings/cadastro_usuario_editar_binding.dart';
import '../modules/cadastroUsuarioEditar/views/cadastro_usuario_editar_view.dart';
import '../modules/cadastro_usuario_page/bindings/cadastro_usuario_page_binding.dart';
import '../modules/cadastro_usuario_page/views/cadastro_usuario_page_view.dart';
import '../modules/cadastro_veiculo/bindings/cadastro_veiculo_binding.dart';
import '../modules/cadastro_veiculo/bindings/cadastro_veiculo_bindingWidget.dart';
import '../modules/cadastro_veiculo/views/cadastro_veiculo_Widget.dart';
import '../modules/cadastro_veiculo/views/cadastro_veiculo_view.dart';
import '../modules/cadastro_veiculo/views/editar_veiculo_view.dart';
import '../modules/cartao_credito/bindings/cartao_credito_Listagem_binding.dart';
import '../modules/cartao_credito/bindings/cartao_credito_binding.dart';
import '../modules/cartao_credito/views/cadastro_cartao_credito_view.dart';
import '../modules/cartao_credito/views/cartao_credito_listagem.dart';
import '../modules/cartao_debito/bindings/cartao_debito_binding.dart';
import '../modules/cartao_debito/bindings/cartao_debito_listagem_binding.dart';
import '../modules/cartao_debito/views/cadastro_cartao_debito_view.dart';
import '../modules/cartao_debito/views/cartao_debito_listagem.dart';
import '../modules/cartao_debito/views/cartao_debito_view.dart';
import '../modules/comprar_cad/bindings/comprar_cad_binding.dart';
import '../modules/comprar_cad/views/comprar_cad_view.dart';
import '../modules/configuracoes/bindings/configuracoes_binding.dart';
import '../modules/configuracoes/views/configuracoes_view.dart';
import '../modules/esquecerSenha/bindings/esquecer_senha_binding.dart';
import '../modules/esquecerSenha/views/esquecer_senha_view.dart';
import '../modules/estacionadoCard/bindings/estacionado_card_binding.dart';
import '../modules/estacionadoCard/views/estacionamentoAtual_card_view.dart';
import '../modules/estacionar/bindings/estacionar_binding.dart';
import '../modules/estacionar/views/estacionar_view.dart';
import '../modules/forma_de_pagamento/bindings/forma_de_pagamento_binding.dart';
import '../modules/forma_de_pagamento/views/forma_de_pagamento_view.dart';
import '../modules/historico/bindings/historico_binding.dart';
import '../modules/historico/views/historico_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/initial_page/bindings/initial_page_binding.dart';
import '../modules/initial_page/views/initial_page_view.dart';
import '../modules/intro2/bindings/intro2_binding.dart';
import '../modules/intro2/views/intro2_view.dart';
import '../modules/introducao/bindings/introducao_binding.dart';
import '../modules/introducao/views/introducao_view.dart';
import '../modules/login_page/bindings/login_page_binding.dart';
import '../modules/login_page/views/login_page_view.dart';
import '../modules/meus_veiculos/bindings/meus_veiculos_binding.dart';
import '../modules/meus_veiculos/views/meus_veiculos_view.dart';
import '../modules/pagamento/bindings/pagamento_binding.dart';
import '../modules/pagamento/views/pagamento_view.dart';
import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/welcome_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.INITIAL_PAGE;
  static const ALARME = Routes.ALARME_PAGE;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      bindings: [
        HomeBinding(),
        EstacionarBinding(),
        HistoricoBinding(),
        CartaoCreditoBinding(),
        ComprarCadBinding(),
        MeusVeiculosBinding(),
        CadastroVeiculoBinding(),
      ],
    ),
    GetPage(
      name: _Paths.INITIAL_PAGE,
      page: () => InitialPage(),
      binding: InitialPageBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_PAGE,
      page: () => LoginPageView(),
      binding: LoginPageBinding(),
    ),
    GetPage(
      name: _Paths.CADASTRO_USUARIO_PAGE,
      page: () => CadastroUsuarioPageView(),
      binding: CadastroUsuarioPageBinding(),
    ),
    GetPage(
      name: _Paths.CADASTRO_VEICULO,
      page: () => CadastroVeiculoView(),
      binding: CadastroVeiculoBinding(),
    ),
    GetPage(
      name: _Paths.CADASTRO_VEICULO_WIDGET,
      page: () => CadastroVeiculoWidget(),
      binding: CadastroVeiculoBindingWidget(),
    ),
    GetPage(
      name: _Paths.EDITAR_CADASTRO_VEICULO,
      page: () => EditarVeiculoView(),
      binding: CadastroVeiculoBinding(),
    ),
    GetPage(
      name: _Paths.PAGAMENTO,
      page: () => PagamentoView(),
      binding: PagamentoBinding(),
    ),
    GetPage(
      name: _Paths.COMPRAR_CAD,
      page: () => ComprarCadView(),
      binding: ComprarCadBinding(),
    ),
    GetPage(
      name: _Paths.CONFIGURACOES,
      page: () => ConfiguracoesView(),
      binding: ConfiguracoesBinding(),
    ),
    GetPage(
      name: _Paths.ESTACIONAR,
      page: () => EstacionarView(),
      bindings: [
        EstacionarBinding(),
        HomeBinding(),
        MeusVeiculosBinding(),
      ],
    ),
    GetPage(
      name: _Paths.CARTAO_CREDITO,
      page: () => CadastroCartaoCreditoView(),
      binding: CartaoCreditoBinding(),
    ),
    GetPage(
      name: _Paths.CARTAO_CREDITO_LISTAGEM,
      page: () => CartaoCreditoListagemView(),
      binding: CartaoCreditoListagemBinding(),
    ),
    GetPage(
      name: _Paths.CARTAO_DEBITO_LISTAGEM,
      page: () => CartaoDebitoListagemView(),
      binding: CartaoDebitoListagemBinding(),
    ),
    GetPage(
      name: _Paths.CARTAO_DEBITO,
      page: () => CartaoDebitoView(),
      binding: CartaoDebitoBinding(),
    ),
    GetPage(
      name: _Paths.CADASTRO_CARTAO_DEBITO,
      page: () => CadastroCartaoDebitoView(),
      binding: CartaoDebitoBinding(),
    ),
    GetPage(
      name: _Paths.MEUS_VEICULOS,
      page: () => MeusVeiculosView(),
      bindings: [
        MeusVeiculosBinding(),
      ],
    ),
    GetPage(
      name: _Paths.FORMA_DE_PAGAMENTO,
      page: () => FormaDePagamentoView(),
      binding: FormaDePagamentoBinding(),
    ),
    GetPage(
      name: _Paths.ESTACIONAMENTO_ATUAL_CARD,
      page: () => EstacionadoAtualCardView(),
      binding: EstacionadoAtualCardBinding(),
    ),
    GetPage(
      name: _Paths.HISTORICO,
      page: () => HistoricoView(),
      binding: HistoricoBinding(),
    ),
    GetPage(
      name: _Paths.INTRODUCAO,
      page: () => IntroducaoView(),
      binding: IntroducaoBinding(),
    ),
    GetPage(
      name: _Paths.INTRO2,
      page: () => Intro2View(),
      binding: Intro2Binding(),
    ),
    GetPage(
      name: _Paths.CADASTRO_USUARIO_EDITAR,
      page: () => CadastroUsuarioEditarView(),
      binding: CadastroUsuarioEditarBinding(),
    ),
    GetPage(
      name: _Paths.ALARME_PAGE,
      page: () => AlarmePageView(),
      binding: AlarmePageBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME_PAGE,
      page: () => WelcomePageView(),
      binding: WelcomePageBinding(),
    ),
    GetPage(
      name: _Paths.ESQUECER_SENHA,
      page: () =>  EsquecerSenhaView(),
      binding: EsquecerSenhaBinding(),
    ),
  ];
}
