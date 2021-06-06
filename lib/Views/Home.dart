import 'dart:math';

import 'package:familytree/Models/FamilyData.dart';
import 'package:familytree/Views/PopUps/NewRecord.dart';
import 'package:familytree/Views/SocialList.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:familytree/Models/Colors.dart';
import 'package:familytree/Models/Utils.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

import '../Models/Colors.dart';
import 'Profile.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseStorage _storage;

  String _selectedNodeKey;

  Map<String, dynamic> _familyMapNodes = {};

  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  @override
  void initState() {
    _storage = FirebaseStorage.instance;

    SystemChrome.setSystemUIOverlayStyle(Utils.lightNavbar);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: UtilColors.whiteColor,
      appBar: AppBar(
        backgroundColor: UtilColors.primaryColor,
        title: Text(
          'Home'.toUpperCase(),
          style: TextStyle(color: UtilColors.whiteColor, fontSize: 19.0),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.account_circle_outlined),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PartProfile()))),
          IconButton(
              icon: Icon(Icons.device_hub),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SocialList()))),
        ],
      ),
      body: Container(
        height: Utils.displaySize.height,
        width: Utils.displaySize.width,
        child: (_familyMapNodes.isEmpty)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset('assets/images/logo.png'),
                    height: Utils.displaySize.width * 0.25,
                    width: Utils.displaySize.width * 0.25,
                  ),
                  Text(
                    'Empty Family Tree',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text('Please add members using floating button below')
                ],
              )
            : InteractiveViewer(
                constrained: false,
                boundaryMargin: EdgeInsets.all(100),
                minScale: 0.1,
                maxScale: 5.6,
                child: GraphView(
                  graph: graph,
                  algorithm: BuchheimWalkerAlgorithm(
                      builder, TreeEdgeRenderer(builder)),
                  paint: Paint()
                    ..color = Colors.green
                    ..strokeWidth = 2
                    ..style = PaintingStyle.stroke,
                  builder: (Node node) {
                    return getWidget(node.key.value);
                  },
                )),
      ),
      floatingActionButton: (_familyMapNodes.length != 0)
          ? SizedBox()
          : FloatingActionButton(
              onPressed: () async {
                Utils.familyData = null;
                await showDialog(
                  context: context,
                  builder: (_) => NewRecord(),
                ).then((onValue) {
                  if (Utils.familyData != null) {
                    _addMemberToList(Utils.familyData);
                  }
                });
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.green,
            ),
    ));
  }

  Widget getWidget(key) {
    FamilyData _data = _familyMapNodes[key]['data'];

    return InkWell(
      onTap: () {
        _selectedNodeKey = _data.id;
      },
      child: GestureDetector(
        onTap: () async {
          _selectedNodeKey = key;
          Utils.familyData = null;
          await showDialog(
            context: context,
            builder: (_) => NewRecord(),
          ).then((onValue) {
            if (Utils.familyData != null) {
              _addMemberToList(Utils.familyData);
            }
          });
        },
        onLongPress: () {},
        child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: UtilColors.blackColor),
            child: Column(
              children: [
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: (_data.imgType == 1)
                      ? Image.asset(_data.img)
                      : Image.memory(_data.img),
                ),
                Text(
                  _data.name,
                  style: TextStyle(color: UtilColors.whiteColor),
                )
              ],
            )),
      ),
    );
  }

  _addMemberToList(FamilyData _member) {
    _member.id = _getKey();
    _member.selectedId = _selectedNodeKey;

    graph.graphObserver.clear();

    _familyMapNodes[_member.id] = {
      'node': Node.Id(_member.id),
      'data': _member
    };

    _familyMapNodes.forEach((key, record) {
      if (record['data'].selectedId == null) {
        graph.addNode(record['node']);
      } else {
        if (record['data'].type == 1 || record['data'].type == 2) {
          graph.addEdge(_familyMapNodes[record['data'].selectedId]['node'],
              record['node']);
        } else {
          graph.addEdge(record['node'],
              _familyMapNodes[record['data'].selectedId]['node']);
        }
      }
    });

    if (_familyMapNodes.length == 1) {
      builder
        ..siblingSeparation = (50)
        ..levelSeparation = (50)
        ..subtreeSeparation = (50)
        ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_BOTTOM_TOP);
    }

    setState(() {});
  }

  _getKey() {
    return "node" + DateTime.now().millisecondsSinceEpoch.toString();
  }
}
