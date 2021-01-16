import 'package:firebase_auth/firebase_auth.dart';
import 'package:firepost/pages/home_page.dart';
import 'package:firepost/pages/signup_page.dart';
import 'package:firepost/services/auth_service.dart';
import 'package:firepost/services/prefs_service.dart';
import 'package:firepost/services/utild_service.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {

  static final String id = 'signin_page';

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  bool isLoading = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignIn() {
    var email = emailController.text.toString().trim();
    var password = passwordController.text.toString().trim();

    if(email.isEmpty || password.isEmpty) return;
    setState(() {
      isLoading = true;
    });

    AuthService.signInUser(context, email, password).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser)
    });
  }

  _getFirebaseUser(FirebaseUser firebaseUser) async {
    setState(() {
      isLoading = false;
    });

    if(firebaseUser != null) {
      await Pref.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Utils.fireToast('Check your email or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'password',
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                    onPressed: _doSignIn,
                    child: Text('Sign In'),
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Don't have an account?"),
                        SizedBox(width: 10,),
                        Text('Sing Up', style: TextStyle(color: Colors.black),)
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, SignUpPage.id);
                    },
                  ),
                )
              ],
            ),
          ),
          isLoading ? Center(
            child: CircularProgressIndicator(),
          ) : SizedBox.shrink(),
        ],
      ),
    );
  }
}
