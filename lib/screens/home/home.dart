import 'dart:io';
import 'package:cfi_complaints_app/services/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Asset> images = List<Asset>();
  String _error = 'No Image Selected';
  String compTitle;
  String compDescription;
  StorageReference _refernce = FirebaseStorage.instance.ref().child('myimage.jpg');
  String downloadUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            return label == 'New Complaint' ? Comp() : all();
          }).toList(),
        ),
      ),
    );
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

  Future<void> uploadImage() async {
    File temp = await getImageFileFromAssets(images[0]);
    StorageUploadTask uploadTask = _refernce.putFile(temp);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    print('Uploaded');
  }

  Future<void> downloadImage() async{
    String downloadAddress = await _refernce.getDownloadURL();
    setState(() {
      downloadUrl = downloadAddress;
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

  Widget Comp() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Title',
            ),
            maxLines: null,
            onChanged: (value){
              setState(() {
                compTitle = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Description',
            ),
            onChanged: (value){
              setState(() {
                compDescription = value;
              });
            },
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
            child: Text('Select images'),
            onPressed: loadAssets,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: RaisedButton(
            child: Text('Submit Complaint'),
          ),
        ),
        SizedBox(height: 20,),
        Center(
          child: RaisedButton(
            child: Text('Upload Image'),
            onPressed: uploadImage,
          )
        )
      ],
    );
  }

  Widget all() {
    return Center(
      child: ListView(
        children: <Widget>[
          RaisedButton(
            child: Text('Download Image'),
            onPressed: downloadImage,
            ),
          if(downloadUrl!=null)
            Card(
              child: Container(
                child: Image.network(downloadUrl),
                height: 300,
                width: 300,
              ),
            ),
        ],
      )
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
}