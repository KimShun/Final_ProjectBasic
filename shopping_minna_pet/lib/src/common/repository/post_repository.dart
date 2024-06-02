import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/post_model.dart';

class PostRepository {
  FirebaseFirestore db;
  DocumentSnapshot? lastDocument;

  PostRepository(this.db);

  Future<bool> createPost(PostModel postModel) async {
    try {
      var doc = await db.collection("posts").where("uuid", isEqualTo: postModel.uuid).get();
      if(doc.docs.isEmpty) {
        db.collection("posts").add(postModel.toJson());
      } else {
        db.collection("posts").doc(doc.docs.first.id).update(postModel.toJson());
      }
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<List<PostModel>?> loadPosts(int limit, bool isInit, String? uid) async {
    late Query query;

    if(isInit) {
      lastDocument = null;
    }

    try {
      if(uid == null) {
        query = db.collection("posts").orderBy("date", descending: true).limit(limit);
      } else {
        query = db.collection("posts").orderBy("date", descending: true).where("writerUid", isEqualTo: uid).limit(limit);
      }

      if(lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      QuerySnapshot querySnapshot = await query.get();

      if(querySnapshot.docs.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;
      } else {
        return null;
      }

      List<PostModel> posts = querySnapshot.docs.map((doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
      return posts;
    } catch(e) {
      return null;
    }
  }

  Future<PostModel?> loadOnePost(String uuid) async {
    try {
      var doc = await db.collection("posts").where("uuid", isEqualTo: uuid).get();
      if(doc.docs.isEmpty) {
        return null;
      } else {
        return PostModel.fromJson(doc.docs.first.data());
      }
    } catch(e) {
      return null;
    }
  }

  Future<bool> deletePosts(String uuid) async {
    try {
      var doc = await db.collection("posts").where("uuid", isEqualTo: uuid).get();
      if(doc.docs.isNotEmpty) {
        db.collection("posts").doc(doc.docs.first.id).delete();
        return true;
      } else { return false; }
    } catch(e) {
      return false;
    }
  }
}