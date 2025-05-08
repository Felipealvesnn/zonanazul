import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/controllers/cadastro_veiculo_controllerWidget.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/cadastro_veiculo_Widget.dart';
import 'package:zona_azul/app/modules/cadastro_veiculo/views/editar_veiculo_view.dart';
import 'package:zona_azul/app/modules/cartao_credito/views/cadastro_cartao_credito_view.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:zona_azul/main.dart';

class IntroducaoView extends StatelessWidget {
  VeiculoControllerWidget veiculoControllerWidget = VeiculoControllerWidget();

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => VeiculoControllerWidget());
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  /*  void _onIntroEnd(context) {
    /*  Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HomePage()),
    ); */
    homeController.exibirTelaIntroducao.value = false;
    homeController.boxExibirTelaIntroducao
        .write('boxExibirTelaIntroducao', false);
    homeController.loadVeiculos();
    veiculoControllerWidget.verificaSaldoVeiculos;
  } */

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return GestureDetector(
        onTap: () {
          //_onIntroEnd(context);
          // Get.offAllNamed(Routes.HOME);
        },
        child: Image.asset('assets/$assetName', width: width));
  }

  @override
  Widget build(BuildContext context) {
    VeiculoControllerWidget veiculoControllerWidget = VeiculoControllerWidget();

    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _buildImage('flutter.png', 50),
          ),
        ),
      ),

      pages: [
        PageViewModel(
          title: "Cadastre seus veiculos",
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Container(child: CadastroVeiculoWidget())],
          ),
          /*
              "Instead of having to buy an entire share, invest any amount you want.", */
          image: _buildImage('intro1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Cadastre seu cartão de credito",
          body: "",
          image: _buildImage('intro2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Efetue compra de seu Cartao Azul Digital (CAD)",
          body: "",
          image: _buildImage('intro3.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Estacione já",
          body: "",
          image: _buildImage('intro4.png'),
        ),
      ],
      onDone: () => veiculoControllerWidget.verificaSaldoVeiculos(context),
      //onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip:
          const Text('Ignorar', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done:
          const Text('Começar', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text("This is the screen after Introduction")),
    );
  }
}
