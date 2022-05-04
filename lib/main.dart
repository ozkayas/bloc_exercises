import 'package:flutter/material.dart';
import 'dart:math' as math show Random;

import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MaterialApp(theme: ThemeData.dark(), home: const HomePage()));
}

const names = ['Foo', 'Bar', 'Baz'];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() {
    emit(names.getRandomElement());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit _cubit;

  @override
  void initState() {
    _cubit = NamesCubit();
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<String?>(
        stream: _cubit.stream,
        builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(snapshot.data ?? "Press Button for A new Name"),
                TextButton(
                    onPressed: _cubit.pickRandomName,
                    child: Text('Pick Random Name'))
              ],
            ),
          );
        },
      ),
    );
  }
}
