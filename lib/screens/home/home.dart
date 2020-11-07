import 'dart:io';
import 'package:cfi_complaints_app/models/Complaint.dart';
import 'package:cfi_complaints_app/models/user.dart';
import 'package:cfi_complaints_app/screens/home/newComplaint.dart';
import 'package:cfi_complaints_app/screens/home/myComplaintsList.dart';
import 'package:cfi_complaints_app/services/auth.dart';
import 'package:cfi_complaints_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';


class Home extends StatefulWidget {

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final DatabaseService db = DatabaseService(user.uid);
    final AuthService _auth = AuthService();
    final List<Tab> myTabs = <Tab>[
      Tab(text: 'New Complaint'),
      Tab(text: 'My Complaints'),
    ];

    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(

        appBar: AppBar(
          title: Text('Complaints'),
          bottom: TabBar(
            tabs: myTabs,
          ),
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('logout'))
          ],
        ),
        body: TabBarView(
          children: myTabs.map((Tab tab) {
            final String label = tab.text;
            return label == 'New Complaint' ? NewComplaint() : ComplaintsList();
          }).toList(),
        ),
      ),
    );
  }
}
