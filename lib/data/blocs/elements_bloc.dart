import 'dart:math';

import 'package:elements/data/models/elements.dart';
import 'package:elements/data/models/user_elements.dart';
import 'package:elements/data/models/user_steps.dart';
import 'package:elements/data/repositories/elements_repository.dart';
import 'package:elements/data/repositories/steps_repository.dart';

class ElementsBloc {
  final int stepsPerElement = 500;
  final _stepsRepository = StepsRepository();
  final _elementsRepository = ElementsRepository();

  Stream<UserElements> get userElements => _elementsRepository.userElements;

  void convert() async {
    UserSteps userSteps = await _stepsRepository.userSteps.last;
    int conversions = (userSteps.activeSteps / stepsPerElement) as int;
    int active = userSteps.activeSteps % stepsPerElement;
    var elements = _randomElements(conversions);
    _elementsRepository.saveElements(
      water: elements.water,
      earth: elements.earth,
      fire: elements.fire,
      wind: elements.wind,
    );
    await _stepsRepository.setSteps(
        active, userSteps.consumedSteps + conversions * stepsPerElement);
  }

  Elements _randomElements(int conversions) {
    Elements elements = Elements();
    for (int i = 0; i < conversions; i++) {
      var element = Element.values[Random().nextInt(Element.values.length)];
      elements.addElement(element);
    }
    return elements;
  }
}
