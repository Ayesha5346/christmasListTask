import"package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../bloc/list_bloc.dart";
import "home_view.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListBloc(),
      child: const HomePage(),
    );
  }
}