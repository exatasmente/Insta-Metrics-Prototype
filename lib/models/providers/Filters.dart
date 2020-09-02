import 'package:insta_metrics/models/filters/DateFilter.dart';
import 'package:insta_metrics/models/filters/NumberFilter.dart';
import '../Post.dart';
class Filters{
  DateFilter filterByDate;
  NumberFilter filterByLikes;
  NumberFilter filterByComments;
  List<String> filterByHashTags;
  String order;

  int orderBy;
  bool dateFilter;
  bool likesFilter;
  bool commentsFilter;

  List<Post> getPosts(List<Post> posts){
    if(this.dateFilter == true){
      posts = this.getPostsFilterByDate(posts);
    }
    if(this.likesFilter == true){
      posts = this.getPostsFilterByLikes(posts);

    }
    if(this.commentsFilter == true){
      posts = this.getPostsFilterByComments(posts);
      print('here');
    }
    switch(this.orderBy){
      case 1:
        posts = this.getPostsOrderByLikes(posts,order:this.order);
        break;
      case 2:
        posts = this.getPostsOrderByComments(posts,order:this.order);
        break;
      case 3:
        posts = this.getPostsOrderByDate(posts,order:this.order);
        break;
    }

    return posts;
  }

  List<Post> getPostsWithHashTag(hashtag,List<Post> posts){
    return posts.where((post) => post.caption.replaceAll('\n',' ').contains(hashtag)).toList();
  }
  List<Post> getPostsFilterByDate(List<Post> posts){
    return posts.where((post) => post.post_date.isAfter(this.filterByDate.startDate) && post.post_date.isBefore(this.filterByDate.endDate)).toList();
  }
  List<Post> getPostsFilterByLikes(List<Post> posts){
    return posts.where((post){
      return post.likes >= this.filterByLikes.minValue && post.likes <= this.filterByLikes.maxValue;
    }).toList();
  }
  List<Post> getPostsFilterByComments(List<Post> posts){
    return posts.where((post) {
      print(post);
      print("${this.filterByComments.minValue} ${this.filterByComments.maxValue}");
      print(post.comments >= this.filterByComments.minValue && post.comments <= this.filterByComments.maxValue);
      return post.comments >= this.filterByComments.minValue &&
          post.comments <= this.filterByComments.maxValue;
    }).toList();
  }
  List<Post> getPostsOrderByDate(List<Post> posts,{order = 'asc'}){
    if(order == 'asc') {
      posts.sort((a,b) => a.post_date.isBefore(b.post_date) ? 1 : -1 );
    }else{
      posts.sort((a,b) => a.post_date.isAfter(b.post_date) ? 1 : -1);
    }
    return posts;
  }
  List<Post> getPostsOrderByLikes(List<Post> posts,{order = 'asc'}){
    if(order == 'asc') {
      posts.sort((a,b) => a.likes >= b.likes ? 1 : -1 );
    }else{
      posts.sort((a,b) => a.likes <= b.likes ? 1 : -1);
    }
    return posts;
  }
  List<Post> getPostsOrderByComments(List<Post> posts,{order = 'asc'}){

    if(order == 'asc') {
      posts.sort((a,b) => a.comments >= b.comments ? 1 : -1 );
    }else{
      posts.sort((a,b) => a.comments <= b.comments ? 1 : -1);
    }
    return posts;
  }
}
