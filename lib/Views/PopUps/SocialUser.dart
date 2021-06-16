import 'package:familytree/Controllers/SocialDataController.dart';
import 'package:familytree/Models/Colors.dart';
import 'package:familytree/Models/Utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialUser extends StatefulWidget {
  var data;

  SocialUser({this.data});

  @override
  State<StatefulWidget> createState() => SocialUserState(data: this.data);
}

class SocialUserState extends State<SocialUser> {
  var data;

  SocialDataController _controller = SocialDataController();

  SocialUserState({this.data});

  TextEditingController _name = TextEditingController();
  TextEditingController _fb = TextEditingController();
  TextEditingController _twitter = TextEditingController();
  TextEditingController _insta = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (data != null) {
      _name.text = this.data['name'];
      _fb.text = this.data['facebook'];
      _twitter.text = this.data['twitter'];
      _insta.text = this.data['instagram'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: UtilColors.whiteColor,
                  borderRadius: BorderRadius.circular(20.0)),
              padding: EdgeInsets.all(20.0),
              width: Utils.displaySize.width * 0.8,
              child: Column(
                children: [
                  Text(
                    'Add Member'.toUpperCase(),
                    style: GoogleFonts.openSans(
                        color: UtilColors.blackColor.withOpacity(0.8),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(
                    color: UtilColors.whiteColor,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _name,
                    decoration: Utils.getDefaultTextInputDecoration(
                        'Member Name',
                        Icon(
                          Icons.person,
                          color: UtilColors.greyColor.withOpacity(0.6),
                        )),
                    cursorColor: UtilColors.primaryColor,
                    keyboardType: TextInputType.text,
                    style: Utils.getprimaryFieldTextStyle(UtilColors.greyColor),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _fb,
                    decoration: Utils.getDefaultTextInputDecoration(
                        'Facebook Url',
                        Icon(
                          Icons.person,
                          color: UtilColors.greyColor.withOpacity(0.6),
                        )),
                    cursorColor: UtilColors.primaryColor,
                    keyboardType: TextInputType.text,
                    style: Utils.getprimaryFieldTextStyle(UtilColors.greyColor),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _twitter,
                    decoration: Utils.getDefaultTextInputDecoration(
                        'Twitter Url',
                        Icon(
                          Icons.person,
                          color: UtilColors.greyColor.withOpacity(0.6),
                        )),
                    cursorColor: UtilColors.primaryColor,
                    keyboardType: TextInputType.text,
                    style: Utils.getprimaryFieldTextStyle(UtilColors.greyColor),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _insta,
                    decoration: Utils.getDefaultTextInputDecoration(
                        'Instagram Url',
                        Icon(
                          Icons.person,
                          color: UtilColors.greyColor.withOpacity(0.6),
                        )),
                    cursorColor: UtilColors.primaryColor,
                    keyboardType: TextInputType.text,
                    style: Utils.getprimaryFieldTextStyle(UtilColors.greyColor),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: FlatButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Close",
                            ),
                            color: UtilColors.redColor,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Utils.buttonBorderRadius),
                                side: BorderSide(color: UtilColors.redColor)),
                            height: 42.0,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: FlatButton(
                            onPressed: () async {
                              if (_name.text.isNotEmpty) {
                                if (data == null) {
                                  var saveData = {'name': _name.text};

                                  if (_fb.text.isNotEmpty) {
                                    saveData['facebook'] = _fb.text;
                                  }
                                  if (_insta.text.isNotEmpty) {
                                    saveData['instagram'] = _insta.text;
                                  }
                                  if (_twitter.text.isNotEmpty) {
                                    saveData['twitter'] = _twitter.text;
                                  }

                                  _controller.save(saveData).then((value) {
                                    Navigator.pop(context);
                                    Utils.showToast('Saved New Member');
                                  });
                                } else {
                                  var updateData = {'name': _name.text};

                                  if (_fb.text.isNotEmpty) {
                                    updateData['facebook'] = _fb.text;
                                  }
                                  if (_insta.text.isNotEmpty) {
                                    updateData['instagram'] = _insta.text;
                                  }
                                  if (_twitter.text.isNotEmpty) {
                                    updateData['twitter'] = _twitter.text;
                                  }

                                  _controller
                                      .edit(this.data['id'], updateData)
                                      .then((value) {
                                    Navigator.pop(context);
                                    Utils.showToast('Member Updated');
                                  });
                                }
                              } else {
                                Utils.showToast('Member Name Cannot Be Empty');
                              }
                            },
                            child: Text(
                              (this.data != null) ? "Update" : "Save",
                            ),
                            color: UtilColors.primaryColor,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Utils.buttonBorderRadius),
                                side:
                                    BorderSide(color: UtilColors.primaryColor)),
                            height: 42.0,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
