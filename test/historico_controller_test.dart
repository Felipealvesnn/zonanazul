import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:zona_azul/app/data/models/historico_estacionamento_model.dart';
import 'package:zona_azul/app/data/repository/historicoEstacionamento_repository.dart';
import 'package:zona_azul/app/modules/historico/controllers/historico_controller.dart';
import 'package:zona_azul/app/utils/getStorages.dart';

class MockHistoricoEstacionamentoRepository extends Mock
    implements HistoricoEstacionamentoRepository {}

void main() {
  final mockRepository = MockHistoricoEstacionamentoRepository();
  final controller = HistoricoController();

  test('functionAtualizarHistoricoEstacionamento fetches data successfully',
      () async {
    // Arrange
    final cpf = 'mocked_cpf';
    final token = 'mocked_token';
    final mockedData = <HistoricoEstacionamento>[/* mocked data here */];

    when(Storagerds.boxcpf.read('cpfCnpj')).thenReturn(cpf);
    when(Storagerds.boxToken.read('token')).thenReturn(token);
    when(mockRepository.listarUltimoHistoricoEstacionamento(cpf, token))
        .thenAnswer((_) async => mockedData);

    // Act
    await controller.functionAtualizarHistoricoEstacionamento();

    // Assert
    expect(controller.isloadingPageHitory, false);
    expect(controller.historico, equals(mockedData));
  });
}
