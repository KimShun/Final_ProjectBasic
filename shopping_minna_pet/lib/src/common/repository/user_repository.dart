import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class UserRepository {
  FirebaseFirestore db;
  UserRepository(this.db);

  Future<UserModel?> findUserOne(String uid) async {
    try {
      var doc = await db.collection("users").where("uid", isEqualTo: uid).get();
      if(doc.docs.isEmpty) {
        return null;
      } else {
        return UserModel.fromJson(doc.docs.first.data());
      }
    } catch(e) {
      return null;
    }
  }

  Future<UserModel?> findUserOneFromEmail(String email) async {
    try {
      var doc = await db.collection("users").where("email", isEqualTo: email).get();
      if(doc.docs.isEmpty) {
        return null;
      } else {
        return UserModel.fromJson(doc.docs.first.data());
      }
    } catch(e) {
      return null;
    }
  }

  Future<bool> joinUser(UserModel userModel) async {
    try {
      var doc = await db.collection("users").where("uid", isEqualTo: userModel.uid).get();
      if(doc.docs.isEmpty) {
        db.collection("users").add(userModel.toMap());
      } else {
        db.collection("users").doc(doc.docs.first.id).update(userModel.toMap());
      }
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<bool> updateEventSign(UserModel userModel, String uuid) async {
    print(userModel.uid!);
    try {
      var doc = await db.collection("users").where("uid", isEqualTo: userModel.uid).get();
      if (doc.docs.isEmpty) {
        return false;
      }

      UserModel loadUser = UserModel.fromJson(doc.docs.first.data());

      List<String> updatedEventSigns = List.from(loadUser.eventSigns ?? []);
      updatedEventSigns.add(uuid);

      UserModel mergeUser = loadUser.copyWith(eventSigns: updatedEventSigns);
      await db.collection("users").doc(doc.docs.first.id).update(mergeUser.toMap());

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}