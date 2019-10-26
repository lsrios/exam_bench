import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:exam_bench/constants.dart';
import 'package:exam_bench/widgets/logotype.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:exam_bench/screens/principal_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static String get screenId => 'loginScreenId';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// TODO: Colocar o spinner para indicar carregamento
// TODO: Refatorar a troca de tela quando o usuario esta logado
// TODO: Refatorar os metodos dos botoes de login
class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _email;
  String _password;

  Future<FirebaseUser> _handleEmailAndPasswordSignIn() async {
    final AuthResult authResult =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: _email,
      password: _password,
    );

    return authResult.user;
  }

  Future<FirebaseUser> _handleGoogleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(authCredential);

    return authResult.user;
  }

  Future<FirebaseUser> _handleFacebookSignIn() async {
    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(['email']);
    AuthResult authResult;

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.loggedIn:
        final String token = facebookLoginResult.accessToken.token;
        final AuthCredential authCredential =
            FacebookAuthProvider.getCredential(accessToken: token);
        authResult = await _firebaseAuth.signInWithCredential(authCredential);
        break;
      case FacebookLoginStatus.cancelledByUser:
        authResult = null;
        break;
      case FacebookLoginStatus.error:
        authResult = null;
        break;
    }

    return authResult.user;
  }

  Future<FirebaseUser> _handleTwitterSignIn() async {
    final TwitterLogin twitterLogin = TwitterLogin(
      consumerKey: 'iUsXC3Jy1t9lZ69IiZXiYUFFz',
      consumerSecret: 'kcKGyjrqvLPDG3HDHiKosVc9k9wb6nmvH2lJM0vBmBuyb3XjFy',
    );
    TwitterLoginResult twitterLoginResult = await twitterLogin.authorize();
    AuthResult authResult;

    switch (twitterLoginResult.status) {
      case TwitterLoginStatus.loggedIn:
        final TwitterSession twitterSession = twitterLoginResult.session;
        final AuthCredential authCredential = TwitterAuthProvider.getCredential(
          authToken: twitterSession.token,
          authTokenSecret: twitterSession.secret,
        );
        authResult = await _firebaseAuth.signInWithCredential(authCredential);
        break;
      case TwitterLoginStatus.cancelledByUser:
        authResult = null;
        break;
      case TwitterLoginStatus.error:
        authResult = null;
        break;
    }

    return authResult.user;
  }

  @override
  void initState() {
    super.initState();
    _firebaseAuth.currentUser().then((user) {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PrincipalScreen(),
          ),
        );
      }
    });
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
                    'Sign in',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    //TODO: Implementar tratamento de excessao sign in
                    _handleEmailAndPasswordSignIn().then((user) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrincipalScreen(),
                        ),
                      );
                    }).catchError((e) => print(e));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Material(
                  elevation: 10.0,
                  color: Colors.deepPurple[400],
                  borderRadius: BorderRadius.circular(50.0),
                  child: MaterialButton(
                    child: Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      //TODO: Implementar função onPressed botão sign up
                      FirebaseUser user = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationScreen(),
                        ),
                      );
                      if (user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrincipalScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              GestureDetector(
                child: Text('Forgot password ?'),
                onTap: () {
                  //TODO: Implementar função onPressed botão forgot password
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.facebook,
                          size: 45.0,
                        ),
                        onPressed: () {
                          //TODO: Implementar tratamento de excessao facebook
                          _handleFacebookSignIn().then((user) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrincipalScreen()),
                            );
                          }).catchError((e) => print(e));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.google,
                          size: 45.0,
                        ),
                        onPressed: () async {
                          //TODO: Implementar tratamento de excessao google
                          _handleGoogleSignIn().then((user) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrincipalScreen()),
                            );
                          }).catchError((e) => print(e));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.twitter,
                          size: 45.0,
                        ),
                        onPressed: () {
                          //TODO: Implementar tratamento de excessao Twitter
                          _handleTwitterSignIn().then((user) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrincipalScreen()),
                            );
                          }).catchError((e) => print(e));
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
