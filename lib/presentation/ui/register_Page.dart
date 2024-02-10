import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_login/presentation/components/button.dart';
import 'package:simple_login/presentation/components/square_title.dart';
import 'package:simple_login/presentation/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  //
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userNameController = TextEditingController();
  final emailTextController = TextEditingController();
  final passTextController = TextEditingController();
  final confirmPassTextController = TextEditingController();

  void signUp() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    // Password match
    if (passTextController.text != confirmPassTextController.text) {
      Navigator.pop(context);

      showErrorMessage("Password don't match");
    } else {
      // password mot match
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailTextController.text,
                password: passTextController.text);

        // crate user document
        createUserDocument(userCredential);

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        showErrorMessage(e.code);
      }
    }
  }

  // Display the error message
  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
                child: Text(
              message,
              style: TextStyle(color: Colors.white),
            )),
          );
        });
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': userNameController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //   logo
                Icon(
                  Icons.lock,
                  size: 130,
                ),

                SizedBox(height: 20),

                MyTextField(
                    controller: userNameController,
                    hintText: "UserName",
                    obscureText: false),

                SizedBox(
                  height: 10,
                ),

                //  email
                MyTextField(
                    controller: emailTextController,
                    hintText: "E-mail",
                    obscureText: false),

                SizedBox(
                  height: 10,
                ),

                //   password
                MyTextField(
                    controller: passTextController,
                    hintText: "Password",
                    obscureText: true),
                SizedBox(
                  height: 10,
                ),

                MyTextField(
                    controller: confirmPassTextController,
                    hintText: "Confirm Password",
                    obscureText: true),

                SizedBox(
                  height: 25,
                ),

                //   sign in button
                MyButton(onTap: signUp, text: 'Sign UP'),

                SizedBox(
                  height: 50,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // google button
                    SquareTitle(imagepath: 'images/Google-1.png')
                  ],
                ),

                const SizedBox(height: 50),

                //   Not an member
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an Account?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey[700]),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Login Now',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
