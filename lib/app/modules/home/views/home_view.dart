import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zona_azul/app/modules/comprar_cad_semBarr.dart/comprar_cad_view_semBarr.dart';
import 'package:zona_azul/app/modules/configuracoes/views/configuracoes_view.dart';
import 'package:zona_azul/app/modules/estacionar/controllers/estacionar_controller.dart';
import 'package:zona_azul/app/modules/historico/views/historico_view2.dart';
import 'package:zona_azul/app/modules/home/controllers/home_controller.dart';
import 'package:zona_azul/app/modules/home/views/widgets/body_home.dart';
import 'package:zona_azul/app/modules/meus_veiculos/views/meus_veiculos_view.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/theme/tema.dart';
import 'package:zona_azul/app/utils/funcoesutilsd.dart';

/// Enum para representar cada aba de forma semântica
enum AppTab { home, compra, historico, veiculos, configurar }

class HomeView extends StatelessWidget {
  final HomeController ctl = Get.find<HomeController>();

  HomeView({Key? key}) : super(key: key);

  /// Retorna o índice dinâmico de uma tab dentro da lista gerada
  int _tabIndex(AppTab tab, List<AppTab> tabs) => tabs.indexOf(tab);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final city = ctl.cidade.value;
      final hasCompra = city != 'Crato';

      // 1️⃣ Lista de abas ativas
      final tabs = <AppTab>[
        AppTab.home,
        if (hasCompra) AppTab.compra,
        AppTab.historico,
        AppTab.veiculos,
        AppTab.configurar,
      ];

      // 2️⃣ Páginas correspondentes
      final pages = <Widget>[
        const bodyHome(key: PageStorageKey(Routes.HOME)),
        if (hasCompra) ComprarCadViewSemBarr(),
        HistoricoViewSemBarra(),
        MeusVeiculosView(),
        const ConfiguracoesView(),
      ];

      // 3️⃣ Itens do BottomNavigationBar
      final navItems = <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: 'Home'),
        if (hasCompra)
          const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: 'Comprar CAD'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined), label: 'Histórico'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.car_repair_outlined), label: 'Meus Veículos'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.settings), label: 'Configurações'),
      ];

      // 4️⃣ Ajuste do índice atual se saiu do range
      if (ctl.currentIndex.value >= pages.length) {
        ctl.currentIndex.value = pages.length - 1;
      }

      return Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () => _configurandoModalBottomSheet(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Obx(() => AutoSizeText(
                        ctl.cidade.value,
                        maxLines: 1,
                        minFontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ),
                const SizedBox(width: 4), // Espaçamento entre texto e ícone
                const Icon(Icons.arrow_drop_down_sharp, color: Colors.white),
              ],
            ),
          ),
          centerTitle: false, // Garante que o título não tente centralizar
          titleSpacing: 0, // Reduz o espaço padrão do título
          actions: [
            Obx(() => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Center(
                    child: Text(
                      "MEUS CADS: ${ctl.saldoCad.value}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                )),
          ],
        ),
        drawer: _buildDrawer(context, tabs),
        body: PageView(
          controller: ctl.pageController,
          onPageChanged: (i) => ctl.currentIndex.value = i,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: ctl.currentIndex.value,
          onTap: (i) {
            ctl.currentIndex.value = i;
            ctl.pageController.jumpToPage(i);
          },
          items: navItems,
        ),
      );
    });
  }

  Widget _buildDrawer(BuildContext context, List<AppTab> tabs) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [
              UserAccountsDrawerHeader(
                onDetailsPressed: () {
                  ctl.detailUserPressed.value = !ctl.detailUserPressed.value;
                },
                accountName: const Text("Olá"),
                accountEmail:
                    Text("${GetStorage('nomeUsuario').read("nomeUsuario")}"),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage("assets/icons/user.png"),
                ),
              ),
              Obx(() => Visibility(
                    visible: ctl.detailUserPressed.value,
                    child: ListTile(
                      textColor: Colors.white,
                      title: const Text("Editar Cadastro"),
                      leading: const Icon(Icons.manage_accounts,
                          color: Colors.white),
                      onTap: () => ctl.carregaDadosUserUpdate(context),
                    ),
                  )),
              ListTile(
                textColor: Colors.white,
                onTap: () => Get.offAndToNamed(Routes.PAGAMENTO),
                title: const Text("Formas de Pagamento"),
                leading: const Icon(Icons.credit_card, color: Colors.white),
              ),
              ListTile(
                textColor: Colors.white,
                onTap: () =>
                    ctl.navigationPageview(_tabIndex(AppTab.veiculos, tabs)),
                title: const Text("Meus Veículos"),
                leading:
                    const Icon(Icons.car_repair_outlined, color: Colors.white),
              ),
              ListTile(
                textColor: Colors.white,
                onTap: () =>
                    ctl.navigationPageview(_tabIndex(AppTab.historico, tabs)),
                title: const Text("Histórico de uso"),
                leading:
                    const Icon(Icons.history_outlined, color: Colors.white),
              ),
              if (ctl.cidade.value != 'Crato')
                ListTile(
                  textColor: Colors.white,
                  onTap: () =>
                      ctl.navigationPageview(_tabIndex(AppTab.compra, tabs)),
                  title: const Text("Comprar CAD"),
                  leading: const Icon(Icons.shopping_cart_outlined,
                      color: Colors.white),
                ),
              ListTile(
                textColor: Colors.white,
                onTap: () =>
                    ctl.navigationPageview(_tabIndex(AppTab.configurar, tabs)),
                title: const Text("Configurações"),
                leading: const Icon(Icons.settings, color: Colors.white),
              ),
              ListTile(
                textColor: Colors.white,
                onTap: () => FuncoesParaAjudar.TermosDeUso(context),
                title: const Text("Termos de Uso"),
                leading: const Icon(Icons.document_scanner_outlined,
                    color: Colors.white),
              ),
            ]),
          ),
          const Divider(height: 10, thickness: 1),
          ListTile(
            textColor: Colors.white,
            title: const Text("Sair"),
            leading: const Icon(Icons.exit_to_app, color: Colors.white),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Confirmar Logout"),
                  content: const Text("Tem certeza de que deseja sair?"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text("Cancelar")),
                    TextButton(
                        onPressed: ctl.logout, child: const Text("Confirmar")),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _configurandoModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      context: context,
      builder: (_) => Wrap(children: _buildCityListTiles()),
    );
  }

  List<Widget> _buildCityListTiles() {
    final cities = ["Crato", "Juazeiro do Norte", "Aquiraz"];
    return cities
        .map((city) => Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(city),
                  onTap: () async {
                    ctl.cidade.value = city;
                    await Get.find<EstacionarController>().loadRegras(1);
                    Get.back();
                  },
                ),
                const Divider(height: 2, color: Colors.grey),
              ],
            ))
        .toList();
  }
}
