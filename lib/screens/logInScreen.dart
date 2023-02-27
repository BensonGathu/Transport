import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportapp/screens/homepage.dart';
import 'package:transportapp/screens/signUpScreen.dart';
import 'package:transportapp/utils/colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:responsive_framework/responsive_framework.dart';

const users = const {
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
      builder: (context, child) => ResponsiveWrapper.builder(
          child,
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
                  debugPrint('start google sign in');
                  await Future.delayed(loginTime);
                  debugPrint('stop google sign in');
                  return null;
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
                builder: (context) => HomePage(),
              ));
            },
            onRecoverPassword: _recoverPassword,
          ),
        ));
  }
}
