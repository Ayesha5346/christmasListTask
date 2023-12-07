import 'package:flutter/material.dart';

import '../../widgets/form_field.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: formKey,
                child:  Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      CusFormField(nameController,'Enter Name'),
                      CusFormField(emailController,'Enter Email'),
                      CusFormField(passwordController,'Enter Password'),
                      CusFormField(confirmPasswordController,'Confirm Password')
                    ],
                  ),
                ),
              ),
              TextButton(onPressed: (){}, child: Text('SignUp'))
            ],
          ),
        )
    );
  }
}
