import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techtiz/authentication/bloc/auth_bloc.dart';
import 'package:techtiz/authentication/bloc/auth_event.dart';
import 'package:techtiz/authentication/bloc/auth_state.dart';
import 'package:techtiz/home/views/home.dart';
import 'package:techtiz/widgets/message.dart';

import '../../widgets/form_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthStateErrorAppeared) {
            showMessage(context, state.error!);
          }else if(state is AuthStateAuthenticated){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Home()));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Column(
              key: const Key('signupMainColumn'),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        CusFormField(nameController, 'Enter Name',
                            const Key('nameSignupField')),
                        CusFormField(emailController, 'Enter Email',
                            const Key('emailSignupField')),
                        CusFormField(passwordController, 'Enter Password',
                            const Key('passwordSignupField')),
                        CusFormField(
                            confirmPasswordController,
                            'Confirm Password',
                            const Key('confirmPasswordField'))
                      ],
                    ),
                  ),
                ),
                TextButton(
                    key: const Key('signupButtonKey'),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(AuthSignupPressed(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text));
                      } else {
                        showMessage(context, 'Fill all fields');
                      }
                    },
                    child:(state is AuthStateLoading)?
                    const Center(child: CircularProgressIndicator()):
                    const Text('SignUp')),

              ],
            );
          },
        ),
      ),
    ));
  }
}
