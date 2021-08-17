import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/user/data-user.dart';
import '../data/user/data-user2.dart';
import '../data/user/data-user-details.dart';
import '../data/data.dart';
import '../data/posts/data-post.dart';
import '../utils/constants/utils.dart';

class Webservice {
  Future<List<Data>> fetchNotifications(String keyword) async {
    final url =
        Uri.parse('$prodEndPoint/mobile/notifications?keyword=$keyword&api_token=8t4BzqCn5EHCxTqX82GRLFHYZH802hqWrkjzMVluoGjjF5Okovc9xpKshTeh');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final Iterable json = body["data"];
      return json.map((data) => Data.fromJsonMap(data)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<List<PostData>> fetchPosts(String token) async {
    // print('token: $token');
    final url = Uri.parse('$secretHollowsEndPoint/api/posts');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
        'Accept': '*/*',
      },
    );
    if (response.statusCode == 200) {
      final Iterable body = jsonDecode(response.body);
      return body.map((data) => PostData.fromJsonMap(data)).toList();
    } else {
      throw Exception("Failed to fetch posts!");
    }
  }

  Future<UserData2> fetchUserDetails(String token) async {
    final url = Uri.parse('$secretHollowsEndPoint/api/auth');
    final response = await http.get(
      url,
      headers: {
        'x-auth-token': token,
        'Accept': '*/*',
      },
    );
    if (response.statusCode == 200) {
      return UserData2.fromJsonMap(jsonDecode(response.body));
    } else {
      // print('${response.body}');
      throw Exception("Failed to fetch user details!");
    }
  }

  Future<Object> fetchUserProfile(String token) async {
    final url = Uri.parse('$secretHollowsEndPoint/api/profile/me');
    final response = await http.get(
      url,
      headers: {
        'x-auth-token': token,
        'Accept': '*/*',
      },
    );
    if (response.statusCode == 200) {
      print('/profile/me - ${response.body}');
      return UserDetailsData.fromJsonMap(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      return jsonDecode(response.body)['msg'];
    } else {
      throw Exception("Failed to fetch user profile!");
    }
  }

  Future<List<UserDetailsData>> fetchUsers() async {
    // print('token: $token');
    final url = Uri.parse('$secretHollowsEndPoint/api/profile');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
    );
    if (response.statusCode == 200) {
      final Iterable body = jsonDecode(response.body);
      return body.map((data) => UserDetailsData.fromJsonMap(data)).toList();
    } else {
      throw Exception("Failed to fetch users!");
    }
  }
}
