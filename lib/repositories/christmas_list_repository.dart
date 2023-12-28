import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:techtiz/home/models/list_model.dart';

import 'authentication_repo.dart';

class ChristmasListRepo {
  final dynamic db;
  final dynamic firebaseAuth;
  // FirebaseFirestore.instance;
  String? _uid;
  ChristmasListRepo({required this.db, required this.firebaseAuth});

  // Function to add a new kid to the user's document
  Future<void> addKidToUser(ChristmasEntry listObject) async {
    try {
      // Reference to the user's document in Firestore
      DocumentReference userDocRef = db.collection('kidsNameList').doc(_uid);
      // Get the current data of the user's document
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      Map<String, dynamic>? userData =
          userDocSnapshot.data() as Map<String, dynamic>?;
      // If the document exists, update the kidsList
      if (userData != null) {
        List kidsList = userData['kidsList'] ?? [];
        // Add a new kid to the list
        kidsList.add(listObject.toFirestore());
        // Update the kidsList in the user's data
        await userDocRef.update({
          'kidsList': kidsList,
        });
      } else {
        throw 'User document not found.';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> getUid() async {
    _uid = AuthenticationRepository(
            firebaseAuth: firebaseAuth, firebaseFirestore: db)
        .getUserId();
  }

  Future<void> addDataToFireStore(ChristmasEntry christmasListObject) async {
    getUid();
    try {
      // Reference to the user's document in Firestore
      DocumentReference userDocRef = db.collection('kidsNameList').doc(_uid);
      // Check if the document exists
      bool userDocExists = (await userDocRef.get()).exists;
      if (!userDocExists) {
        // If the document doesn't exist, create a new one
        await userDocRef.set({
          'uid': _uid,
          'kidsList': [
            christmasListObject.toFirestore()
          ], // Initialize an empty kidsList
        });
      } else {
        await addKidToUser(christmasListObject);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateStatusFirestoreList(int index, String status) async {
    try {
      // Reference to the user's document in Firestore
      DocumentReference userDocRef = db.collection('kidsNameList').doc(_uid);
      // Get the current data of the user's document
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      Map<String, dynamic>? userData =
          userDocSnapshot.data() as Map<String, dynamic>?;
      // If the document exists, update the kidsList
      if (userData != null) {
        List kidsList = userData['kidsList'] ?? [];
        ChristmasEntry tempObject =
            ChristmasEntry.fromFirestore(kidsList[index]);
        tempObject.updateStatus(status);
        kidsList[index] = tempObject.toFirestore();
        await userDocRef.update({
          'kidsList': kidsList,
        });
      } else {
        throw 'User document not found.';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future getDataFromFirestore() async {
    List<ChristmasEntry> tempList = [];
    ChristmasEntry temporaryObject;
    _uid == null ? await getUid() : null;
    try {
      DocumentReference userDocRef = db.collection('kidsNameList').doc(_uid);
      // Get the current data of the user's document
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      Map<String, dynamic>? userData =
          userDocSnapshot.data() as Map<String, dynamic>?;
      if (userData != null) {
        for (var object in userData['kidsList']) {
          temporaryObject = ChristmasEntry.fromFirestore(object);
          tempList.add(temporaryObject);
        }
        return tempList;
      } else {
        return <ChristmasEntry>[];
      }
    } catch (error) {
      throw error.toString();
    }
  }
}
