import 'dart:io';
import 'package:cfi_complaints_app/models/Complaint.dart';
import 'package:cfi_complaints_app/models/user.dart';
import 'package:cfi_complaints_app/screens/home/compForm.dart';
import 'package:cfi_complaints_app/screens/home/complaintsList.dart';
import 'package:cfi_complaints_app/services/auth.dart';
import 'package:cfi_complaints_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'myComplaints.dart';

class Home extends StatefulWidget {

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  /*List<Asset> images = List<Asset>();
  String _error = 'No Image Added yet';
  final compTitle = TextEditingController();
  final compDescription = TextEditingController();
  int i=0;
  int complaintCount = 0;
  List<String> downloadUrl = List<String>();*/

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
  /*

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
    File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }


  void submitComp(DatabaseService db) async{
    for (int imgCount=1; imgCount <= images.length; imgCount++) {
      StorageReference imageReference = FirebaseStorage.instance.ref().child(
          'Complaint$complaintCount image$imgCount.jpg');
      File temp = await getImageFileFromAssets(images[imgCount-1]);
      StorageUploadTask uploadTask = imageReference.putFile(temp);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String downloadAddress = await imageReference.getDownloadURL();
      print(downloadAddress);
      setState(() {
        downloadUrl.add(downloadAddress);
      });
    }
    complaintCount++;
    await db.enterUserData(compTitle.text, compDescription.text, downloadUrl, complaintCount);
    compTitle.text = '';
    compDescription.text = '';
    setState(() {
      images.removeRange(0, images.length);
      downloadUrl.removeRange(0, downloadUrl.length);
    });
  }
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Image Selected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          selectionFillColor: "#ff11ab",
          selectionTextColor: "#ffffff",
          selectionCharacter: "✓",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#00BFFF",
          actionBarTitle: "Select Images",
          allViewTitle: "All Media",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
          lightStatusBar: true,
          statusBarColor: "#4169E1",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if(images!=null)
      _error = null;
    });
  }

  Widget Comp(DatabaseService db) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Title',
            ),
            maxLines: null,
            controller: compTitle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Description',
            ),
            controller: compDescription,
            maxLines: null,
          ),
        ),
        (_error!=null) ?
        Container(
          height: 100,
          child: Center(
              child: Text(
                _error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                ),
              )),
        ) : SizedBox(height: 20,),
        if(images.length != 0)
          dispImages(),
        SizedBox(
          height: 20,
        ),
        Center(
          child: RaisedButton(
            child: Text('Add Images'),
            onPressed: loadAssets,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: RaisedButton(
            child: Text('Submit Complaint'),
            onPressed:() => submitComp(db),
          ),
        ),
      ],
    );
  }

  Widget dispImages() {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: images.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          Asset asset = images[index];
          return Card(

            child: AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            ),
          );
        },
      ),
    );
  }*/
}
/*
class All extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder <QuerySnapshot>(
      stream: DatabaseService(user.uid).myComplaints,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.data.documents!=null) {
          List<Complaint> myComp = snapshot.data.documents.map((doc) {
            return Complaint(
              title: doc.data['title'],
              description: doc.data['description'],
              images_url: doc.data['images_url'],
            );
          }).toList();
          return ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                  margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                  child: ListTile(
                    title: Text(myComp[index].title),
                    subtitle: Text(myComp[index].description),
                  ),
                ),
              );
            },
            itemCount: myComp.length,
          );
        }
        else{
          return Center(child: Text('No Complaints yet'),);
        }
      },
    );
  }
}*/
/*
class All extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    return StreamProvider<List<Complaint>>.value(
      value: DatabaseService(user.uid).myComplaints,
      child: ComplaintsList(),
    );
  }
}


class ComplaintsList extends StatefulWidget {
  @override
  _ComplaintsListState createState() => _ComplaintsListState();
}

class _ComplaintsListState extends State<ComplaintsList> {

  @override
  Widget build(BuildContext context) {

    final myComplaints = Provider.of<List<Complaint>>(context);
    return myComplaints!=null ? ListView.builder(
        itemCount: myComplaints.length,
        itemBuilder: (context, index) {
          Complaint complaint = myComplaints[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
              child: ListTile(
                title: Text(complaint.title),
                subtitle: Text(complaint.description),
              ),
            ),
          );
    }) : Center(child: Text('No Complaints yet'),);
  }
}*/

