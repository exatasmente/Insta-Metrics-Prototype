import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:insta_metrics/models/Post.dart';
import 'package:intl/intl.dart';

class PostDetails extends StatefulWidget {
  static const String id = 'post_details_screen';
  PostDetails({Key key}) : super(key: key);

  @override
  _PostDetailsState createState() {
    return _PostDetailsState();
  }
}

class _PostDetailsState extends State<PostDetails> {
  ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  String formatNumber(number){
    return NumberFormat.compact().format(number).toString();
  }
  @override
  Widget build(BuildContext context) {
    String formatDate(int date) =>
        date < 10 ? '0' + date.toString() : date.toString();
    String postDate(Post post) =>
        '${formatDate(post.post_date.day)}/${formatDate(post.post_date.month)}/${formatDate(post.post_date.year)} - ${formatDate(post.post_date.hour)}:${formatDate(post.post_date.minute)}';

    Post post = ModalRoute.of(context).settings.arguments;
    if (post == null) {
      Navigator.pop(context);
    }
    return Scaffold(
        //backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Text(
            "Post in: "+postDate(post),
            style: TextStyle(color: Colors.grey[500]),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.grey[500],size: 30),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: post.hashCode,
            child: Container(
              decoration: BoxDecoration(

                  color: Colors.transparent,
                  image: DecorationImage(
                      image: NetworkImage(post.media_url), fit: BoxFit.cover)),
              height: 400,
                  child:  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                image: DecorationImage(
                                    image: NetworkImage(post.media_url), fit: BoxFit.fitHeight)),
                        )
                      ],
                    ),
                  ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 480,
            child: ListView(controller: controller, children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(children: <Widget>[
                                Text('Likes',
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 20)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(this.formatNumber(post.likes),
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 20)),
                              ]),
                              Column(children: <Widget>[
                                Text('Comments',
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 20)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(this.formatNumber(post.comments),
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 20)),
                              ]),
                            ]),
                      ),
                    )
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              Container(
                margin: EdgeInsets.only(left: 4, right: 4),
                height: 60,
                width: MediaQuery.of(context).size.width*0.80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    for (var text
                        in post.caption.replaceAll('\n', ' ').split(' '))
                      if (text.startsWith('#'))
                        Tooltip(
                          message: text,
                          child: Chip(
                            label: Text(text),
                          ),
                        )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white),
                child: Center(child: Text(post.caption)),
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                width: MediaQuery.of(context).size.width * 0.80,
              )
            ]),
          ),
        ],
      ),
    ));
  }
}
