import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:insta_metrics/models/Instagram.dart';
import 'package:insta_metrics/screens/home/filters_screen.dart';
import 'package:insta_metrics/screens/home/post_details_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._card, this._height);

  final Widget _card;
  final double _height;

  @override
  double get minExtent => _height;
  @override
  double get maxExtent => _height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _card,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}

class HomeScreen extends StatelessWidget {
  static const String id = 'login_screen';
  RangeValues filterLikes;
  RangeValues filterComments;
  bool _likesFilter = false;
  bool _commentsFilter = false;
  bool _dateFilter = false;
  double _height = 60;
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    Instagram user  = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: SafeArea(
      child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                elevation: 0,
                title: Text(
                  'Insta Metrics',
                  style: TextStyle(color: Colors.grey[500]),
                ),
                backgroundColor: Colors.white,
                floating: false,
                actions: <Widget>[
                  GestureDetector(
                      onTap: () {},
                      child: Icon(Icons.menu, color: Colors.grey[500]))
                ],
                centerTitle: true,
                expandedHeight: 40,
                primary: false,
              ),
              SliverPersistentHeader(
                floating: false,
                delegate: _SliverAppBarDelegate(
                    Card(
                        margin: EdgeInsets.all(0),
                        elevation: 0,
                        child: buildProfileCard(context, user)),
                    400),
                pinned: false,
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(buildMetricsCard(context,user),60),
                pinned: true,
              ),
               SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        user.posts.sort( (a,b) => a.post_date.isBefore(b.post_date) == true ? 1 : -1 );
                    return Container(
                      child: buildPostCard(context,user.posts.elementAt(index), user,index),
                      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 3),
                    );
                  },
                  childCount: user.posts.length,
                ),
              )

            ],
      ),
    ),),
        );
  }

  Card buildProfileInfoCard(Instagram user) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 5),
      shadowColor: Colors.blueGrey,
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Center(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(children: <Widget>[
                        Text('Followers',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 20)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(this.formatNumber(user.followers),
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 20)),
                      ]),
                      Column(children: <Widget>[
                        Text('Following',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 20)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(this.formatNumber(user.following),
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 20)),
                      ]),
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
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
                        Text(this.formatNumber(user.likes_total),
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
                        Text(this.formatNumber(user.likes_total),
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 20)),
                      ]),
                      Column(children: <Widget>[
                        Text('Posts',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 20)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(this.formatNumber(user.total_posts),
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 20)),
                      ]),
                    ]),
              ),
              SizedBox(
                height: 60,
              ),
              Center(
                  child: Stack(children: <Widget>[
                Text(
                  'Posts',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600]),
                )
              ])),
              GestureDetector(onTap: (){}, child: Text("hashtag")),
            ],
          ),
        ),
      ),
    );
  }

  Card buildMetricsCard(context,Instagram user) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 0),
      elevation: 0,
      shadowColor: Colors.blueGrey,
      child: AnimatedContainer(
        duration: Duration(seconds: 2),
        height: _height,
        decoration: BoxDecoration(color: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Center(
                      child: Stack(children: <Widget>[
                        Text(
                          'Posts',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600]),
                        )
                      ])),
                  GestureDetector(onTap: (){}, child: Text("hashtag")),
                ],
              ),
              GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      isScrollControlled: true,
                        builder: (BuildContext context){
                        if(filterLikes == null){
                          filterLikes = RangeValues(
                            Options().getPostsOrderByLikes(user.posts).first.likes.toDouble(),
                            Options().getPostsOrderByLikes(user.posts).last.likes.toDouble()
                          );
                        }
                        if(filterComments == null){
                          filterComments = RangeValues(
                              Options().getPostsOrderByComments(user.posts).first.comments.toDouble(),
                              Options().getPostsOrderByComments(user.posts).last.comments.toDouble()
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
                                        Text(this.formatNumber(filterLikes.start.toInt())),
                                        RangeSlider(
                                            divisions: Options().getPostsOrderByComments(user.posts).last.likes,
                                            values: filterLikes,
                                            min : Options().getPostsOrderByLikes(user.posts).first.likes.toDouble(),
                                            max : Options().getPostsOrderByLikes(user.posts).last.likes.toDouble(),
                                            onChanged: (value){
                                              setState(() {
                                                _likesFilter = true;
                                                filterLikes = value;
                                              });
                                            }),
                                        Text(this.formatNumber(filterLikes.end.toInt())),
                                      ],
                                    ),
                                    SizedBox(
                                      height:  20,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(this.formatNumber(filterComments.start.toInt())),
                                        RangeSlider(
                                          divisions: Options().getPostsOrderByComments(user.posts).last.comments,
                                            values: filterComments,
                                            min : Options().getPostsOrderByComments(user.posts).first.comments.toDouble(),
                                            max : Options().getPostsOrderByComments(user.posts).last.comments.toDouble(),
                                            onChanged: (value){
                                              setState(() {
                                                _commentsFilter = true;
                                                filterComments = value;
                                              });
                                            }),
                                        Text(this.formatNumber(filterComments.end.toInt())),
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
                                      Navigator.pushNamed(
                                        context,
                                        FilterScreen.id,
                                        arguments: FilterModel(
                                          filter: FiltersController(
                                            likesFilter: _likesFilter,
                                            commentsFilter: _commentsFilter,
                                            dateFilter:  _dateFilter,
                                            filterByComments: NumberFilter(
                                              minValue: filterComments.start.toInt(),
                                              maxValue: filterComments.end.toInt()
                                            ),
                                            filterByLikes: NumberFilter(
                                              minValue: filterLikes.start.toInt(),
                                              maxValue: filterLikes.end.toInt()
                                            ),
                                            filterByDate: DateFilter(
                                              startDate: Options().getPostsOrderByDate(user.posts).first.post_date,
                                              endDate: Options().getPostsOrderByDate(user.posts).last.post_date
                                            ),
                                             filterByHashTags: [],
                                            order: 'asc',
                                            orderBy: 2
                                          ),
                                          user: user
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
                  child: Icon(Icons.filter_list, size: 30, color: Colors.grey[500],)),
            ],
          ),
        ),
      ),
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
                Hero(
                  tag: index,
                  child: Container(
                      height: 210,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                            image: NetworkImage(post.media_url),
                            fit: BoxFit.cover),
                        color: Colors.transparent,
                      )),
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
  Stack buildProfileCard(BuildContext context, Instagram user) {
    return Stack(
      children: <Widget>[
        Positioned(
            height: 100,
            top: 10,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.only(right: 5, left: 4),
                child: CircleAvatar(
                  backgroundImage: NetworkImage("${user.profile_url}"),
                  backgroundColor: Colors.grey,
                ),
              ),
            )),
        Positioned(
          top: 60,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          user.fullName,
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '@' + user.userName,
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
        Positioned(
          top: 200,
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(children: <Widget>[
                            Text('Followers',
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(this.formatNumber(user.followers),
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 20)),
                          ]),
                          Column(children: <Widget>[
                            Text('Following',
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(this.formatNumber(user.following),
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 20)),
                          ]),
                        ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
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
                            Text(this.formatNumber(user.likes_total),
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
                            Text(this.formatNumber(user.comments_total),
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 20)),
                          ]),
                          Column(children: <Widget>[
                            Text('Posts',
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(this.formatNumber(user.total_posts),
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 20)),
                          ]),
                        ]),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

}
