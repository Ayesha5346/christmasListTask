import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techtiz/authentication/bloc/auth_bloc.dart';
import 'package:techtiz/authentication/bloc/auth_state.dart';
import 'package:techtiz/authentication/views/login_view.dart';
import 'package:techtiz/widgets/message.dart';
import '../../authentication/bloc/auth_event.dart';
import '../../utils/styles.dart';
import '../../widgets/form_dialog.dart';
import '../../widgets/form_field.dart';
import '../bloc/event.dart';
import '../bloc/list_bloc.dart';
import '../bloc/state.dart';
import '../models/list_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController =
      TextEditingController(text: 'Abdullah');
  TextEditingController countryController =
      TextEditingController(text: 'Pakistan');
  TextEditingController statusController = TextEditingController(text: 'nice');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: const Key('homeScaffold'),
        floatingActionButton: FloatingActionButton(
          key: const Key('floatingButtonKey'),
          onPressed: () {
            addItem(context);
          },
          child: const Icon(Icons.add),
        ),
        body: Stack(
          key: const Key('HomeParentStack'),
          children: [
            BlocListener<AuthBloc, AuthState>(listener: (context, state) {
              if (state is AuthStateErrorAppeared) {
                showMessage(context, state.error!);
              } else if (state is AuthStateUnAuthenticated) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
              } else if (state is AuthStateLoading) {
                showMessage(context, 'logout in process');
              }
            }, child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    key: const Key('LogoutButton'),
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                    },
                    icon: const Icon(Icons.logout),
                  ),
                );
              },
            )),
            Column(
              key: const Key('homeMainColumn'),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    key: const Key('homeHeading'),
                    'Kids Christmas List',
                    style: headingStyle),
                Expanded(
                    key: const Key('listLayoutExpandedWidget'),
                    child: BlocBuilder<ListBloc, ListState>(
                      key: const Key('blocBuilderForChristmasList'),
                      builder: (context, state) {
                        if (state is ListStateInitial) {
                          return const Center(
                            child: Text(key: Key('initialTextKey'),'list empty , add items'),
                          );
                        } else if (state is ListStateSuccess) {
                          return ListView.builder(
                              key: const Key('listViewBuilderKey'),
                              itemCount: state.kidsNameList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                    // $index
                                  key: Key('ChristmasListBuilderTile'),
                                  title: Text(
                                    state.kidsNameList[index].name,
                                    style: titleStyle,
                                  ),
                                  subtitle: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.kidsNameList[index].country,
                                        style: subtitleStyle,
                                      ),
                                      Text(key: Key('statusTextKey$index'),state.kidsNameList[index].status)
                                    ],
                                  ),
                                  trailing: GestureDetector(
                                      onTap: () {
                                        updateStatus(context,
                                            state.kidsNameList[index], index);
                                      },
                                      child: Icon(
                                          key: Key('statusButtonKey$index'),
                                          Icons.edit)),
                                );
                                // }
                              });
                        } else if (state is ListStateFailure) {
                          return Center(
                              key: const Key('FailureTextCenter'),
                              child: Text(
                                key: const Key('ListErrorText'),
                                state.error,
                                textDirection: TextDirection.ltr,
                              ));
                        } else if(state is ListStateLoading){
                          print('loading Ui check');
                          return const Center(
                            child: CircularProgressIndicator(key: Key('loader'),),
                          );
                        }else{
                          return SizedBox();
                        }
                      },
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    context.read<ListBloc>().add(ListInitialChecked());
    super.initState();
  }

  void addItemInBlocList(BuildContext blocContext) {
    ChristmasEntry object = ChristmasEntry(
        name: nameController.text,
        country: countryController.text,
        status: statusController.text);
    blocContext
        .read<ListBloc>()
        .add(ListItemAdded(christmasListObject: object));
    nameController.clear();
    countryController.clear();
    statusController.clear();
    Navigator.pop(context);
    showMessage(context, 'Item Added');
  }

  void updateStatusInBlocList(
      BuildContext blocContext, ChristmasEntry christmasListObject, int index) {
    blocContext.read<ListBloc>().add(ListItemStatusUpdated(
        christmasListObject: christmasListObject,
        currentIndex: index,
        status: statusController.text));
    statusController.clear();
    Navigator.pop(context);
    showMessage(context, 'Status updated');
  }

  Future<void> addItem(BuildContext blocContext) async {
    return showDialog(
        context: blocContext,
        builder: (context) {
          return FormDialog(
              const Text('Add New Kid'),
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CusFormField(
                      nameController,
                      'Enter Name',
                      const Key('nameFormFiled'),
                    ),
                    CusFormField(countryController, 'Enter Country',
                        const Key('countryFormField')),
                    CusFormField(statusController, 'Enter Status',
                        const Key('statusFormField')),
                    TextButton(
                        key: const Key('addButtonKey'),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            addItemInBlocList(blocContext);
                          } else {
                            showMessage(context, 'Fill All Fields');
                          }
                        },
                        child: const Text('Add'))
                  ],
                ),
              ),
              const Key('addDialogue'));
        });
  }

  Future<void> updateStatus(
      BuildContext blocContext, ChristmasEntry christmasListObject, int index) {
    statusController.text = christmasListObject.status;
    return showDialog(
        context: blocContext,
        builder: (context) {
          return FormDialog(
              const Text('Update Status'),
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CusFormField(statusController, 'Enter Status',
                        const Key('statusUpdateFiled')),
                    TextButton(
                        key: const Key('updateStatusButton'),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            updateStatusInBlocList(
                                blocContext, christmasListObject, index);
                          } else {
                            showMessage(context, 'Fill All Fields');
                          }
                        },
                        child: const Text('Update'))
                  ],
                ),
              ),
              const Key('updateStatusDialogue'));
        });
  }
}
