// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

abstract class LoadAction {
  const LoadAction();
}

class LoadPersonAction implements LoadAction {
  final PersonsUrl personsUrl;

  LoadPersonAction(this.personsUrl);
}

enum PersonsUrl { person1, person2 }

extension UrlString on PersonsUrl {
  String get urlString {
    switch (this) {
      case PersonsUrl.person1:
        return 'http://127.0.0.1:5500/api/persons1.json';
      case PersonsUrl.person2:
        return 'http://127.0.0.1:5500/api/persons2.json';
    }
  }
}

@immutable
class Person {
  final String name;
  final int age;
  const Person({
    required this.name,
    required this.age,
  });

  Person copyWith({
    String? name,
    int? age,
  }) {
    return Person(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'age': age,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Person.fromJson(String source) =>
      Person.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Person(name: $name, age: $age)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Person && other.name == name && other.age == age;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((response) => response.transform(utf8.decoder).join())
    .then((str) => jsonDecode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromMap(e)));

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const FetchResult(
      {required this.persons, required this.isRetrievedFromCache});

  @override
  String toString() =>
      "FetchResult (isRetrievedFromCache: $isRetrievedFromCache, persons: $persons)";
}

class PersonBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonsUrl, Iterable<Person>> _cache = {};

  PersonBloc() : super(null) {
    on<LoadPersonAction>((event, emit) async {
      if (_cache.containsKey(event.personsUrl)) {
        final persons = _cache[event.personsUrl]!;
        emit(FetchResult(persons: persons, isRetrievedFromCache: true));
      } else {
        final persons = await getPersons(event.personsUrl.urlString);
        _cache[event.personsUrl] = persons;
        emit(FetchResult(persons: persons, isRetrievedFromCache: false));
      }
    });
  }
}

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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      context
                          .read<PersonBloc>()
                          .add(LoadPersonAction(PersonsUrl.person1));
                    },
                    child: const Text("Load Json #1")),
                TextButton(
                    onPressed: () {
                      context
                          .read<PersonBloc>()
                          .add(LoadPersonAction(PersonsUrl.person2));
                    },
                    child: const Text("Load Json #2"))
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
