import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:exam_bench/constants.dart';
import 'package:exam_bench/widgets/logotype.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

// TODO: Colocar o spinner para indicar carregamento
class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _email;
  String _password;

  Future<FirebaseUser> _handleUserRegistration() async {
    // TODO: Implementar o validador de usuario
    final AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: _email, password: _password);

    return authResult.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: kBackgroundGradient,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Logotype(),
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => _email = value,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) => _password = value,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Password'),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: MaterialButton(
                  color: Colors.blueGrey[800],
                  elevation: 10.0,
                  minWidth: 200.0,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _handleUserRegistration().then((user) {
                      Navigator.pop(context, user);
                    }).catchError((e) => print(e));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
