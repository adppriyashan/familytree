import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:familytree/Controllers/ProfileController.dart';
import 'package:familytree/Models/Colors.dart';
import 'package:familytree/Models/Utils.dart';
import 'package:flutter/material.dart';

class PartProfile extends StatefulWidget {
  PartProfile({Key key}) : super(key: key);

  @override
  _PartProfileState createState() => _PartProfileState();
}

class _PartProfileState extends State<PartProfile> {
  TextEditingController _name = TextEditingController();
  TextEditingController _mobile = TextEditingController();

  var _profileFormKey = GlobalKey<FormState>();

  ProfileController _profileController = ProfileController();

  FirebaseStorage _storage;

  Widget _profileImage = Image.network(
    'https://i.dlpng.com/static/png/5327106-businessman-icon-png-263229-free-icons-library-businessman-icon-png-512_512_preview.png',
    fit: BoxFit.cover,
  );

  Uint8List _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    fillData();

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
      backgroundColor: UtilColors.primaryColor,
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
                key: _profileFormKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Profile'.toUpperCase(),
                      style: TextStyle(
                          color: UtilColors.whiteColor, fontSize: 19.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(
                      color: UtilColors.primaryColor,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: SizedBox(
                        height: Utils.displaySize.width * 0.3,
                        width: Utils.displaySize.width * 0.3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child:
                              (Utils.profileUser.img != null && _image == null)
                                  ? FutureBuilder<Widget>(
                                      future: _getImage(Utils.profileUser.uid),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          _profileImage = snapshot.data;
                                          return _profileImage;
                                        } else {
                                          return LinearProgressIndicator();
                                        }
                                      })
                                  : _profileImage,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      Utils.profileUser.name.toUpperCase(),
                      style: TextStyle(
                          color: UtilColors.whiteColor, fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      Utils.profileUser.email,
                      style: TextStyle(
                          color: UtilColors.whiteColor, fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    TextFormField(
                      controller: _name,
                      decoration:
                          Utils.getDefaultTextInputDecorationForHomeSearch(
                              'Name',
                              Icon(Icons.person, color: UtilColors.whiteColor)),
                      cursorColor: UtilColors.primaryColor,
                      keyboardType: TextInputType.emailAddress,
                      style: Utils.getprimaryFieldTextStyleWhite(
                          UtilColors.blackColor),
                      onChanged: (value) {},
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter your name.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration:
                          Utils.getDefaultTextInputDecorationForHomeSearch(
                              'Email',
                              Icon(Icons.email, color: UtilColors.whiteColor)),
                      cursorColor: UtilColors.primaryColor,
                      readOnly: true,
                      keyboardType: TextInputType.emailAddress,
                      style: Utils.getprimaryFieldTextStyleWhite(
                          UtilColors.whiteColor),
                      initialValue: Utils.profileUser.email.toString(),
                      onChanged: (value) {},
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _mobile,
                      decoration:
                          Utils.getDefaultTextInputDecorationForHomeSearch(
                              'Mobile',
                              Icon(Icons.baby_changing_station,
                                  color: UtilColors.whiteColor)),
                      cursorColor: UtilColors.primaryColor,
                      keyboardType: TextInputType.emailAddress,
                      style: Utils.getprimaryFieldTextStyleWhite(
                          UtilColors.blackColor),
                      onChanged: (value) {},
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FlatButton(
                        onPressed: () async {
                          if (_profileFormKey.currentState.validate()) {
                            Utils.showLoader(context);
                            var dataObj = {
                              'name': _name.text,
                              'mobile':
                                  (_mobile.text.isEmpty) ? null : _mobile.text,
                            };

                            if (_image != null) {
                              dataObj['img'] = Utils.profileUser.uid;
                            }

                            await _profileController.updateProfile(dataObj);

                            if (_image != null) {
                              await _profileController.uploadImage(_image);
                            }

                            Utils.hideLoaderCurrrent(context);
                            Utils.showToast('Profile Updated');
                            _image = null;
                            setState(() {
                              fillData();
                            });
                          }
                        },
                        child: Text(
                          "UPDATE PROFILE",
                        ),
                        color: UtilColors.orangeColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Utils.buttonBorderRadius),
                            side: BorderSide(color: UtilColors.secondaryColor)),
                        height: 42.0,
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    ));
  }

  void fillData() {
    _name.text = Utils.profileUser.name;
    _mobile.text =
        (Utils.profileUser.mobile == null) ? '' : Utils.profileUser.mobile;
  }

  Future<Widget> _getImage(String uid) async {
    Image m;
    await _storage
        .ref(uid + '.jpg')
        .getDownloadURL()
        .then((value) => m = Image.network(
              value,
              fit: BoxFit.cover,
            ));

    return m;
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = await pickedFile.readAsBytes();

      setState(() {
        _profileImage = Image.memory(
          _image,
          fit: BoxFit.cover,
        );
      });
    } else {
      Utils.showToast('No image selected.');
    }
  }
}
