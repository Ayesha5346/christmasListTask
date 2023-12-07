import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techtiz/widgets/message.dart';
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
  TextEditingController nameController = TextEditingController(text: 'Abdullah');
  TextEditingController countryController = TextEditingController(text: 'Pakistan');
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
        body: Column(
          key: const Key('homeMainColumn'),
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(key: const Key('homeHeading'),'Kids Christmas List', style: headingStyle),
            Expanded(
                key: const Key('listLayoutExpandedWidget'),
                child: BlocBuilder<ListBloc, ListState>(
                  key:const Key('blocBuilderForChristmasList'),
              builder: (context, state) {
                if (state is ListStateLoading) {
                  return const Center(key:Key('LoadingTextCenter'),child: Text(key:Key('ListLoadingText'),'List is empty, add items',textDirection: TextDirection.ltr,));
                } else if (state is ListStateSuccess) {
                  return ListView.builder(
                    key: const Key('listViewBuilderKey'),
                      itemCount: state.kidsNameList.length,
                      itemBuilder: (context, index) {
                        if (state.kidsNameList.isEmpty) {
                          return const Center(
                              child: Text(
                                key:Key('ListEmptyText'),
                                'List is empty, add items',textDirection: TextDirection.ltr,));
                        } else {
                          return ListTile(
                            key: Key('ChristmasListBuilderTile$index'),
                            title: Text(
                              state.kidsNameList[index].name,
                              style: titleStyle,
                            ),
                            subtitle: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.kidsNameList[index].country,
                                  style: subtitleStyle,
                                ),
                                Text(state.kidsNameList[index].status)
                              ],
                            ),
                            trailing: GestureDetector(
                                onTap: () {
                                  updateStatus(
                                      context, state.kidsNameList[index], index);
                                },
                                child:  Icon(key:Key('statusButtonKey$index') ,Icons.edit)),
                          );
                        }
                      });
                } else if(state is ListStateFailure){
                  return  Center(key:const Key('FailureTextCenter'),child: Text(key: const Key('ListErrorText'), state.error,textDirection: TextDirection.ltr,));
                }else{
                  return const Center(key:Key('LoadingTextCenter'),child: Text(key:Key('ListLoadingText'),'List is empty, add items',textDirection: TextDirection.ltr,));
                }
              },
            ))
          ],
        ),
      ),
    );
  }

  void addItemInBlocList( BuildContext blocContext){
    ChristmasEntry object = ChristmasEntry(name: nameController.text, country: countryController.text, status: statusController.text);
    blocContext.read<ListBloc>().add(ListAddEvent(christmasListObject: object));
    nameController.clear();
    countryController.clear();
    statusController.clear();
    Navigator.pop(context);
    showMessage(context, 'Item Added');
  }

  void updateStatusInBlocList(BuildContext blocContext, ChristmasEntry christmasListObject , int index ){
    blocContext.read<ListBloc>().add(ListUpdateStatus(
        christmasListObject: christmasListObject ,
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
          return  FormDialog(
              const Text('Add New Kid'),
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CusFormField(nameController, 'Enter Name'),
                    CusFormField(countryController, 'Enter Country'),
                    CusFormField(statusController, 'Enter Status'),
                    TextButton(
                      key: const Key('addButtonKey') ,
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
              const Key('addDialogue')
          );
        });
  }

  Future<void> updateStatus(BuildContext blocContext, ChristmasEntry christmasListObject, int index) {
    statusController.text = christmasListObject.status;
    return showDialog(
        context: blocContext,
        builder: (context) {
          return FormDialog(const Text('Update Status'),
              Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CusFormField(statusController, 'Enter Status'),
                TextButton(
                  key: const Key('updateStatusButton'),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        updateStatusInBlocList(blocContext, christmasListObject, index);
                      } else {
                        showMessage(context, 'Fill All Fields');
                      }
                    },
                    child: const Text('Update'))
              ],
            ),
          ), const Key('updateStatusDialogue'));

        });
  }

}
