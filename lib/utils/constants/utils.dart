import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color colorPrimary1 = Color(0xFF205A72);
const Color colorPrimary = Color(0xFF2A5367);
const Color dialogColor = Color(0xFFA2B3BC);
const Color dialogIconColor = Color(0xFF0099FF);
const Color dialogBtnColor = Color(0xFF567485);
const Color btnColor1 = Color(0xFF44758D);
const Color fbBtnColor = Color(0xFF3D5A98);

final String prodEndPoint = 'https://ccc.guardian4emergency.com';
final String devEndPoint = 'https://ccc.guardian4emergency.com';
final String termsEndPoint = 'https://guardian4emergency.com';
final String secretHollowsEndPoint = 'http://10.128.50.147:3000'; //'https://ce26c1b1-bc28-4a2e-b2cb-c1460f1e904f.mock.pstmn.io' //https://secret-hollows-28950.herokuapp.com

const String gMAK = 'AIzaSyCoviUZrvv1kcF9gNDhdmuLevZDwSREJE8';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: colorPrimary, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: colorPrimary, width: 2.0),
  ),
);

const editInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
  filled: true,
  fillColor: Colors.white,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide(width: 2, color: colorPrimary),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide(width: 2, color: Colors.grey),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide(width: 2, color: colorPrimary),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    borderSide: BorderSide(width: 2,),
  ),
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  labelStyle: TextStyle(
    color: Colors.black,
  ),
  // errorText: _validatePassword ? _passwordErrorMsg : null,
  errorStyle: TextStyle(
    letterSpacing: 1.5,
    fontSize: 10.0,
  ),
);

final List appBar = [
  CustomAppBarHome(
    height: 88.0,
    icon: Image.asset(
      'assets/images/guardian.png',
      height: 88.0,
      width: 88.0,
      fit: BoxFit.fitWidth,
      alignment: FractionalOffset.center,
    ),
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'GUARDIAN',
          style: TextStyle(
              fontSize: 28.0,
              color: colorPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: 4.0),
        ),
        Text(
          'Emergency Response',
          style: TextStyle(
            fontSize: 10.0,
            color: colorPrimary,
            letterSpacing: 4.2,
            wordSpacing: 8.0,
          ),
        ),
      ],
    ),
    actions: Row(
      children: [
        ClipOval(
          child: Material(
            // button color
            child: InkWell(
              splashColor: Colors.grey.shade700, // inkwell color
              child: SizedBox(
                width: 48.0,
                height: 48.0,
                child: Icon(
                  Icons.search,
                  color: Colors.grey.shade500,
                ),
              ),
              onTap: () {},
            ),
          ),
        ),
        SizedBox(
          width: 2.0,
        ),
        ClipOval(
          child: Material(
            // button color
            child: InkWell(
              splashColor: Colors.grey.shade700, // inkwell color
              child: SizedBox(
                width: 48.0,
                height: 48.0,
                child: Icon(
                  Icons.menu,
                  color: Colors.grey.shade500,
                ),
              ),
              onTap: () {},
            ),
          ),
        ),
      ],
    ),
  ),
  null,
  CustomAppBarStandard(
    icon: ClipOval(
      child: Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.grey.shade700, // inkwell color
          child: SizedBox(
            width: 36.0,
            height: 36.0,
            child: Icon(
              CupertinoIcons.back,
              color: colorPrimary,
            ),
          ),
          onTap: () {},
        ),
      ),
    ),
    title: Text(
      'Report Incident',
      style: TextStyle(fontSize: 20.0, color: colorPrimary),
    ),
    actions: Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: FlatButton(
        child: Text(
          'REPORT',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: colorPrimary,
          ),
        ),
        textColor: colorPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        color: Colors.white,
        splashColor: Colors.grey.shade500,
        onPressed: () {},
      ),
    ),
    height: 56.0,
  ),
  null,
];

//Widget getAppBar(int index) => _appBar[index];

class CustomAppBarStandard extends StatelessWidget
    implements PreferredSizeWidget {
  final double height;
  final Widget icon;
  final Text title;
  final Widget actions;

  const CustomAppBarStandard(
      {Key key, this.height, this.icon, this.title, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: height,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              icon,
              SizedBox(
                width: 8.0,
              ),
              title,
            ],
          ),
          actions,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class CustomAppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Widget icon;
  final Widget title;
  final Widget actions;

  const CustomAppBarHome(
      {Key key, this.height, this.icon, this.title, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: height,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          icon,
          title,
          actions,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class CustomAppBarSpecial extends StatelessWidget
    implements PreferredSizeWidget {
  final double height;

  const CustomAppBarSpecial({
    Key key,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class PlaceholderWidget extends StatelessWidget {
  const PlaceholderWidget(this.title, this.message);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 32.0, color: Colors.black54),
              textAlign: TextAlign.center),
          Text(message,
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class AddressLatLng {
  final String address;
  final double lat;
  final double lng;
  AddressLatLng({this.address, this.lat, this.lng});
}