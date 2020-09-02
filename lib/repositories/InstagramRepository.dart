import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insta_metrics/contracts/InstagramInterface.dart';
import 'package:insta_metrics/models/Post.dart';
class InstagramResponse{
  final Map<String,dynamic> jsonData;
  final List<Post> posts;

  InstagramResponse({this.jsonData, this.posts});
}
class InstagramRepository implements InstagramInterface {
  InstagramRepository();
  searchPosts(String username) async {
    try {
      final response = await http.get("https://www.instagram.com/$username/?__a=1");

      if (response.statusCode == 200) {
        String nextPage;
        var jsonData = json.decode(response.body);
        var posts = [];
        jsonData = jsonData['graphql']['user'];
        if (!jsonData['edge_owner_to_timeline_media']['page_info']['has_next_page'] == true) {
          for (var post in jsonData['edge_owner_to_timeline_media']['edges']) {
            posts.add(post['node']);
          }
        } else {
          nextPage = jsonData['edge_owner_to_timeline_media']['page_info']
          ['end_cursor'];
          http.Response responsePosts;

          while (nextPage != null) {
            responsePosts = await http.get(
                "https://www.instagram.com/graphql/query/?query_id=17888483320059182&id=" +
                    jsonData['id'] +
                    "&first=50&after=" +
                    nextPage);

            var jsonPostData = json.decode(responsePosts.body);

            if (jsonPostData['status'] == "ok") {
              jsonPostData =
              jsonPostData['data']['user']['edge_owner_to_timeline_media'];

              if (jsonPostData['page_info']['has_next_page'] == true) {
                nextPage = jsonPostData['page_info']['end_cursor'];
              } else {
                nextPage = null;
              }

              for (var post in jsonPostData['edges']) {
                posts.add(post['node']);
              }
            }
          }
        }
        var ret = [];
        ret.add(jsonData);
        ret.add(posts);
        return ret;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
