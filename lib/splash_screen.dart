import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:techtiz/authentication/views/login_view.dart';
import 'package:techtiz/repositories/authentication_repo.dart';
import 'home/views/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Container(
        color: Colors.teal,
      ),
    ));
  }
  @override
  void initState() {
    // TODO: implement initState
    startupCeck();
    super.initState();
  }
  void startupCeck(){
    var user = AuthenticationRepository(firebaseAuth: FirebaseAuth.instance, firebaseFirestore: FirebaseFirestore.instance).getUser();
    Timer(const Duration(seconds: 3),(){
      user?.uid !=null ?
      Navigator.of(context,).pushReplacement(MaterialPageRoute(builder: (context)=>const Home()))
          : Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const LoginPage())) ;
    });

  }
}
