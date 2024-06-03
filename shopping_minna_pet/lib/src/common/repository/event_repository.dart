import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/event_model.dart';

class EventRepository {
  FirebaseFirestore db;
  DocumentSnapshot? lastDocument;

  EventRepository(this.db);

  Future<bool> createEvent(EventModel eventModel) async {
    try {
      var doc = await db.collection("events").where("uuid", isEqualTo: eventModel.uuid).get();
      if(doc.docs.isEmpty) {
        db.collection("events").add(eventModel.toJson());
      } else {
        EventModel loadEvent = EventModel.fromJson(doc.docs.first.data());

        List<Map<String, dynamic>> updatedEventSigns = List.from(loadEvent.userEventSign ?? []);
        updatedEventSigns.add(eventModel.userEventSign![0]);

        EventModel mergeEvent = loadEvent.copyWith(userEventSign: updatedEventSigns);
        await db.collection("events").doc(doc.docs.first.id).update(mergeEvent.toJson());
      }
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<List<String>?> loadEventsBannerList() async {
    try {
      QuerySnapshot querySnapshot = await db.collection("events").orderBy("date", descending: true).get();

      if(querySnapshot.docs.isEmpty) {
        return null;
      }

      List<EventModel> events = querySnapshot.docs.map((doc) => EventModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

      List<String> bannerList = [];
      for(int i=0; i<events.length; i++) {
        if(events[i].eventProgress != "ended") {
          bannerList.add(events[i].eventImage!);
        }
      }

      return bannerList;
    } catch(e) {
      print(e);
      return null;
    }
  }

  Future<List<EventModel>?> loadEvents(int limit, bool isInit) async {
    if(isInit) {
      lastDocument = null;
    }

    try {
      Query query = db.collection("events").orderBy("date", descending: true).limit(limit);

      if(lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      QuerySnapshot querySnapshot = await query.get();

      if(querySnapshot.docs.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;
      } else {
        return null;
      }

      List<EventModel> events = querySnapshot.docs.map((doc) => EventModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
      return events;
    } catch(e) {
      return null;
    }
  }

  Future<EventModel?> loadOneEvent(String uuid) async {
    try {
      var doc = await db.collection("events").where("uuid", isEqualTo: uuid).get();
      if(doc.docs.isEmpty) {
        return null;
      } else {
        return EventModel.fromJson(doc.docs.first.data());
      }
    } catch(e) {
      return null;
    }
  }
}