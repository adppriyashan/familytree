import 'package:familytree/Models/FamilyData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:familytree/Models/Colors.dart';
import 'package:familytree/Models/User.dart';
import 'package:familytree/Views/PopUps/PopUpLoading.dart';

class Utils {
  static Size displaySize;

  //System Chrome UI Theme

  static bool dangerStatus = true;

  static ProfileUser profileUser;

  static FamilyData familyData;

  static List socialData = [];

  static var lightNavbar = SystemUiOverlayStyle.light.copyWith(
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: UtilColors.blackColor,
      statusBarColor: UtilColors.primaryStatusBarColor);

  static var darkNavbar = SystemUiOverlayStyle.dark.copyWith(
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: UtilColors.blackColor,
      statusBarColor: UtilColors.primaryStatusBarColor);

  //TextStyles
  static TextStyle getprimaryStyle(Color color) {
    return TextStyle(color: color, fontFamily: 'Natosans');
  }

  static TextStyle getprimaryBoldStyle(Color color) {
    return TextStyle(
        color: color, fontFamily: 'Natosans', fontWeight: FontWeight.bold);
  }

  static TextStyle getprimaryFieldTextStyle(Color color) {
    return TextStyle(
        color: UtilColors.greyColor, fontFamily: 'Natosans', fontSize: 13.0);
  }

  static TextStyle getprimaryFieldTextStyleWhite(Color color) {
    return TextStyle(
        color: UtilColors.whiteColor, fontFamily: 'Natosans', fontSize: 13.0);
  }

  //TextFormField Styles

  static double borderRadius = 20.0;
  static double buttonBorderRadius = 10.0;

  static InputDecoration getDefaultTextInputDecoration(
      String label, var suffixIcon) {
    return InputDecoration(
        labelText: label,
        errorStyle: TextStyle(fontSize: 11, color: Colors.red),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        labelStyle: TextStyle(fontSize: 13.0, color: UtilColors.greyColor),
        suffixIcon: suffixIcon,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: UtilColors.secondaryColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: UtilColors.primaryColor, width: 2.0),
        ));
  }

  static InputDecoration getDefaultTextInputDecorationForHomeSearch(
      String label, Icon suffixIcon) {
    return InputDecoration(
        labelText: label,
        errorStyle: TextStyle(fontSize: 11, color: Colors.red),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        labelStyle: TextStyle(fontSize: 13.0, color: UtilColors.whiteColor),
        suffixIcon: suffixIcon,
        fillColor: Colors.white,
        focusColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: UtilColors.whiteColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: UtilColors.whiteColor, width: 2.0),
        ));
  }

  //Loading Widgets

  static bool checkShowLoader = false;
  static BuildContext parentLoadingContext = null;

  static Future showLoader(context) async {
    await showDialog(
      context: context,
      builder: (_) => PopUpLoading(),
    ).then((onValue) {
      parentLoadingContext = context;
      checkShowLoader = true;
    });
  }

  static Future hideLoader() async {
    if (checkShowLoader == true && parentLoadingContext != null) {
      Navigator.pop(parentLoadingContext);
      parentLoadingContext = null;
      checkShowLoader = false;
    }
  }

  static Future hideLoaderCurrrent(context) async {
    Navigator.pop(context);
    parentLoadingContext = null;
    checkShowLoader = false;
  }

  //Toast Contents

  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
