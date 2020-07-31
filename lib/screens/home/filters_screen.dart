
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:insta_metrics/models/Instagram.dart';
import 'package:insta_metrics/screens/home/home_screen.dart';
import 'package:insta_metrics/screens/home/post_details_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilterModel{
  final FiltersController filter;
  final Instagram user;

  FilterModel({this.filter,this.user});
}

class FilterScreen extends StatelessWidget {
  static const String id = 'filter_screen';
  RangeValues filterLikes;
  RangeValues filterComments;
  bool _likesFilter = false;
  bool _commentsFilter = false;
  bool _dateFilter = false;
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    FilterModel values = ModalRoute.of(context).settings.arguments;
    List<Post> posts = values.filter.getPosts(values.user.posts);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                iconTheme: IconThemeData(color: Colors.grey[500]),
                elevation: 0,
                title: Text(
                  values.filter.filterByLikes.toString(),
                  style: TextStyle(color: Colors.grey[500]),
                ),
                backgroundColor: Colors.white,
                actions: <Widget>[
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          builder: (BuildContext context){
                            if(filterLikes == null){
                              filterLikes = RangeValues(
                                  values.filter.filterByLikes.minValue.toDouble(),
                                  values.filter.filterByLikes.maxValue.toDouble()
                              );
                            }
                            if(filterComments == null){
                              filterComments = RangeValues(
                                  values.filter.filterByComments.minValue.toDouble(),
                                  values.filter.filterByComments.maxValue.toDouble()
                              );
                            }
                            return StatefulBuilder(
                              builder: (context,setState){
                                return Container(
                                  height: MediaQuery.of(context).size.height*0.50,
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    alignment: WrapAlignment.center,
                                    spacing: 10,
                                    children: <Widget>[
                                      ListTile(
                                          leading: Icon(Icons.filter_list),
                                          title: Text('Filter By',style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[500],

                                          ),),
                                          onTap: () => {}
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(filterLikes.start.toInt().toString()),
                                          RangeSlider(
                                              values: filterLikes,
                                              min : Options().getPostsOrderByLikes(values.user.posts).first.likes.toDouble(),
                                              max : Options().getPostsOrderByLikes(values.user.posts).last.likes.toDouble(),
                                              onChanged: (value){
                                                setState(() {
                                                  _likesFilter = true;
                                                  filterLikes = value;
                                                });
                                              }),
                                          Text(filterLikes.end.toInt().toString()),
                                        ],
                                      ),
                                      ListTile(
                                        leading:Icon(Icons.sort),
                                        title: Text('Sort by',style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[500],

                                        ),),
                                        onTap: () => {},

                                      ),
                                      FlatButton(onPressed: (){
                                        setState(() {
                                        });
                                        Navigator.of(context).popUntil((route) => route.settings.name == HomeScreen.id);
                                        Navigator.pushNamed(
                                            context,
                                            FilterScreen.id,
                                            arguments: FilterModel(
                                                filter: FiltersController(
                                                    likesFilter: _likesFilter,
                                                    commentsFilter: _commentsFilter,
                                                    dateFilter:  _dateFilter,
                                                    filterByComments: NumberFilter(
                                                        maxValue: Options().getPostsOrderByComments(values.user.posts).first.comments,
                                                        minValue:  Options().getPostsOrderByComments(values.user.posts).last.comments
                                                    ),
                                                    filterByLikes: NumberFilter(
                                                        minValue: filterLikes.start.toInt(),
                                                        maxValue: filterLikes.end.toInt()
                                                    ),
                                                    filterByDate: DateFilter(
                                                        startDate: Options().getPostsOrderByDate(values.user.posts).first.post_date,
                                                        endDate: Options().getPostsOrderByDate(values.user.posts).last.post_date
                                                    ),
                                                    filterByHashTags: [],
                                                    order: 'asc',
                                                    orderBy: 2
                                                ),
                                                user: values.user
                                            )
                                        );
                                      },
                                          child: Text('Ok')
                                      )
                                    ],
                                  ),
                                );},
                            );},
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.filter_list, color: Colors.grey[500]),
                      ))
                ],
                centerTitle: true,
                expandedHeight: 40,
                floating: true,
                primary: true,
                pinned: true,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Container(
                      child: buildPostCard(
                          context, posts.elementAt(index), values.user,
                          index),
                      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 3),
                    );
                  },
                  childCount: posts.length,
                ),
              )
            ],
          ),
        ),),
    );
  }
  String formatNumber(number){
    return NumberFormat.compact().format(number).toString();
  }
  GestureDetector buildPostCard(context,Post post, Instagram user,index) {
    String formatDate(int date) =>
        date < 10 ? '0' + date.toString() : date.toString();
    String postDate(Post post) =>
        '${formatDate(post.post_date.day)}/${formatDate(post.post_date.month)}/${formatDate(post.post_date.year)} - ${formatDate(post.post_date.hour)}:${formatDate(post.post_date.minute)}';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, PostDetails.id, arguments: post);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        shadowColor: Colors.blueGrey,
        elevation: 0,
        child: SizedBox(
          child: Center(
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.grey[200],
              ),
              child: Stack(children: <Widget>[
                Container(
                      height: 210,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                            image: NetworkImage(post.media_url),
                            fit: BoxFit.cover),
                        color: Colors.transparent,
                      ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 210,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  width: MediaQuery.of(context).size.width * 0.80,
                  top: 20,
                  left: 20,
                  child: Center(
                    child: Text(
                      "Post in: " + postDate(post),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 15),
                    ),
                  ),
                ),
                Positioned(
                    top: 120,
                    width: MediaQuery.of(context).size.width * 0.80,
                    height: 60,
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Tooltip(
                              preferBelow: false,
                              message:
                              post.likes < 10 ? 'Post with Low Likes ' : '',
                              child: Icon(
                                Icons.favorite,
                                color: post.likes < 10
                                    ? Colors.orange[500]
                                    : Colors.red[500],
                                size: 30,
                              )),
                          Text(
                            this.formatNumber(post.likes),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 150,
                          ),
                          Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text(
                            post.comments.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    )),
                Positioned(
                  top: 155,
                  child: Container(
                    margin: EdgeInsets.only(left: 4, right: 4),
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        for (var text
                        in post.caption.replaceAll('\n', ' ').split(' '))
                          if (text.startsWith('#'))
                            Tooltip(
                              message: text,
                              child: GestureDetector(
                                onTap: () {

                                },
                                child: Chip(
                                  backgroundColor: Colors.grey[200],
                                  elevation: 0,
                                  label: Text(text),
                                ),
                              ),
                            )
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}