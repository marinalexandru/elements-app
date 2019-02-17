import 'package:elements/data/bloc_provider.dart';
import 'package:elements/data/repositories/steps_repository.dart';

class StepsBloc extends BlocBase {
  final _repository = StepsRepository();

  void connect() => _repository.connect();

  @override
  void dispose() {
    _repository.dispose();
  }
}
