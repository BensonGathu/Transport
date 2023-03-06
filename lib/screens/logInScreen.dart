import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:transportapp/responsive/mobile_screen_layout.dart';
import 'package:transportapp/ui/shared/api.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

final LocalAuthentication auth = LocalAuthentication();

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
  'test@gmail.com': '12345',
};

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => Duration(milliseconds: 2250);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //function that will handle google authentication
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<bool> _handleGoogleSignIn() async {
    bool isAuthenticated = false;
    print("starting google");
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    print("-------------------------Before");
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    print("-------------------------After");
    print(googleSignInAccount);

    if (googleSignInAccount != null) {
      try {
        // Get user
        print("FILTERING USER----");
        List filtered =
            await Api().filterUserByEmail(googleSignInAccount.email);
        print("FILTERD USERs----");
        print(filtered);

        if (filtered.isNotEmpty) {
          print("is not empty");
          // Set localStorage
          await setLocalStorage(filtered);
          // Set authenticated as true
          isAuthenticated = true;
        } else {
          // Register user
          var body = {
            "first_name": googleSignInAccount.displayName.toString(),
            "last_name": googleSignInAccount.displayName.toString(),
            "email": googleSignInAccount.email,
            // "nationalid": "0",
            "password": googleSignInAccount.email.toString(),
            "phone_number": googleSignInAccount.email.toString(),
          };
          print("body");
          print(body);

          await Api().registerUser(body).then((value) async {
            if (value.statusCode == 200) {
              // Get user
              List filtered =
                  await Api().filterUserByEmail(googleSignInAccount.email);
              // Set localStorage
              await setLocalStorage(filtered);
              // Set authenticated as true
              isAuthenticated = true;
            } else {
              // Signout user
              isAuthenticated = false;
              await _googleSignIn.signOut();
              throw 'An error occured';
            }
          });
        }
      } catch (error) {
        // Signout user
        await _googleSignIn.signOut();
        isAuthenticated = false;
        rethrow;
      }
    }
    return isAuthenticated;
  }

  Future<String> _handleUserLogin() async {
    bool isAuthenticated = false;
    var res = "";
    var body = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    await Api().loginUser(body).then((value) async {
      if (value.statusCode == 200) {
        // Get user
        List filtered = await Api().filterUserByEmail(_emailController.text);
        // Set localStorage
        await setLocalStorage(filtered);
        // Set authenticated as true
        isAuthenticated = true;
        res = "success";
      }
    });
    return res;
  }

  Future<void> setLocalStorage(List data) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    for (var v in data) {
      // Generate token
      // var token = await Api().getToken(v['id']);
      // Set Local storage
      prefs.setString('email', v['emailaddress']);
      prefs.setString('fullName', v['fullName']);
      // prefs.setString('token', token);
      prefs.setString('phone', v['phonenumber']);
      prefs.setString('id', v['id']);
      prefs.setString('userid', v['userid']);
      prefs.setString('nationalid', v['nationalid']);
    }
    return;
  }

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return "null";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, child) => ResponsiveWrapper.builder(child,
            maxWidth: 1200,
            minWidth: 480,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ],
            background: Container(color: Color(0xFFF5F5F5))),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.orange,
          buttonColor: Colors.orange,
          textTheme: const TextTheme(
            headline3: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 45.0,
              color: Colors.orange,
            ),
            button: TextStyle(
              fontFamily: 'OpenSans',
            ),
            subtitle1: TextStyle(fontFamily: 'NotoSans'),
            bodyText2: TextStyle(fontFamily: 'NotoSans'),
          ),
        ),
        home: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/trans.png'), fit: BoxFit.cover)),
          child: FlutterLogin(
            // title: 'Transport ',
            logo: const AssetImage('assets/trans.png'),

            onLogin: _authUser,
            onSignup: _signupUser,

            loginProviders: <LoginProvider>[
              LoginProvider(
                icon: FontAwesomeIcons.google,
                label: 'Google',
                callback: () async {
                  _handleGoogleSignIn();
                },
              ),
              LoginProvider(
                icon: FontAwesomeIcons.facebookF,
                label: 'Facebook',
                callback: () async {
                  debugPrint('start facebook sign in');
                  await Future.delayed(loginTime);
                  debugPrint('stop facebook sign in');
                  return null;
                },
              ),
            ],
            onSubmitAnimationCompleted: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(

                builder: (context) => const MobileScreenLayout(),

              ));
            },
            onRecoverPassword: _recoverPassword,
          ),
        ));
  }
}
