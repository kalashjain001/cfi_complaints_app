import 'dart:io';
import 'package:cfi_complaints_app/models/Complaint.dart';
import 'package:cfi_complaints_app/models/user.dart';
import 'package:cfi_complaints_app/services/database.dart';
import 'package:cfi_complaints_app/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class NewComplaint extends StatefulWidget {
  @override
  _NewComplaintState createState() => _NewComplaintState();
}

class _NewComplaintState extends State<NewComplaint> {
  List<Asset> images = [];
  String _error = 'No Image Added yet';
  final compTitle = TextEditingController();
  final compDescription = TextEditingController();
  int i;
  int complaintCount;
  List<String> downloadUrl = [];
  bool loading = false;
  String process = 'Submitting Complaint...';


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final DatabaseService db = DatabaseService(user.uid);
    final myComplaints = Provider.of<List<Complaint>>(context);
    complaintCount = myComplaints!=null ? myComplaints.length : 0;

    return loading ? Loading(process) : ListView(
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
        (_error != null)
            ? Container(
                height: 100,
                child: Center(
                    child: Text(
                  _error,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                )),
              )
            : SizedBox(
                height: 20,
              ),
        if (images.length != 0) dispImages(),
        SizedBox(
          height: 20,
        ),
        Center(
          child: ElevatedButton(
            child: Text('Add Images'),
            onPressed: loadAssets,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: ElevatedButton(
            child: Text('Submit Complaint'),
            onPressed: () => submitComp(db, user.uid),
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
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = [];
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
      if (images != null) _error = null;
      if(images.length==0) _error = 'No Image Selected';
    });
  }

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

  void submitComp(DatabaseService db, String uid) async {
    setState(() {
      if(images.length!=0)
        process = 'Uploading images...';
      loading = true;
    });
    if (images.length != 0) {
      for (int imgCount = 1; imgCount <= images.length; imgCount++) {
        StorageReference imageReference = FirebaseStorage.instance
            .ref()
            .child('uid = $uid/Complaint${complaintCount+1} image$imgCount.jpg');
        File temp = await getImageFileFromAssets(images[imgCount - 1]);
        StorageUploadTask uploadTask = imageReference.putFile(temp);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        String downloadAddress = await imageReference.getDownloadURL();
        setState(() {
          downloadUrl.add(downloadAddress);
        });
      }
    }
    setState(() {
      process = 'Submitting Complaint...';
    });

    complaintCount++;
    await db.enterUserData(
        compTitle.text, compDescription.text, downloadUrl, complaintCount);
    compTitle.text = '';
    compDescription.text = '';
    setState(() {
      loading = false;
      images.removeRange(0, images.length);
      downloadUrl.removeRange(0, downloadUrl.length);
    });
  }
}
