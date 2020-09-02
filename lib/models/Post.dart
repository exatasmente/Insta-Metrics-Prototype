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