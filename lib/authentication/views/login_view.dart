import 'package:flutter/material.dart';

import '../../widgets/form_field.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: formKey,
            child:  Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  CusFormField(emailController,'Enter Email'),
                  CusFormField(passwordController,'Enter Password'),
                ],
              ),
            ),
          ),
          TextButton(onPressed: (){}, child: const Text('Login')),

        ],
      )
    ));
  }
}
