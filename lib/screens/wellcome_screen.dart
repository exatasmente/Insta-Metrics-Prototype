
import 'package:flutter/material.dart';
import 'package:insta_metrics/models/InstagramViewModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:insta_metrics/components/rounded_button.dart';
import 'package:provider/provider.dart';
import 'home/home_screen.dart';
class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool showSpinner = false;
  String userName;
  TextEditingController _inputController = TextEditingController();

  updateUserName(){
    setState(() {
      this.userName = _inputController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final instagram = Provider.of<InstagramViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Insta metrics ',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  controller: _inputController,
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.indigoAccent,
                    ),
                    hintText: "Instagram username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blueGrey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.white, width: 1),
                    ),
                  ),
                  style: TextStyle(fontSize: 16.0, color: Colors.indigo),
                  onChanged: (query) => updateUserName,
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: 'Search',
                  colour: Colors.lightBlueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                      var response = await instagram.searchPosts(_inputController.text);
                      if(response == true) {
                        Navigator.pushNamed(
                          context,
                          HomeScreen.id,
                        );
                      }
                      setState(() {
                        showSpinner = false;
                      });
                  },
                ),
              ],
            ),
          ),
        ),
      );
  }
}