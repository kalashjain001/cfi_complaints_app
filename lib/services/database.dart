import 'package:cfi_complaints_app/models/Complaint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  int i=0;

  DatabaseService(this.uid);

  // collection reference
  final CollectionReference allComplaints = Firestore.instance.collection('All Complaints');

  Future<void> enterUserData(String title, String description, List<String> images_url,int i) async {

    return await allComplaints.document(uid).collection('My Complaints').document('Complaint $i').setData({
      'title': title,
      'description': description,
      'images_url': images_url,
    }).then((value) => print("Complaint Added"))
        .catchError((error) => print("Failed to add complaint: $error"));
  }

  List<Complaint> _complaintListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return Complaint(
          title: doc.data['title'],
          description: doc.data['description'],
          images_url: doc.data['images_url'],
      );
    }).toList();
  }
/*
  Stream<QuerySnapshot> get myComplaints {
    return allComplaints.document(uid).collection('My Complaints').snapshots();

  }
*/
  // get brews stream
  Stream<List<Complaint>> get myComplaints {
    return allComplaints.document(uid).collection('My Complaints').snapshots()
        .map(_complaintListFromSnapshot);
  }
}