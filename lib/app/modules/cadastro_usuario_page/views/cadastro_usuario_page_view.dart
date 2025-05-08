import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';
import 'package:zona_azul/app/data/global/constants.dart';
import 'package:zona_azul/app/data/global/validator.dart';
import 'package:zona_azul/app/routes/app_pages.dart';
import 'package:zona_azul/app/theme/app_theme.dart';
import 'package:zona_azul/app/theme/tema.dart';

import '../controllers/cadastro_usuario_page_controller.dart';

class CadastroUsuarioPageView extends GetView<CadastroUsuarioPageController> {
  final _chaveFormulario = GlobalKey<FormState>();

  var myControllernome = TextEditingController();
  var myControllercpfCnpj = TextEditingController();
  var myControllercelular = TextEditingController();
  var myControllerEmail = TextEditingController();
  var myControllerPassword = TextEditingController();
  final _myControllerPasswordConfirm = TextEditingController();

  CadastroUsuarioPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CADASTRO",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _chaveFormulario,
          child: ListView(
            shrinkWrap: true,
            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  "Informe os dados abaixo para efetuar seu cadastro",
                  style: TextStyle(
                    color: colorCustom.shade500,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
//
//*********************************CAmpos*********************************************************** */
//

              TextFormField(
                controller: myControllernome,
                decoration: const InputDecoration(hintText: "Nome"),
                validator: Validatorless.required("Nome Obrigatório"),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                  controller: myControllercpfCnpj,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "CPF"),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    //CpfInputFormatter(),
                  ],
                  validator: Validatorless.multiple([
                    Validatorless.required("CPF obrigatório"),
                    Validatorless.cpf("Digite um CPF válido"),
                  ])),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                  controller: myControllercelular,
                  //colocar mascara para ddd (xx) xxxxxxxxxxx
                  inputFormatters: [
                    TextInputMask(
                        mask: ['(99) 9999 9999', '(99) 99999 9999'],
                        reverse: false)
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Celular"),
                  validator: Validatorless.multiple([
                    Validatorless.required("Digite um numero de celular"),
                    Validatorless.min(15, "Numero incompleto"),
                  ])),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                  controller: myControllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: "Email"),
                  validator: Validatorless.multiple([
                    Validatorless.required("E-mail Obrigatório"),
                    Validatorless.email("E-mail Inválido"),
                  ])),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                  controller: myControllerPassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration:
                      const InputDecoration(hintText: "Senha (mínimo 3 dígitos)"),
                  validator: Validatorless.multiple([
                    Validatorless.required("Senha Obrigatória"),
                    Validatorless.min(
                        3, "Senha precisa ter pelo menos 3 caracteres")
                  ])),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _myControllerPasswordConfirm,
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(hintText: "Confirme sua senha"),
                validator: Validatorless.multiple([
                  Validatorless.required("Senha Obrigatória"),
                  Validatorless.min(
                      3, "Senha precisa ter pelo menos 3 caracteres"),
                  Validators.compare(myControllerPassword, "Senhas diferentes")
                ]),
              ),
              const SizedBox(
                height: 12,
              ),
//
//*****************************************Botões*****************************************************/
//

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Checkbox(
                        value: controller.aceiteTermos.value,
                        onChanged: (t) {
                          controller.aceiteTermos.value =
                              !controller.aceiteTermos.value;
                          print(
                              "aceite termos: ${controller.aceiteTermos.value}");
                          controller.box
                              .write("termos", controller.aceiteTermos.value);
                          print("box : ${controller.box.read("termos")} ");
                        }),
                  ),
                  GestureDetector(
                    child: Text(
                      "Li e concordo com os TERMOS DE USO.",
                      style: TextStyle(
                        color: colorCustom.shade500,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    const Text("Termos de Uso\n",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                        "1. Aceitação dos Termos e Condições Gerais de Uso do Aplicativo ESTACIONE JÁ\n",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                        " 1.1.   Os termos e condições gerais de uso, abaixo especificados e denominados como Termos e Condições ou Contrato, aplicam-se ao uso dos serviços oferecidos pela empresa W2E SOLUÇÕES TECNOLOGIA LTDA EPP empresa devidamente inscrita no CNPJ/MF sob o nº 15.676.890/0001-23, doravante nominada como Provedora, por meio de seu aplicativo para smartphones denominado ESTACIONE JÁ ou Aplicativo.\n  1.2. Qualquer pessoa que pretenda utilizar os serviços do Aplicativo deverá aceitar estes Termos e Condições, na forma abaixo descrita. A partir do aceite a estes Termos e Condições o interessado passa a ser usuário do Aplicativo, sendo, a partir de então, denominado Usuário\n 1.3. Para se tornar Usuário, o interessado deverá ler, certificar-se de haver entendido, e aceitar integralmente este Contrato, clicando no botão Li e Concordo. Esta ação o vinculará automaticamente às regras aqui contidas.\n 1.4. As informações presentes no Aplicativo poderão ser modificadas ou extintas a qualquer momento, sem que haja a necessidade de notificação prévia ao Usuário. O Usuário poderá a qualquer momento revisar a versão mais recente dos termos e condições de uso, acessando a opção Termos e Condições localizado no menu principal do Aplicativo. O Usuário será responsável por verificar periodicamente se ocorreram quaisquer mudanças neste termo. Se o Usuário continuar usando o Aplicativo após mudanças nos Termos e Condições, estará indicando automaticamente o seu aceite quanto às novas condições.\n 1.5. A ACEITAÇÃO DESTES TERMOS E CONDIÇÕES É ABSOLUTAMENTE INDISPENSÁVEL À UTILIZAÇÃO DO APLICATIVO.\n  "),
                                    //========================================================================================================================
                                    const Text("2. Definições adicionais\n",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                        " 2.1.  Crédito Eletrônico - unidade monetária emitida pelo aplicativo para posterior comercialização entre Provedora e Usuário através do Aplicativo.\n  2.2.  AUTENTICAÇÃO - identificação única fornecida pelo aplicativo após cada transação de Aquisição e/ou Ativação do estacionamento.\n 2.3.   AQUISIÇÃO - transação monetária realizada pelo Usuário no Aplicativo, para compra e Autenticação de 1 ou mais Créditos.\n 2.4.   ATIVAÇÃO - transação que ocorre mediante solicitação do Usuário no Aplicativo, dando ínicio ao tempo de validade do estacionamento, garantindo ao Usuário o direito de estacionar o veículo em uma das vagas demarcadas como estacionamento rotativo.\n 2.5.   REGRA DE ESTACIONAMENTO - período de estacionamento válido para cada estacionamento, de acordo com a regra de estacionamento definida pela prefeitura local. 1 Crédito tem validade de 1h.\n"),
                                    //==================================================================================================================================
                                    const Text("3. Descrição do Objeto\n",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                        "  3.1. O Aplicativo possibilita ao Usuário a Aquisição e Ativação de Créditos para uso das vagas de estacionamento rotativo de veículos.\n  3.2. O uso do Aplicativo deverá ser feito pelo Usuário através de seu smartphone pessoal, sempre mediante acesso à rede mundial de computadores - Internet.\n "),
                                    //============================================================================================================================================================
                                    const Text(
                                        "4. Do Cadastro de Usuário e Veículos\n",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),

                                    const Text(
                                        "  4.1. A primeira etapa do cadastro no Aplicativo diz respeito ao veículo. Deverão ser informados o Tipo (carro ou caminhão), Placa e Modelo.\n 4.2. Ao preencher os dados pessoais, o Usuário poderá fornecer dados como Pessoa Física ou Jurídica.\n  4.2.1. Em caso de Pessoa Física, deverá informar Nome, E-mail, CPF, Data de nascimento e Senha.\n 4.2.2. Em caso de Pessoa Jurídica, deverá informar Razão social, E-mail, CNPJ e Senha.\n  4.2.3. A Pessoa Jurídica deverá cadastrar-se por meio de seu representante legal ou procurador devidamente constituído.\n 4.3. O envio de mensagens para o e-mail informado pelo Usuário fica definido como uma forma válida de comunicação entre as partes.\n  4.4. A senha deverá conter pelo menos 6 caracteres e é de uso pessoal e intransferível.\n 4.4.1. Caso o Usuário desconfie que sua senha foi roubada e/ou está sendo utilizado por terceiros, deverá imediatamente informar o ocorrido através da opção Reportar problema no menu do aplicativo, bem como utilizar a função Definir nova senha na seção Editar Cadastro.\n 4.5. O Usuário poderá alterar seus dados pessoais a qualquer momento, com exceção do CPF ou CNPJ informados no momento do cadastro.\n 4.5.1. Caso seja necessário alterar as informações de CPF e CNPJ, o Usuário deverá entrar em contato com o suporte do aplicativo, através do e-mail XXXXX.@w2esolucoes.com.br\n 4.5.2. É possível cadastrar novos veículos através da função Editar/Cadastrar veículos disponível na tela principal do Aplicativo.\n"),
                                    //========================================================================================================================================================================
                                    const Text("5. Da Aquisição de Créditos\n",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                      "  5.1. A compra de Créditos poderá ser feita mediante cadastramento de um Cartão de Crédito válido, ou mesmo através de Boleto Bancário, Cartão de Débito e Transferência Bancária. Para isso, o Usuário deverá utilizar a opção Comprar Créditos, presente no menu do Aplicativo.\n  5.2. O Usuário poderá comprar R\$ 10, R\$ 20, R\$ 30, R\$ 40, R\$ 50 e R\$ 60 em Créditos.\n  5.3. O Usuário poderá adquirir Créditos antecipadamente, ou fazê-lo no momento que desejar estacionar o veículo. Nesse caso, ocorrerão simultaneamente as etapas de Aquisição e Ativação de Crédito.\n",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    //========================================================================================================================================================================
                                    const Text("6. Da Ativação do Estacionamento\n",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                        " 6.1. Para habilitar o estacionamento em vagas demarcadas para este fim, o Usuário precisará fazer a Ativação de Créditos através do Aplicativo.\n 6.2. Para fazer uma Ativação, é necessário adquirir 1 ou mais Créditos.\n 6.3. O Usuário poderá ativar 1 Crédito por veículo e local.\n 6.4. Pode haver regra da prefeitura quanto ao limite máximo de placas ativadas dentro do período de 1 dia.\n  6.5. O Usuário deverá escolher qual veículo deseja fazer a ativação, usar a função Estacionar e confirmar a REGRA DE ESTACIONAMENTO correta, vigente para o local e horário desejados.\n  6.6. Instantes após o Usuário confirmar que deseja mesmo fazer a ativação, o Aplicativo informará se a transação de Ativação foi bem sucedida ou não.\n 6.7. Em caso de sucesso, o Aplicativo exibirá a tela de confirmação contendo o comprovante com os detalhes da Ativação, bem como o código de autenticação.\n  6.8. Caso o Usuário tenha permitido que o Aplicativo envie notificações de alerta, serão enviados 3 avisos de que o tempo de estacionamento está próximo de acabar (20 min, 10 min e expirado).\n 6.9. Em caso de falta de conexão, ou falha no momento da Ativação através do Aplicativo, OU MESMO NA IMPOSSIBILIDADE DE ATIVAÇÃO DO ESTACIONAMENTO POR QUALQUER RAZÃO, NÃO PERMANEÇA COM O VEÍCULO ESTACIONADO, POIS ELE ESTARÁ EM SITUAÇÃO IRREGULAR.\n  6.10. Ao expirar o tempo limite da ativação, remova o carro do local pois do contrário ele estará irregular.\n",
                                        style: TextStyle(
                                          color: Colors.red,
                                        )),
                                    //========================================================================================================================================================================
                                    const Text("7. Condições Gerais do Serviço\n",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                        "  7.1. O Usuário poderá utilizar o Aplicativo 24 (vinte e quatro) horas por dia, 7 (sete) dias por semana, salvo eventuais interrupções que se façam necessárias por ocasião de manutenção do sistema ou base de dados, falhas em decorrência da falta de fornecimento de energia elétrica e/ou telecomunicação, casos fortuitos e força maior, ou ainda, ações ou omissões de terceiros.\n 7.2. O Usuário declara ser o único responsável pela aquisição, contratação, instalação e manutenção de quaisquer equipamentos e/ou serviços necessários para utilização da Internet (telefone celular, computador, linha telefônica, provedor de acesso, energia elétrica e outros).\n  7.3. O Usuário declara estar ciente que eventuais problemas na contratação, falta de disponibilidade e/ou cobrança dos serviços/equipamentos de telecomunicação e/ou conexão à Internet deverão ser resolvidos diretamente com as empresas fornecedoras dos respectivos serviços/equipamentos, sem qualquer responsabilidade ou interferência da Provedora.\n "),
                                    //========================================================================================================================================================================
                                    const Text("8. Das Obrigações do Usuário\n",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                        "8.1. Observar e seguir rigorosamente as regras de trânsito e de estacionamento vigentes para a área e horário em que o veículo estiver estacionado.\n 8.2. Informar ao Aplicativo, sempre que solicitado, dados verdadeiros e corretos, incluindo, mas não se limitando aos seus dados pessoais, de veículos, de cartões de crédito, bem como sobre o tempo e regras para estacionamento.\n 8.3. Manter seus dados pessoais atualizados no Aplicativo, editando-os sempre que sofrerem alguma alteração.\n  8.4. Utilizar as funcionalidades do Aplicativo ou demais serviços oferecidos pela Provedora com total boa-fé e probidade, e nunca para fins ilegais, fraudulentos, ou em desacordo com a legislação brasileira, dolosa ou culposamente.\n 8.5. Guardar absoluto sigilo sobre sua senha de acesso, realizando a respectiva troca sempre que julgar necessário ou o Aplicativo assim sugerir;\n 8.6. Notificar imediatamente a Provedora, através das funções Fale Conosco ou Reportar problema do Aplicativo, caso identifique qualquer falha, mal funcionamento, ou mesmo informação incorreta que possa vir a causar quaisquer danos ou prejuízos à Provedora ou demais Usuários;\n  8.7. Não tentar, de nenhuma forma, obter acesso não autorizado aos sistemas da Provedora e/ou de suas afiliadas, violando sistemas de segurança ou utilizando qualquer método de invasão e/ou outros considerados de má-fé ou ilegais.\n  8.8. Sem prejuízo das obrigações previstas neste instrumento, o Usuário declara-se ciente que poderá responder civil, criminal e administrativamente, pelos danos ou prejuízos que seus atos possam vir a causar.\n "),

                                    //==================================================================================================================================================================================================================================
                                    const Text("9. Política de Privacidade\n",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                        "Esta Política de Privacidade descreve como a Provedora coleta e utiliza as informações coletadas do Usuário.\n9.1. Controlador dos Dados\n9.1.1. O Controlador dos Dados fornecidos pelo Usuário é:\n W2E SOLUÇÕES TECNOLOGIA LTDA EPP\n  Rua Isaias Bevilaqua, nº 63, Maraponga, Fortaleza/CE\n  CEP 60.711232\n 9.1.2. Dúvidas ou comentários com relação a esta Política de Privacidade podem ser encaminhadas ao Encarregado da Provedora, em: XXXXX.@w2esolucoes.com.br \n 9.2 Informações Coletadas\n 9.2.1. As seguintes informações são coletadas por ou em nome da Provedora:\n  9.2.1.1. Informações de perfil: a Provedora coleta informações quando o Usuário cria ou atualiza sua conta no Aplicativo. No caso de Pessoa Física, essas informações incluem nome, e-mail, CPF, data de nascimento, senha, telefone, endereço com CEP, informações de pagamento, placa e RENAVAM dos veículos a serem utilizados.\n  9.2.1.2. Conteúdo produzido pelo Usuário: informações submetidas pelo Usuário quando entra em contato com o serviço de suporte ao Usuário, quando fornece revisões ou comentários, ou quando de qualquer outra forma entrar em contato com a Provedora.\n 9.2.2. Informações criadas quando o Usuário utiliza o Aplicativo\n  9.2.2.1. Informações de localização: a Provedora coleta informações de localização exatas ou aproximadas, por meio de GPS, endereço IP e Wi-Fi. A Provedora coleta as informações de localização quando o Aplicativo está operando em primeiro plano somente. O Usuário pode ser impedido de utilizar algumas funções do aplicativo caso não habilite a coleta de informações de localização pela Provedora, a depender das regras determinadas para cada função."),
                                    const Text(
                                      "Por exemplo, pode ser exigido pela AUTARQUIA informar a localização do Usuário para Ativação do estacionamento rotativo / regulamentado. Da mesma forma, é exigido que se informe a localização precisa do aparelho ao utilizar o abastecimento de combustível, para certificar-se que o Usuário está devidamente localizado em um posto compatível com o abastecimento.",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    const Text(
                                        "9.2.2.2. Informações de transação: a Provedora coleta informações relacionadas ao uso efetivo, pelo Usuário, dos serviços oferecidos pelo Aplicativo, incluindo data e hora de cada pedido, valor cobrado em cada transação e método de pagamento.\n  9.2.2.3. Informações de utilização do Aplicativo: a Provedora pode coletar informações relacionadas à utilização do Aplicativo, incluindo data e hora de acesso ao Aplicativo, funcionalidades, configurações e preferências do Aplicativo, bem como páginas acessadas por meio dele, tipo de browser e serviços ou páginas de terceiros que o Usuário estava utilizando antes de acessar o Aplicativo. Essas informações são coletadas por meio de cookies, pixel tags e tecnologias similares que criam identificadores.\n  9.2.2.4. Informações do dispositivo: a Provedora coleta informações sobre o dispositivo utilizado pelo Usuário para acessar o Aplicativo, incluindo o modelo de hardware, endereço IP, software, informações de rede e identificador do dispositivo (device ID) para prevenção à fraudes.\n 9.2.3. Outras informações\na) Informações fornecidas por terceiros parceiros da Provedora, por meio dos quais o Usuário acessa ou utiliza o Aplicativo, tais quais mídias sociais, provedores de pagamentos ou quaisquer aplicativos ou websites que utilizam a API da Provedora ou de que a Provedora utilize a API.\nb) Informações públicas.\nc) Informações oriundas de serviços de marketing.\nd) Todas as informações poderão ser combinadas com outras informações que a Provedora possui.\n9.3. Como as informações são utilizadas pela Provedora\n9.3.1. A Provedora coleta e utiliza informações para viabilizar a utilização dos serviços e funcionalidades oferecidos por meio do Aplicativo. As informações também são utilizadas para oferecer atendimento ao Usuário, para fins de pesquisa e desenvolvimento, para promover eventos ou produtos e em conexão com eventuais procedimentos legais.\n9.3.2. Utilização dos serviços e funcionalidades: a Provedora utiliza as informações do Usuário para oferecer, personalizar e melhorar os produtos e serviços oferecidos por meio do Aplicativo, a exemplo de:\na) Criar e atualizar a conta do Usuário;\nb) Verificar a identidade do Usuário;\nc) Viabilizar a utilização dos serviços;\nd) Garantir a segurança das transações de pagamentos através de análise anti-fraude;\ne) Processar ou facilitar pagamentos pela utilização dos serviços oferecidos por meio do Aplicativo;\nf) Realizar operações internas necessárias para a prestação dos serviços, incluindo verificar bugs, conduzir análises de dados, testes e pesquisas, e monitorar e analisar os dados de uso e tendências de atividade.\n9.3.3. Atendimento ao usuário: a Provedora utiliza as informações coletadas (inclusive gravações de ligações ao suporte técnico após devida autorização pelo Usuário) para auxiliar o Usuário, a exemplo de:\na) Direcionar o questionamento do Usuário à área responsável;\nb) Investigar e solucionar a demanda do Usuário;\nc) Monitorar e melhorar o serviço de suporte ao Usuário.\n9.3.4. Pesquisa e desenvolvimento: a Provedora poderá utilizar as informações coletadas para testes, pesquisas, análises internas e desenvolvimento de produtos de forma que os serviços oferecidos possam ser aprimorados, com novas funcionalidades e produtos.\n9.3.5. Promoção de eventos ou produtos: a Provedora utiliza as informações coletadas para comunicar o Usuário sobre produtos, serviços, promoções, estudos, notícias e eventos. A Provedora poderá utilizar as informações também para comunicar o Usuário sobre serviços e produtos oferecidos por parceiros da Provedora.\n9.3.6. Eventuais procedimentos legais: a Provedora poderá utilizar as informações coletadas para investigar ou endereçar eventuais requerimentos judiciais ou disputas relacionadas à utilização do Aplicativo pelo Usuário, ou de qualquer outra forma conforme determinado em legislação aplicável.\n9.4. Cookies e tecnologias de terceiros\n9.4.1. A Provedora e seus parceiros utilizam cookies e outras tecnologias de identificação em seus aplicativos, websites e emails.\n9.4.2. Cookies são arquivos de texto simples armazenados no navegador ou no dispositivo e enviados por websites, aplicativos e propagandas. A Provedora utiliza cookies e tecnologias similares para finalidades tais quais:\na) Autenticação do Usuário;\nb) Gravação de preferências e configurações;\nc) Avaliação de popularidade do conteúdo oferecido pela Provedora;\nd) Mensuração de efetividade de campanhas de marketing;\ne) Análise do comportamento online do Usuário quando interage com os serviços oferecidos pela Provedora e seus parceiros. A Provedora poderá utilizar terceiros fornecedores de serviços de análise de dados e de serviços de marketing e propaganda. Estes terceiros também podem utilizar cookies, web beacons, SDKs e outras tecnologias para identificação do Usuário quando o Usuário utiliza o Aplicativo e os serviços oferecidos pela Provedora.\n9.5. Compartilhamento de informações\n9.5.1. Os produtos e serviços oferecidos pela Provedora exigem que a Provedora compartilhe informações com terceiros. As informações poderão ser compartilhadas com afiliadas e subsidiárias da Provedora e com prestadores de serviço e parceiros da Provedora, conforme Cláusula 9.3.6 desta Política e nas demais situações conforme exemplificado abaixo.\na) Compartilhamento de informações com AUTARQUIAS;\nb) Compartilhamento de informações com o público em geral quando a informação é submetida em fórum público.\n9.5.2. Quando o Usuário se comunica com a Provedora por meio de fóruns públicos tais quais redes sociais, lojas de aplicativos e via funcionalidades do Aplicativo que os ofereçam, estas comunicações podem ser compartilhadas com o público em geral.\na) Compartilhamento de informações com afiliadas e subsidiárias da Provedora;\nb) Compartilhamento de informações com prestadores de serviço e parceiros da Provedora.\n9.5.3. A Provedora poderá compartilhar as informações com seus prestadores de serviço, parceiros de marketing e demais parceiros de negócios, tais quais:\na) Processadores de pagamentos;\nb) Prestadores de serviço de armazenamento de dados em cloud;\nc) Parceiros de marketing e plataformas de marketing;\nd) Provedores de análise de dados;\ne) Parceiros de negócios que o Usuário manifestar interesse de utilizar através do Aplicativo.\n9.5.4. Compartilhamento de informações se exigido pela legislação aplicável ou em caso de eventual procedimento legal.\n9.5.5. As informações poderão ser compartilhadas caso necessário conforme determinado em legislação aplicável, em procedimento legal ou caso solicitado pelas autoridades oficiais.\n9.5.6. A Provedora poderá compartilhar informações em outras hipóteses não listadas nesta Política, mediante prévio consentimento do Usuário.\n9.6. Retenção e exclusão de informações\n9.6.1. A Provedora solicita informações do Usuário para prover os serviços por meio do Aplicativo e retém estas informações pelo período em que o Usuário mantém sua conta no Aplicativo. Certas informações, tais quais informações de transação, de localização, relacionadas ao dispositivo e de utilização do Aplicativo, poderão ser retidas pelo período de 10 (dez) anos, conforme disposto no Código Civil. Quaisquer informações não mais necessárias para prover os serviços deixarão de ser utilizadas e serão mantidas apenas para cumprimento de obrigações legais ou regulatórias.\n"),

                                    //==================================================================================================================================================================================================================================
                                    const Text("9.7. Direitos do Usuário\n",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                        "9.7.1 O Usuário tem os seguintes direitos com relação à utilização de seus dados pela Provedora, que poderão ser exercidos mediante requisição por email enviado ao endereço indicado na Cláusula 9.2.2 acima: XXXXX.@w2esolucoes.com.br\na) Confirmação da existência de tratamento;\nb) Acesso aos dados;\nc) Correção de dados incompletos, inexatos ou desatualizados;\nd) Anonimização, bloqueio ou eliminação de dados desnecessários, excessivos ou tratados em desconformidade com o disposto nesta Lei;\ne) Portabilidade dos dados a outro fornecedor de serviço ou produto, mediante requisição expressa, de acordo com a regulamentação da autoridade nacional, observados os segredos comercial e industrial;\nf) Eliminação dos dados pessoais tratados com o consentimento do titular, exceto nas hipóteses previstas no art. 16 desta Lei;\ng) Informação das entidades públicas e privadas com as quais o controlador realizou uso compartilhado de dados;\nh) Informação sobre a possibilidade de não fornecer consentimento e sobre as consequências da negativa;\ni) Revogação do consentimento, nos termos do § 5º do art. 8º da Lei Geral de Proteção de Dados (LGPD);\nj) Petição contra o controlador perante a autoridade nacional, relacionada a seus dados;\nk) Oposição a tratamento realizado com fundamento em uma das hipóteses de dispensa de consentimento, em caso de descumprimento ao disposto na Lei Geral de Proteção de Dados (LGPD).\n9.8. Atualizações a esta Política de Privacidade\n9.8.1. A Provedora poderá atualizar esta Política de Privacidade sem prévio aviso ao Usuário. Ao utilizar os serviços oferecidos pela Provedora, o Usuário aceita esta Política de Privacidade.\n"),
                                    //==========================================================================================
                                    const Text(
                                        "10. Das Responsabilidades da Provedora\n",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                        "10.1. A Provedora não se responsabiliza, em nenhuma hipótese, por quaisquer despesas, prejuízos e/ou danos causados ao Usuário ou a terceiros, ocasionados:\n10.1.1. pela perda da senha do Usuário ou utilização desta por outrem.\n10.1.2. por erros de digitação, incluindo, mas não se limitando à PLACA DO VEÍCULO cadastrado no Aplicativo.\n10.1.3. pela inobservância, desatenção ou entendimento equivocado, por parte do Usuário, quanto às regras de trânsito e/ou de estacionamento do local onde o veículo será estacionado;\n10.1.4. pela utilização incorreta do Aplicativo, incluindo, mas não se limitando a eventuais erros durante o processo de Ativação dos Créditos adquiridos, ou ainda quando o veículo não for retirado da vaga após ter excedido o tempo máximo permitido;\n10.1.5. por quaisquer penalidades de trânsito recebidas pelo Usuário, incluindo mas não se limitando a multas relacionadas a estacionamento irregular;\n10.1.6. pela aquisição, contratação ou negociação de qualquer natureza envolvendo o Usuário e titulares de empresas/sites terceiras, mesmo quando decorrer de publicidade anunciada dentro do Aplicativo;\n10.1.7. pelo dano, prejuízo ou perda de quaisquer equipamentos do Usuário, causados por falha no sistema, no servidor ou na internet, ou em decorrência da transferência de dados, arquivos, imagens e textos para o equipamento do Usuário;\n10.1.8. pelo mal funcionamento de equipamentos ou serviços de telecomunicação, bem como de softwares de terceiros, utilizados pelo Usuário.\n"),
                                    //======================================================================================================================
                                    const Text(
                                        "11. Exclusão do Aplicativo e Estorno de Créditos\n",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                      "11.1. Caso o Usuário decida deixar de utilizar o Aplicativo, ou mesmo excluí-lo de seu smartphone, Créditos anteriormente adquiridos serão estornados após solicitação de estorno através de canal exclusivo dentro do próprio aplicativo.\n11.2. Em nenhuma hipótese a Provedora fará o estorno de Créditos adquiridos.\n",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    const Text(
                                        "12. Exclusão de Garantias e de Responsabilidade\n",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                        "Em decorrência de questões operacionais ou de terceirização de serviços, o Aplicativo e os serviços estão sujeitos a eventuais problemas de interrupção, falha técnica, ou indisponibilidade de funcionamento temporário. Quando for razoavelmente possível, o Aplicativo advertirá previamente as interrupções do seu funcionamento e dos Serviços aos seus USUÁRIOS.\nO Aplicativo SE EXIME, COM TODA A EXTENSÃO PERMITIDA PELO ORDENAMENTO JURÍDICO, DE QUALQUER RESPONSABILIDADE PELOS DANOS E PREJUÍZOS DE TODA NATUREZA QUE POSSAM DECORRER DA FALTA DE DISPONIBILIDADE OU DE CONTINUIDADE DO FUNCIONAMENTO DO APLICATIVO E DOS SERVIÇOS, À DEFRAUDAÇÃO DA UTILIDADE QUE OS USUÁRIOS POSSAM TER ATRIBUÍDO AO APLICATIVO E AOS SERVIÇOS, À FALIBILIDADE DO APLICATIVO E DOS SERVIÇOS E, EM PARTICULAR, AINDA QUE NÃO DE MODO EXCLUSIVO, ÀS FALHAS DE ACESSO AO APLICATIVO.\n"),
                                    //=======================================================================================================
                                    const Text("13. Do Foro\n",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                        "As partes elegem o Foro Central da Comarca de Fortaleza/CE para dirimir eventuais dúvidas ou controvérsias decorrentes do presente Contrato, excluindo-se qualquer outro, por mais privilegiado que seja.\n"),
                                    Row(
                                      children: [
                                        Obx(
                                          () => Checkbox(
                                              value:
                                                  controller.aceiteTermos.value,
                                              onChanged: (t) {
                                                controller.aceiteTermos.value =
                                                    !controller
                                                        .aceiteTermos.value;
                                                print(
                                                    "aceite termos: ${controller.aceiteTermos.value}");
                                                controller.box.write(
                                                    "termos",
                                                    controller
                                                        .aceiteTermos.value);
                                                print(
                                                    "box : ${controller.box.read("termos")} ");
                                              }),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Li e concordo com os TERMOS DE USO.",
                                            style: TextStyle(
                                              color: colorCustom.shade500,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  )
                ],
              ),

              Obx(
                () => Visibility(
                  visible: !controller.loading.value,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                          style: _cadastrarButtonStyle(),
                          onPressed: !controller.aceiteTermos.value
                              ? null
                              : () {
                                  var formValid = _chaveFormulario.currentState
                                          ?.validate() ??
                                      false;
                                  if (formValid == true) {
                                    String cpf = myControllercpfCnpj.text;

                                    controller.emailTextController =
                                        myControllerEmail.text;
                                    controller.passwordTextController =
                                        myControllerPassword.text;
                                    controller.nomeTextController =
                                        myControllernome.text;
                                    GetUtils.isCpf(cpf)
                                        ? controller.cpfCnpjTextController =
                                            myControllercpfCnpj.text
                                        : Error();
                                    controller.celularTextController =
                                        myControllercelular.text;

                                    controller.cadastrar();
                                  }
                                },
                          child: const Text(
                            'CADASTRAR',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ))),
                ),
              ),
              /////////////////////////////////////
              ///
              ///
              ///
              Obx(
                () => Visibility(
                  visible: controller.loading.value,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        style: _cadastrarButtonStyle(),
                        onPressed: () {},
                        child: const SizedBox(
                            height: 30, child: CircularProgressIndicator()),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_cadastrarButtonStyle() {
  //estilo do botao cadastrar
  return ButtonStyle(
      //primary: Color.fromARGB(255, 129, 212, 250),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        return const Color(0xFFffcc43);
      }),
      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(12)),
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(20));
      }));
}

//testes abaixo

_confirmaCadastroSnackbar() {
  Get.snackbar("Parabens", "Usuario Registrado com sucesso",
      backgroundColor: successColor, colorText: Colors.white);
}

_confirmaCadastroBottonSheet() {
  Get.bottomSheet(
    ListTile(
        leading: const Icon(Icons.music_note),
        title: const Text('Músicas'),
        onTap: () => {}),
  );
}
