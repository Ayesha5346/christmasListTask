import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techtiz/authentication/bloc/auth_bloc.dart';
import 'package:techtiz/authentication/bloc/auth_event.dart';
import 'package:techtiz/authentication/views/signup_view.dart';
import 'package:techtiz/widgets/message.dart';
import '../../home/views/home.dart';
import '../../widgets/form_field.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthStateErrorAppeared) {
            showMessage(context, state.error!);
          }
          else if(state is AuthStateAuthenticated){
            print('authenticated check');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Home()));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        CusFormField(emailController, 'Enter Email',
                            const Key('loginEmailField')),
                        CusFormField(passwordController, 'Enter Password',
                            const Key('loginPasswordField')),
                      ],
                    ),
                  ),
                ),
                TextButton(
                    key: const Key('LoginButton'),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(AuthLoginPressed(
                            email: emailController.text,
                            password: passwordController.text));
                      } else {
                        showMessage(context, 'Fill all fields');
                      }
                    },
                    child: (state is AuthStateLoading) ?
                    const CircularProgressIndicator(key: Key('loginProgressIndicator'),) :
                    const Text(
                      'Login',
                      style: TextStyle(fontSize: 15),
                    )),
                RichText(
                  key: const Key('noAccountTextWidget'),
                  text: TextSpan(children: [
                    const TextSpan(
                        text: 'Don\'t have an account?',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic)),
                    const TextSpan(text: '  '),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const SignupPage()));
                          },
                        semanticsLabel: 'signupLabel',
                        text: "Sign up",
                        style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic))
                  ]),
                )
              ],
            );

          },
        ),
      )),
    );
  }
}
