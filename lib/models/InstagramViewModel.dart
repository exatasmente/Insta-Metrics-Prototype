import 'package:flutter/material.dart';
import 'package:insta_metrics/contracts/InstagramInterface.dart';
import 'package:insta_metrics/models/providers/Filters.dart';
import 'package:insta_metrics/repositories/InstagramRepository.dart';

import 'Post.dart';
import 'filters/DateFilter.dart';
import 'filters/NumberFilter.dart';
class InstagramViewModel
    extends ChangeNotifier
    with Filters
    implements  InstagramInterface
  {

  final InstagramRepository repo;
   String userName;
   String fullName;
   String bio;
   String external_url;
   String profile_url;
   int followers;
   int following;
   List<Post> posts;
   int total_posts;
   int likes_total;
   int comments_total;

  InstagramViewModel({this.repo});

  searchPosts(String username) async{
    var data = await this.repo.searchPosts(username);
    if(data != null){
      print(data);
      this._setupUserData(data[0],data[1]);
      return true;
    }
    return false;
  }
  _setupUserData(Map<String,dynamic> json,List<dynamic> postsList){
    final int postQty = json['edge_owner_to_timeline_media']['count'];
    List<Post> posts = [];
    postsList.forEach((e) {
     posts.add(Post.fromJson(e));
    });
    var likes_total = posts.map((e) => e.likes).reduce((a, b) => a + b);
    print(likes_total);
    var comments_total = posts.map((e) => e.comments).reduce((a, b) => a + b);
    this.userName = json['username'];
    this.fullName = json['full_name'];
    this.bio = json['biography'];
    this.external_url=  json['external_url'] ?? null;
    this.total_posts = postQty;
    this.posts= posts;
    this.followers= json['edge_followed_by']['count'];
    this.following= json['edge_follow']['count'];
    this.profile_url=  json['profile_pic_url'];
    this.likes_total = likes_total;
    this.comments_total = comments_total;
  }
  getUserPosts(){
    return this.posts;
  }

  filterPosts(
  DateFilter filterByDate,
  NumberFilter filterByLikes,
  NumberFilter filterByComments,
  List<String> filterByHashTags,
  String order,
  int orderBy,
  bool dateFilter,
  bool likesFilter,
  bool commentsFilter){
    this.filterByDate = filterByDate;
    this.filterByLikes = filterByLikes;
    this.filterByComments = filterByComments;
    this.filterByHashTags = filterByHashTags;
    this.order = order;
    this.orderBy = orderBy;
    this.dateFilter = dateFilter;
    this.likesFilter = likesFilter;
    this.commentsFilter = commentsFilter;

    return this.posts;
  }

}