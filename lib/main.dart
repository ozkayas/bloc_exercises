// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'package:bloc_exercises/apis/notes_api.dart';
import 'package:bloc_exercises/bloc/actions.dart';
import 'package:bloc_exercises/bloc/app_bloc.dart';
import 'package:bloc_exercises/dialogs/generic_dialog.dart';
import 'package:bloc_exercises/dialogs/loading_screen.dart';
import 'package:bloc_exercises/models.dart';
import 'package:bloc_exercises/strings.dart';
import 'package:bloc_exercises/views/login_view.dart';
import 'package:bloc_exercises/dialogs/iterable_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'apis/login_api.dart';
import 'bloc/app_state.dart';

void main() {
  runApp(MaterialApp(
    // theme: ThemeData(),
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text(homePage)),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            // loading state
            if (state.isLoading) {
              LoadingScreen.instance().show(context: context, text: pleaseWait);
            } else {
              LoadingScreen.instance().hide();
            }
            //display possible errors
            final loginError = state.loginError;
            if (loginError != null) {
              showGenericDialog(
                  context: context,
                  title: loginErrorDialogTitle,
                  content: loginErrorDialogContent,
                  optionsBuilder: () => {ok: true});
            }

            // if we are logged in, but we have no fethced notes, fetch them now
            if (state.isLoading == false &&
                state.loginError == null &&
                state.loginHandle == const LoginHandle.foobar() &&
                state.fetchedNotes == null) {
              context.read<AppBloc>().add(const LoadNotesAction());
            }
          },
          builder: (context, state) {
            final notes = state.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: ((email, password) {
                  context
                      .read<AppBloc>()
                      .add(LoginAction(email: email, password: password));
                }),
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}

// class MM extends StatefulWidget {
//   const MM({ Key? key }) : super(key: key);

//   @override
//   State<MM> createState() => _MMState();
// }

// class _MMState extends State<MM> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
// }