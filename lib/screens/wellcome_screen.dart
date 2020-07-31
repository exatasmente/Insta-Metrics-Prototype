
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insta_metrics/models/Instagram.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
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
                    try {
                      var user_name = _inputController.text;
                      final response = await http.get("https://www.instagram.com/$user_name/?__a=1");

                      if(response.statusCode == 200) {
                        String nextPage;
                        List<Post> posts = [];

                        var jsonData = json.decode(response.body);
                        jsonData = jsonData['graphql']['user'];
                        print(jsonData);

                        if (jsonData['edge_owner_to_timeline_media']['page_info']['has_next_page'] == true) {
                          nextPage = jsonData['edge_owner_to_timeline_media']['page_info']['end_cursor'];
                        } else {
                          for (var post in jsonData['edge_owner_to_timeline_media']['edges']) {
                            posts.add(Post.fromJson(post['node']));
                          }
                          Instagram insta = Instagram.fromJson(jsonData,posts);
                          Navigator.pushNamed(
                              context,
                              HomeScreen.id,
                              arguments: insta
                          );
                          setState(() {
                            showSpinner = false;
                          });
                        }
                        print(nextPage);
                        http.Response responsePosts;

                        while(nextPage != null) {
                          responsePosts = await http.get(
                              "https://www.instagram.com/graphql/query/?query_id=17888483320059182&id="+jsonData['id']+"&first=50&after=" +
                                  nextPage
                          );

                          var jsonPostData = json.decode(responsePosts.body);

                          if (jsonPostData['status'] == "ok") {
                            jsonPostData = jsonPostData['data']['user']['edge_owner_to_timeline_media'];

                            if (jsonPostData['page_info']['has_next_page'] ==
                                true) {
                              nextPage = jsonPostData['page_info']['end_cursor'];
                            } else {
                              nextPage = null;
                            }

                            for (var post in jsonPostData['edges']) {
                              posts.add(Post.fromJson(post['node']));
                            }
                          }
                          }

                          Instagram insta = Instagram.fromJson(jsonData,posts);
                          Navigator.pushNamed(
                              context,
                              HomeScreen.id,
                              arguments: insta
                          );
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    } catch (e) {

                      print(e);
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
  }
}