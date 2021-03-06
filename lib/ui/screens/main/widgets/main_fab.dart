import 'package:elements/data/bloc_provider.dart';
import 'package:elements/data/blocs/elements_bloc.dart';
import 'package:elements/data/blocs/steps_bloc.dart';
import 'package:flutter/material.dart';

class MainFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FloatingActionButton(
        onPressed: () => BlocProvider.of<StepsBloc>(context).connect(),
//        onPressed: () => BlocProvider.of<ElementsBloc>(context).convert(),
        child: Image(
          image: AssetImage('images/fab.png'),
          width: 48,
          height: 48,
        ),
      );
}
