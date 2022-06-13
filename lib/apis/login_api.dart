import 'package:bloc_exercises/models.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/gestures.dart';

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({
    required String email,
    required String password,
  });
}

@immutable
class LoginApi implements LoginApiProtocol {
  // //singleton
  // const LoginApi._sharedInstance();
  // static const LoginApi _shared = LoginApi._sharedInstance();
  // factory LoginApi.instance() => _shared;

  @override
  Future<LoginHandle?> login(
      {required String email, required String password}) async {
    var apiResult = await Future.delayed(
      const Duration(seconds: 2),
      () => (email == 'foo@bar.com' && password == 'foobar'),
    );

    return apiResult ? const LoginHandle.foobar() : null;

    // return Future.delayed(
    //   const Duration(seconds: 2),
    //   () => (email == 'foo@bar.com' && password == 'foobar'),
    // ).then((isLoggedIn) => isLoggedIn ? const LoginHandle.foobar(): null);
  } // login fonk burada bitiyor
}
