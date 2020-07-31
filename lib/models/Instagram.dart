import 'dart:convert';

import 'package:flutter/material.dart';

class DateFilter{
  final DateTime startDate;
  final DateTime endDate;

  DateFilter({this.startDate,this.endDate});
}
class NumberFilter{
  final int maxValue;
  final int minValue;

  NumberFilter({this.maxValue,this.minValue});
  String toString(){
    return "NumberFilter :{maxValue : $maxValue, minValue : $minValue }";
  }
}

class FiltersController extends ChangeNotifier{
  final DateFilter filterByDate;
  final NumberFilter filterByLikes;
  final NumberFilter filterByComments;
  final List<String> filterByHashTags;
  final String order;
  //  1 - date , 2 - likes , 3 - comments
  final int orderBy;
  final bool dateFilter;
  final bool likesFilter;
  final bool commentsFilter;

  FiltersController({this.filterByDate,this.filterByLikes,this.filterByComments,this.filterByHashTags,this.orderBy,this.likesFilter,this.commentsFilter,this.dateFilter,this.order});


  List<Post> getPosts(List<Post> posts){
    if(this.dateFilter == true){
      posts = this._getPostsFilterByDate(posts);
    }
    if(this.likesFilter == true){
      posts = this._getPostsFilterByLikes(posts);

    }
    if(this.commentsFilter == true){
      posts = this._getPostsFilterByComments(posts);
      print('here');
    }
    switch(this.orderBy){
      case 1:
        posts = this._getPostsOrderByLikes(posts,order:this.order);
        break;
      case 2:
        posts = this._getPostsOrderByComments(posts,order:this.order);
        break;
      case 3:
        posts = this._getPostsOrderByDate(posts,order:this.order);
        break;
    }

    return posts;
  }

  List<Post> _getPostsWithHashTag(hashtag,List<Post> posts){
    return posts.where((post) => post.caption.replaceAll('\n',' ').contains(hashtag)).toList();
  }
  List<Post> _getPostsFilterByDate(List<Post> posts){
    return posts.where((post) => post.post_date.isAfter(this.filterByDate.startDate) && post.post_date.isBefore(this.filterByDate.endDate)).toList();
  }
  List<Post> _getPostsFilterByLikes(List<Post> posts){
    return posts.where((post){
       return post.likes >= this.filterByLikes.minValue && post.likes <= this.filterByLikes.maxValue;
    }).toList();
  }
  List<Post> _getPostsFilterByComments(List<Post> posts){
    return posts.where((post) {
      print(post);
      print("${this.filterByComments.minValue} ${this.filterByComments.maxValue}");
      print(post.comments >= this.filterByComments.minValue && post.comments <= this.filterByComments.maxValue);
      return post.comments >= this.filterByComments.minValue &&
          post.comments <= this.filterByComments.maxValue;
    }).toList();
  }
  List<Post> _getPostsOrderByDate(List<Post> posts,{order = 'asc'}){
    if(order == 'asc') {
      posts.sort((a,b) => a.post_date.isBefore(b.post_date) ? 1 : -1 );
    }else{
      posts.sort((a,b) => a.post_date.isAfter(b.post_date) ? 1 : -1);
    }
    return posts;
  }
  List<Post> _getPostsOrderByLikes(List<Post> posts,{order = 'asc'}){
    if(order == 'asc') {
      posts.sort((a,b) => a.likes >= b.likes ? 1 : -1 );
    }else{
      posts.sort((a,b) => a.likes <= b.likes ? 1 : -1);
    }
    return posts;
  }
  List<Post> _getPostsOrderByComments(List<Post> posts,{order = 'asc'}){

    if(order == 'asc') {
      posts.sort((a,b) => a.comments >= b.comments ? 1 : -1 );
    }else{
      posts.sort((a,b) => a.comments <= b.comments ? 1 : -1);
    }
    return posts;
  }
}

class Options with ChangeNotifier{
  DateFilter filterByDate;
  NumberFilter filterByLikes;
  NumberFilter filterByComments;
  List<String> filterByHashTags;
  //  1 - date , 2 - likes , 3 - comments
  int orderBy;
  bool dateFilter;
  bool likesFilter;
  bool commentsFilter;
  List<Post> posts;
  Instagram user;

  Options({this.filterByDate,this.filterByLikes,this.filterByComments,this.filterByHashTags,this.orderBy,this.likesFilter,this.commentsFilter,this.dateFilter});

  List<Post> getPostsWithHashTag(hashtag,List<Post> posts){
    return posts.where((post) => post.caption.replaceAll('\n',' ').contains(hashtag)).toList();
  }

  List<Post> getPostsFilterByDate(posts){
    return posts.where((post) => post.post_date.isAfter(this.filterByDate.startDate) && post.post_date.isBefore(this.filterByDate.endDate)).toList();
  }
  List<Post> getPostsFilterByLikes(posts){
    return posts.where((post) => post.likes >= this.filterByLikes.minValue && post.likes <= this.filterByLikes.maxValue).toList();
  }
  List<Post> getPostsFilterByComments(posts){
    return posts.where((post) => post.likes >= this.filterByComments.minValue && post.likes <= this.filterByComments.maxValue).toList();
  }
  List<Post> getPostsOrderByDate(posts,{order = 'asc'}){
    if(order == 'asc') {
      posts.sort((a,b) => a.post_date.isBefore(b.post_date) ? 1 : -1 );
    }else{
      posts.sort((a,b) => a.post_date.isAfter(b.post_date) ? 1 : -1);
    }
    return posts;
  }
  List<Post> getPostsOrderByLikes(posts,{order = 'asc'}){
    if(order == 'asc') {
      posts.sort((a,b) => a.likes >= b.likes ? 1 : -1 );
    }else{
      posts.sort((a,b) => a.lkes <= b.likes ? 1 : -1);
    }
    return posts;
  }
  List<Post> getPostsOrderByComments(posts,{order = 'asc'}){

    if(order == 'asc') {
      posts.sort((a,b) => a.likes >= b.likes ? 1 : -1 );
    }else{
      posts.sort((a,b) => a.lkes <= b.likes ? 1 : -1);
    }
    return posts;
  }





}


class Post{
  final String type;
  final DateTime post_date;
  final String media_url;
  final String media_preview;
  final String caption;
  final int likes;
  final int comments;
  final bool is_video;


  Post({this.type, this.media_url, this.media_preview, this.caption, this.likes,
      this.comments,this.is_video,this.post_date});
  String toString(){
    return "Post{type: $type, likes : $likes, comments: $comments,is_video: $is_video}";
  }
  factory Post.fromJson(Map<String,dynamic> json){
    var caption = 'No caption';
    if(json['edge_media_to_caption'] != null){
      if(json['edge_media_to_caption']['edges'] != null && json['edge_media_to_caption']['edges'].length > 0 ){
        caption = json['edge_media_to_caption']['edges'][0]['node']['text'];
      }
    }

    return Post(
      type: json['__typename'],
      media_url:  json['display_url'],
      media_preview: json['media_preview'],
      likes:  json['edge_media_preview_like'] != null ? json['edge_media_preview_like']['count'] : 0,
      comments: json['edge_media_to_comment'] != null ? json['edge_media_to_comment']['count'] : 0,
      is_video: json['is_video'] == 1,
      caption: caption,
      post_date: DateTime.fromMillisecondsSinceEpoch(json['taken_at_timestamp']  * 1000)
    );
  }
}

class Instagram{
  final String userName;
  final String fullName;
  final String bio;
  final String external_url;
  final String profile_url;
  final int followers;
  final int following;
  final List<Post> posts;
  final int total_posts;
  final int likes_total;
  final int comments_total;
  Instagram({this.userName, this.fullName, this.bio, this.external_url,
      this.profile_url,
      this.followers, this.following,this.posts,this.total_posts,this.likes_total,this.comments_total});



  factory Instagram.fromJson(Map<String,dynamic> json,List<Post> posts){

    final int postQty = json['edge_owner_to_timeline_media']['count'];

    var likes_total = posts.map((e) => e.likes).reduce((a, b) => a + b);
    print(likes_total);
    var comments_total = posts.map((e) => e.comments).reduce((a, b) => a + b);
    return Instagram(
      userName: json['username'],
      fullName: json['full_name'],
      bio : json['biography'],
      external_url:  json['external_url'] ?? null,
      total_posts : postQty,
      posts: posts,
      followers: json['edge_followed_by']['count'],
      following: json['edge_follow']['count'],
      profile_url:  json['profile_pic_url'],
      likes_total : likes_total,
      comments_total : comments_total

    );
  }
}