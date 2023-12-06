import 'package:flutter/material.dart';
import 'dart:math' as math show Random;

import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

const names = ['Foo', 'Bar', 'Baz', 'Qux', 'Quux', 'Corge', 'Grault', 'Garply'];

extension RandomList<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() => emit(names.getRandomElement());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    super.dispose();
    cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<String?>(
            stream: cubit.stream,
            builder: (context, snapshot) {
              final button = ElevatedButton(
                onPressed: cubit.pickRandomName,
                child: const Text('Pick a random name'),
              );
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return button;
                case ConnectionState.active:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.data ?? '',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      button,
                    ],
                  );
                case ConnectionState.done:
                  return const SizedBox.shrink();
              }
            }),
      ),
    );
  }
}
