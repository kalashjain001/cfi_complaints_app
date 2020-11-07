import 'package:cfi_complaints_app/models/Complaint.dart';
import 'package:cfi_complaints_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

class DatabaseService {
  final String uid;

  DatabaseService(this.uid);

  // collection reference
  final CollectionReference allComplaints =
      Firestore.instance.collection('All Complaints');

  Future<void> enterUserData(
      String title, String description, List<String> images_url, int i) async {
    String j = i.toString();
    if (i < 10) {
      j = '0$i';
    }
    return await allComplaints
        .document(uid)
        .collection('My Complaints')
        .document('Complaint ' + j)
        .setData({
          'id': i,
          'title': title,
          'description': description,
          'images_url': images_url,
        })
        .then((value) => print("Complaint Added"))
        .catchError((error) => print("Failed to add complaint: $error"));
  }

  Future<void> deleteComplaint(Complaint complaint) async {
    String index = complaint.id.toString();
    if(complaint.id < 10){
      index = '0$index';
    }
    for(var j =0; j<complaint.images_url.length; j++){
      FirebaseStorage.instance
          .getReferenceFromUrl(complaint.images_url[j])
          .then((reference) => reference.delete())
          .catchError((e) => print(e));
    }
    return await allComplaints.document(uid).collection('My Complaints').document('Complaint $index').delete().then((value) => print('Complaint deleted'));
  }

  List<Complaint> _complaintListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Complaint(
        id: doc.data['id'],
        title: doc.data['title'],
        description: doc.data['description'],
        images_url: doc.data['images_url'],
      );
    }).toList();
  }

  // get myComplaints stream
  Stream<List<Complaint>> get myComplaints {
    return allComplaints
        .document(uid)
        .collection('My Complaints')
        .orderBy("id")
        .snapshots()
        .map(_complaintListFromSnapshot);
  }
}

