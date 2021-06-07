import 'package:familytree/Controllers/SocialDataController.dart';
import 'package:familytree/Views/PopUps/SocialUser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:familytree/Models/Colors.dart';
import 'package:familytree/Models/Utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Models/Colors.dart';

class SocialList extends StatefulWidget {
  SocialList({Key key}) : super(key: key);

  @override
  _SocialListState createState() => _SocialListState();
}

class _SocialListState extends State<SocialList> {
  SocialDataController _socialController = SocialDataController();

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
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
          'Social Data'.toUpperCase(),
          style: TextStyle(color: UtilColors.whiteColor, fontSize: 19.0),
        ),
        centerTitle: true,
      ),
      body: Container(
          height: Utils.displaySize.height,
          width: Utils.displaySize.width,
          child: Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextFormField(
                  controller: _searchController,
                  decoration: Utils.getDefaultTextInputDecoration(
                      'Search By Member Name',
                      Icon(
                        Icons.person,
                        color: UtilColors.greyColor.withOpacity(0.6),
                      )),
                  cursorColor: UtilColors.primaryColor,
                  onFieldSubmitted: (val) {
                    setState(() {});
                  },
                  keyboardType: TextInputType.text,
                  style: Utils.getprimaryFieldTextStyle(UtilColors.greyColor),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              FutureBuilder<DataSnapshot>(
                future: SocialDataController().getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<dynamic, dynamic> records = snapshot.data.value;
                    if (records != null) {
                      List<Widget> list = [];

                      if (_searchController.text.isNotEmpty) {
                        records.forEach((key, value) {
                          if (value['name']
                              .toString()
                              .toLowerCase()
                              .contains(_searchController.text)) {
                            list.add(Card(
                              child: ListTile(
                                leading: GestureDetector(
                                  onTap: () async {
                                    value['id'] = key;
                                    await showDialog(
                                      context: context,
                                      builder: (_) => SocialUser(
                                        data: value,
                                      ),
                                    ).then((onValue) {
                                      setState(() {});
                                    });
                                  },
                                  child: ClipRRect(
                                    child: SizedBox(
                                      height: 50.0,
                                      width: 50.0,
                                      child: Image.asset(
                                          'assets/images/child.png'),
                                    ),
                                  ),
                                ),
                                title: Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, bottom: 10.0),
                                  child: Text(value['name'].toString()),
                                ),
                                subtitle: Row(
                                  children: [
                                    (value['facebook'] == null)
                                        ? SizedBox()
                                        : GestureDetector(
                                            onTap: () {
                                              openUrl(value['facebook']);
                                            },
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10.0),
                                              child: FaIcon(
                                                  FontAwesomeIcons.facebook,
                                                  color: Colors.blueAccent),
                                            ),
                                          ),
                                    (value['twitter'] == null)
                                        ? SizedBox()
                                        : GestureDetector(
                                            onTap: () {
                                              openUrl(value['twitter']);
                                            },
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10.0),
                                              child: FaIcon(
                                                FontAwesomeIcons.twitter,
                                                color: Colors.lightBlue,
                                              ),
                                            ),
                                          ),
                                    (value['instagram'] == null)
                                        ? SizedBox()
                                        : GestureDetector(
                                            onTap: () {
                                              openUrl(value['instagram']);
                                            },
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10.0),
                                              child: FaIcon(
                                                FontAwesomeIcons.instagram,
                                                color: Colors.pink,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                                trailing: GestureDetector(
                                  onTap: () async {
                                    _socialController.delete(key).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: UtilColors.redColor,
                                  ),
                                ),
                              ),
                            ));
                          }
                        });
                      } else {
                        records.forEach((key, value) {
                          list.add(Card(
                            child: ListTile(
                              leading: GestureDetector(
                                onTap: () async {
                                  value['id'] = key;
                                  await showDialog(
                                    context: context,
                                    builder: (_) => SocialUser(
                                      data: value,
                                    ),
                                  ).then((onValue) {
                                    setState(() {});
                                  });
                                },
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: 50.0,
                                    width: 50.0,
                                    child:
                                        Image.asset('assets/images/child.png'),
                                  ),
                                ),
                              ),
                              title: Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, bottom: 10.0),
                                child: Text(value['name'].toString()),
                              ),
                              subtitle: Row(
                                children: [
                                  (value['facebook'] == null)
                                      ? SizedBox()
                                      : GestureDetector(
                                          onTap: () {
                                            openUrl(value['facebook']);
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: FaIcon(
                                                FontAwesomeIcons.facebook,
                                                color: Colors.blueAccent),
                                          ),
                                        ),
                                  (value['twitter'] == null)
                                      ? SizedBox()
                                      : GestureDetector(
                                          onTap: () {
                                            openUrl(value['twitter']);
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: FaIcon(
                                              FontAwesomeIcons.twitter,
                                              color: Colors.lightBlue,
                                            ),
                                          ),
                                        ),
                                  (value['instagram'] == null)
                                      ? SizedBox()
                                      : GestureDetector(
                                          onTap: () {
                                            openUrl(value['instagram']);
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: FaIcon(
                                              FontAwesomeIcons.instagram,
                                              color: Colors.pink,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                              trailing: GestureDetector(
                                onTap: () async {
                                  _socialController.delete(key).then((value) {
                                    setState(() {});
                                  });
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: UtilColors.redColor,
                                ),
                              ),
                            ),
                          ));
                        });
                      }

                      return ListView(
                        children: list,
                      );
                    } else {
                      return Center(
                        child: Text('No Social Member Records Available'),
                      );
                    }
                  } else {
                    return LinearProgressIndicator();
                  }
                },
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => SocialUser(),
          ).then((onValue) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    ));
  }

  Future<void> openUrl(_url) async {
    _url = 'http://' + _url;
    await canLaunch(_url)
        ? await launch(_url)
        : Utils.showToast('Something Wrong.');
  }
}
