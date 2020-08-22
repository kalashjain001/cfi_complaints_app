import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class CompForm extends StatefulWidget {
  @override
  _CompFormState createState() => _CompFormState();
}

class _CompFormState extends State<CompForm> {

  List<Asset> images = List<Asset>();
  String _error = 'No Image Selected';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      _error = error;
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Description',
            ),
            maxLines: null,
          ),
        ),
        if(images.length != 0)
          SizedBox(
            height: 20,
          ),
        if(images.length != 0)
          dispImages(),
        SizedBox(
          height: 20,
        ),
        Center(
          child: RaisedButton(
            child: Text('Add images'),
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
      ],
    );
  }

  Widget all() {
    return Center(
      child: Text('All Complaints'),
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