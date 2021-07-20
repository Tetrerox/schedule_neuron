import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schedule_neuron/screen/home/calendar/calendar_event.dart';
import 'package:schedule_neuron/screen/home/calendar/firebase_list.dart';
import 'package:schedule_neuron/screen/home/deadlines/deadlines_event.dart';
import 'package:schedule_neuron/screen/home/deadlines/firebase_list_deadlines.dart';
import 'package:schedule_neuron/screen/home/sticky_notes/single_sticky_note.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  // events collection reference
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  // user events stream
  Stream<DocumentSnapshot> get userEvents {
    return eventCollection.doc(uid).snapshots();
  }

  // deadlines collection reference
  final CollectionReference deadlineCollection =
      FirebaseFirestore.instance.collection('deadlines');

  // user deadlines stream
  Stream<DocumentSnapshot> get userDeadlines {
    return deadlineCollection.doc(uid).snapshots();
  }

  // sticky notes collection reference
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  // user sticky notes stream
  Stream<DocumentSnapshot> get userNotes {
    return notesCollection.doc(uid).snapshots();
  }

  // update user events
  Future updateUserEvents(DateTime selectedDay, CalendarEvent event,
      DocumentSnapshot? snapshot) async {
    String string = dateFormat.format(selectedDay);
    try {
      if (snapshot != null && snapshot.exists) {
        FirebaseList firebaseList = FirebaseList.fromList(snapshot.get(string));
        firebaseList.eventsList.add(event);
        return await eventCollection
            .doc(uid)
            .update({string: firebaseList.toFirestoreList()});
      }
    } catch (e) {
      return await eventCollection.doc(uid).update({
        string: [event.toMap()]
      });
    }
    return await eventCollection.doc(uid).set({
      string: [event.toMap()]
    });
  }

  // delete user events
  Future deleteUserEvents(DateTime selectedDay, CalendarEvent event,
      DocumentSnapshot? snapshot) async {
    String string = dateFormat.format(selectedDay);
    FirebaseList firebaseList = FirebaseList.fromList(snapshot!.get(string));
    firebaseList.eventsList.remove(event);
    if (firebaseList.eventsList.length > 0) {
      return await eventCollection
          .doc(uid)
          .set({string: firebaseList.toFirestoreList()});
    } else {
      return await eventCollection.doc(uid).update({string: []});
    }
  }

  // delete all user events on a specific day
  Future deleteAllUserEventsOnDay(DateTime selectedDay) async {
    String string = dateFormat.format(selectedDay);
    return await eventCollection.doc(uid).update({string: []});
  }

  // edits a calendar event
  Future editUserEvent(DateTime selectedDay, CalendarEvent? oldEvent,
      CalendarEvent newEvent) async {
    String string = dateFormat.format(selectedDay);
    DocumentSnapshot snapshot = await eventCollection.doc(uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    FirebaseList firebaseList = FirebaseList.fromList(data[string]);
    firebaseList.eventsList.remove(oldEvent);
    firebaseList.eventsList.add(newEvent);
    return await eventCollection
        .doc(uid)
        .update({string: firebaseList.toFirestoreList()});
  }

  // update user deadlines
  Future updateUserDeadlines(
      DeadlinesEvent deadlinesEvent, DocumentSnapshot? snapshot) async {
    try {
      if (snapshot != null && snapshot.exists) {
        FirebaseListDeadlines firebaseListDeadlines =
            FirebaseListDeadlines.fromList(snapshot.get('deadlines'));
        firebaseListDeadlines.deadlinesList.add(deadlinesEvent);
        return await deadlineCollection
            .doc(uid)
            .update({'deadlines': firebaseListDeadlines.toFirestoreList()});
      }
    } catch (e) {}
    return await deadlineCollection.doc(uid).set({
      'deadlines': [deadlinesEvent.toMap()]
    });
  }

  // delete user deadlines
  Future deleteUserDeadlines(
      DeadlinesEvent deadlinesEvent, DocumentSnapshot? snapshot) async {
    FirebaseListDeadlines firebaseListDeadlines =
        FirebaseListDeadlines.fromList(snapshot!.get('deadlines'));
    firebaseListDeadlines.deadlinesList.remove(deadlinesEvent);
    if (firebaseListDeadlines.deadlinesList.length > 0) {
      return await deadlineCollection
          .doc(uid)
          .set({'deadlines': firebaseListDeadlines.toFirestoreList()});
    } else {
      return await deadlineCollection.doc(uid).update({'deadlines': []});
    }
  }

  // delete all user events on a specific day
  Future deleteAllUserDeadlines() async {
    return await deadlineCollection.doc(uid).set({'deadlines': []});
  }

  // edits a deadline event
  Future editUserDeadline(
      DeadlinesEvent? oldEvent, DeadlinesEvent newEvent) async {
    DocumentSnapshot snapshot = await deadlineCollection.doc(uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    FirebaseListDeadlines firebaseListDeadlines =
        FirebaseListDeadlines.fromList(data['deadlines']);
    firebaseListDeadlines.deadlinesList.remove(oldEvent);
    firebaseListDeadlines.deadlinesList.add(newEvent);
    return await deadlineCollection
        .doc(uid)
        .update({'deadlines': firebaseListDeadlines.toFirestoreList()});
  }

  // update user notes
  Future updateUserNotes(
      SingleStickyNote stickyNote, DocumentSnapshot? snapshot) async {
    try {
      if (snapshot != null && snapshot.exists) {
        List<dynamic> firestoreList = snapshot.get('notes');
        firestoreList.add(stickyNote.toMap());
        return await notesCollection.doc(uid).update({'notes': firestoreList});
      }
    } catch (e) {}
    return await notesCollection.doc(uid).set({
      'notes': [stickyNote.toMap()]
    });
  }

  // delete user notes
  Future deleteUserNotes(
      SingleStickyNote stickyNote) async {
    DocumentSnapshot snapshot = await notesCollection.doc(uid).get();
    List<dynamic> firestoreList = snapshot.get('notes');
    List<SingleStickyNote> stickyNotes = [];
    for (Map<String, dynamic> element in firestoreList) {
      stickyNotes.add(SingleStickyNote(
          text: element['text'], category: element['category']));
    }
    stickyNotes.remove(stickyNote);
    firestoreList = stickyNotes.map((note) => note.toMap()).toList();
    if (firestoreList.length > 0) {
      return await notesCollection.doc(uid).update({'notes': firestoreList});
    } else {
      return await notesCollection.doc(uid).set({'notes': []});
    }
  }

  // delete all user notes
  Future deleteAllUserNotes() async {
    return await notesCollection.doc(uid).set({'notes': []});
  }
}
