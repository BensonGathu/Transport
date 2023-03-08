import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:transportapp/responsive/mobile_screen_layout.dart';
import 'package:transportapp/screens/signUpScreen.dart';
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
  Duration get loginTime => const Duration(milliseconds: 2250);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //function that will handle google authentication

  late bool showHome = false;
  late bool isValidUser = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<bool> _handleGoogleSignIn() async {
    print("isAuthenticated False");
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
          print("isAuthenticated True");
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

           Api().registerUser(body).then((value) async {
            print(value.body);
            print(value);
            if (value.statusCode == 200) {
              // Get user
              List filtered =
                  await Api().filterUserByEmail(googleSignInAccount.email);
              // Set localStorage
              await setLocalStorage(filtered);
              // Set authenticated as true
              isAuthenticated = true;
              print("isAuthenticated True");
            } else {
              // Signout user
              isAuthenticated = false;
              print("isAuthenticated False");

              await _googleSignIn.signOut();
              throw 'An error occured';
            }
          });
        }
      } catch (error) {
        // Signout user
        await _googleSignIn.signOut();
        isAuthenticated = false;
        print("isAuthenticated False");

        rethrow;
      }
    }
    print("returned isAuthenticared");
    return isAuthenticated;
  }








  myHome() async {
    final prefs = await SharedPreferences.getInstance();
    showHome = prefs.getBool('showHome') ?? false;
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

  Future hasAccount() async {
    final prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var userId = prefs.getString('userid');

    if (email != null && userId != null) {
      isValidUser = true;
    }
  }

  Future<void> setLocalStorage(List data) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    for (var v in data) {
      // Generate token
      var token = await Api().getUserToken(v['_id']);
      // Set Local storage
      prefs.setString('email', v['email']);
      prefs.setString('first_name', v['first_name']);
      prefs.setString('last_name', v['last_name']);
      prefs.setString('token', token);
      prefs.setString('phone_number', v['phone_number']);
      prefs.setString('_id', v['_id']);
      prefs.setString('userid', v['userID']);
      //prefs.setString('nationalid', v['nationalid']);
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
  void initState() {
    // TODO: implement initState
    hasAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, child) => ResponsiveWrapper.builder(child,
            maxWidth: 1200,
            minWidth: 480,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(480, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(800, name: TABLET),
              const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ],
            background: Container(color: const Color(0xFFF5F5F5))),
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
                image: AssetImage('assets/login.png'), fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Container(),
                Container(
                  padding: const EdgeInsets.only(left: 35, top: 130),
                  child: const Text(
                    'Welcome\nBack',
                    style: TextStyle(color: Colors.white, fontSize: 33),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 35, right: 35),
                          child: Column(
                            children: [
                              TextField(
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextField(
                                style: const TextStyle(),
                                obscureText: true,
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              MaterialButton(
                                elevation: 0,
                                //color: Color.fromARGB(255, 235, 232, 229),
                                height: 50,
                                minWidth: 200,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                onPressed: ()  {
                                  print("Before vvvvvvvvvvvv");
                                  _handleGoogleSignIn().then((v) {
                                    print(
                                        "VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV");
                                    print(v);
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) =>
                                          const MobileScreenLayout(),
                                    ));
                                  }).catchError((error) {
                                    // error is SecondError
                                    print("OUR ERROR: $error");
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Image(
                                      image:
                                          AssetImage("assets/icons/google.png"),
                                      height: 35.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Sign in with Google',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // const Text(
                                  //   'Sign in',
                                  //   style: TextStyle(
                                  //       fontSize: 27,
                                  //       fontWeight: FontWeight.w700),
                                  // ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: const Color(0xff4c505b),
                                    child: IconButton(
                                        color: Colors.white,
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.arrow_forward,
                                        )),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) =>
                                            const signUpScreen(),
                                      ));
                                    },
                                    style: const ButtonStyle(),
                                    child: const Text(
                                      'Sign Up',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff4c505b),
                                          fontSize: 18),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        'Forgot Password',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff4c505b),
                                          fontSize: 18,
                                        ),
                                      )),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ),
        )

        // Container(
        //   decoration: const BoxDecoration(
        //       image: DecorationImage(
        //           image: AssetImage('assets/trans.png'), fit: BoxFit.cover)),
        //   child:
        //   FlutterLogin(
        //     additionalSignupFields: const <UserFormField>[],
        //     // title: 'Transport ',
        //     logo: const AssetImage('assets/trans.png'),

        //     onLogin: _authUser,
        //     onSignup: _signupUser,

        //     loginProviders: <LoginProvider>[
        //       LoginProvider(
        //           icon: FontAwesomeIcons.google,
        //           label: 'Google',
        //           callback: () async {
        //             bool isAuthenticated = await _handleGoogleSignIn();
        //             if (isAuthenticated) {
        //               return null;
        //             }
        //             return null;

        //           }),
        //       LoginProvider(
        //         icon: FontAwesomeIcons.facebookF,
        //         label: 'Facebook',
        //         callback: () async {
        //           debugPrint('start facebook sign in');
        //           await Future.delayed(loginTime);
        //           debugPrint('stop facebook sign in');
        //           return null;
        //         },
        //       ),
        //     ],
        //     onSubmitAnimationCompleted: () {
        //       Navigator.of(context).pushReplacement(MaterialPageRoute(
        //         builder: (context) => const MobileScreenLayout(),
        //       ));
        //     },
        //     onRecoverPassword: _recoverPassword,
        //   ),
        // )
        );
  }
}
