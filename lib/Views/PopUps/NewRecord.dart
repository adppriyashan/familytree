import 'dart:typed_data';

import 'package:familytree/Models/Colors.dart';
import 'package:familytree/Models/FamilyData.dart';
import 'package:familytree/Models/Utils.dart';
import 'package:familytree/Views/Home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class NewRecord extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewRecordState();
}

class NewRecordState extends State<NewRecord> {
  int selectedType;
  TextEditingController _name = TextEditingController();

  Uint8List _selectedImage;

  final picker = ImagePicker();

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
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 45.0,
                    child: FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: Utils.getDefaultTextInputDecoration(
                              'Select Your Allergies (Optional)', null),
                          baseStyle: Utils.getprimaryFieldTextStyle(
                              UtilColors.whiteColor),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: [
                                DropdownMenuItem(
                                  child: Text('Mother'),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text('Father'),
                                  value: 2,
                                ),
                                DropdownMenuItem(
                                  child: Text('Child'),
                                  value: 3,
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedType = value;
                                });
                              },
                              hint: Text(
                                'Select Member Type',
                                style: Utils.getprimaryFieldTextStyle(
                                    UtilColors.greyColor),
                              ),
                              value: selectedType,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 50.0,
                          width: 50.0,
                          child: (_selectedImage == null)
                              ? Image.asset(getImage(selectedType))
                              : Image.memory(_selectedImage),
                        ),
                        FlatButton(
                          onPressed: () async {
                            selectImage();
                          },
                          child: Text(
                            "Upload Yours",
                          ),
                          color: UtilColors.greenColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Utils.buttonBorderRadius),
                              side: BorderSide(color: UtilColors.redColor)),
                          height: 42.0,
                        )
                      ],
                    ),
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
                    keyboardType: TextInputType.number,
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
                              Utils.familyData = null;
                              if (_name.text.isNotEmpty &&
                                  selectedType != null) {
                                Utils.familyData = FamilyData(
                                    img: (_selectedImage == null)
                                        ? getImage(selectedType)
                                        : _selectedImage,
                                    imgType: (_selectedImage == null) ? 1 : 2,
                                    name: _name.text,
                                    type: selectedType);

                                Navigator.pop(context);
                              } else {
                                Utils.showToast(
                                    "Please select member name and type");
                              }
                            },
                            child: Text(
                              "Start",
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

  getImage(type) {
    String path = '';

    switch (type) {
      case 1:
        path = 'assets/images/mother.png';
        break;
      case 2:
        path = 'assets/images/father.png';
        break;
      case 3:
        path = 'assets/images/child.png';
        break;
      default:
        path = 'assets/images/child.png';
    }

    return path;
  }

  Future selectImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = await pickedFile.readAsBytes();

      if (_selectedImage != null) {
        setState(() {});
      }
    } else {
      print('No image selected.');
    }
  }
}
