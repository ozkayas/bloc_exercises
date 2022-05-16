// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:developer' as devtools show log;

import 'package:bloc_exercises/bloc/bloc_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/person.dart';
import 'bloc/persons_bloc.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(MaterialApp(
      // theme: ThemeData(),
      home: BlocProvider(
    create: (_) => PersonBloc(),
    child: const HomePage(),
  )));
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((response) => response.transform(utf8.decoder).join())
    .then((str) => jsonDecode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromMap(e)));

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      context.read<PersonBloc>().add(const LoadPersonAction(
                          url: persons1Url, loader: getPersons));
                    },
                    child: const Text('Load Json #1')),
                TextButton(
                    onPressed: () {
                      context.read<PersonBloc>().add(const LoadPersonAction(
                          url: persons2Url, loader: getPersons));
                    },
                    child: const Text('Load Json #2'))
              ],
            ),
            BlocBuilder<PersonBloc, FetchResult?>(
                buildWhen: ((previous, current) {
              return previous?.persons != current?.persons;
            }), builder: (_, state) {
              state?.log();
              return state == null
                  ? const SizedBox()
                  : Flexible(
                      child: ListView.builder(
                        itemCount: state.persons.length,
                        itemBuilder: (_, index) =>
                            ListTile(title: Text(state.persons[index]!.name)),
                      ),
                    );
            })
          ],
        ),
      ),
    );
  }
}
