import 'package:firebase_auth/firebase_auth.dart';
import 'package:firepost/pages/home_page.dart';
import 'package:firepost/pages/signin_page.dart';
import 'package:firepost/services/auth_service.dart';
import 'package:firepost/services/prefs_service.dart';
import 'package:firepost/services/utild_service.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {

  static final String id = 'signup_page';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  var isLoading = false;

  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();

  _doSignUp() {
    String name = nameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();

    if(name.isEmpty || email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    AuthService.signUpUser(context, name, email, password).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser)
    });
  }

  _getFirebaseUser(FirebaseUser firebaseUser) async{
    setState(() async {
      isLoading = false;
      if(firebaseUser != null) {
        await Pref.saveUserId(firebaseUser.uid);
        Navigator.pushReplacementNamed(context, HomePage.id);
      } else {
        Utils.fireToast('Check your information');
      }
    });
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
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Fullname',
                  ),
                ),
                SizedBox(height: 10,),
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
                    onPressed: _doSignUp,
                    child: Text('Sign Up'),
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
                        Text('Already you have account?'),
                        SizedBox(width: 10,),
                        Text('Sing In', style: TextStyle(color: Colors.black),)
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, SignInPage.id);
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
