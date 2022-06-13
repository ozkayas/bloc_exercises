import 'package:bloc_exercises/apis/login_api.dart';
import 'package:bloc_exercises/apis/notes_api.dart';
import 'package:bloc_exercises/bloc/actions.dart';
import 'package:bloc_exercises/bloc/app_state.dart';
import 'package:bloc_exercises/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({required this.loginApi, required this.notesApi})
      : super(const AppState.empty())
  //Event Handling logic
  {
    on<LoginAction>((event, emit) async {
      emit(
        const AppState(
          isLoading: true,
          loginError: null,
          loginHandle: null,
          fetchedNotes: null,
        ),
      );
      final loginHandle =
          await loginApi.login(email: event.email, password: event.password);

      emit(AppState(
        isLoading: false,
        loginError: loginHandle == const LoginHandle.foobar()
            ? null
            : LoginErrors.invalidHandle,
        loginHandle: loginHandle,
        fetchedNotes: null,
      ));
    });

    on<LoadNotesAction>(
      (event, emit) async {
        emit(
          AppState(
            isLoading: true,
            loginError: null,
            loginHandle: state.loginHandle,
            fetchedNotes: null,
          ),
        );

        if (state.loginHandle != const LoginHandle.foobar()) {
          emit(
            AppState(
              isLoading: false,
              loginError: LoginErrors.invalidHandle,
              loginHandle: state.loginHandle,
              fetchedNotes: null,
            ),
          );
          return;
        }
        final fetchedNotes =
            await notesApi.getNotes(loginHandle: state.loginHandle!);
        emit(
          AppState(
            isLoading: false,
            loginError: null,
            loginHandle: state.loginHandle,
            fetchedNotes: fetchedNotes,
          ),
        );
      },
    );
  }
}
