
import 'package:flutter/material.dart';
import 'package:simple_login/presentation/ui/login_Page.dart';
import 'package:simple_login/presentation/ui/register_Page.dart';


class LoginOrReg extends StatefulWidget {
  const LoginOrReg({super.key});

  @override
  State<LoginOrReg> createState() => _LoginOrRegState();
}

class _LoginOrRegState extends State<LoginOrReg> {

// initial show login page
  bool showLoginPage = true;


  // Toggle method
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
}

  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(onTap: togglePages,);
    } else{
      return RegisterPage(onTap: togglePages,);
    }
  }
}
