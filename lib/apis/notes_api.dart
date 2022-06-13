import 'package:bloc_exercises/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();
  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  });
}

class NotesApi implements NotesApiProtocol {
  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    var validToken = await Future.delayed(
      const Duration(seconds: 2),
      (() => loginHandle == const LoginHandle.foobar()),
    );
    return validToken ? mockNotes : null;
  }
}
