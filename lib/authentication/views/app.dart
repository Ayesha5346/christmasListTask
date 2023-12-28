import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techtiz/authentication/bloc/auth_bloc.dart';
import 'package:techtiz/home/bloc/list_bloc.dart';
import 'package:techtiz/repositories/authentication_repo.dart';
import 'package:techtiz/repositories/christmas_list_repository.dart';
import '../../splash_screen.dart';



class MyApp extends StatelessWidget {
  final FirebaseAuth authObject = FirebaseAuth.instance;
   final  firestoreObject = FirebaseFirestore.instance;
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>AuthBloc(
            AuthenticationRepository(firebaseAuth: authObject, firebaseFirestore: firestoreObject),),),
       BlocProvider(create: (context)=>ListBloc([],ChristmasListRepo(db: firestoreObject, firebaseAuth: authObject))),
      ],
      child: const MaterialApp(
        // home: Home(),
        home: SplashScreen(),
      ),
    );
  }
}