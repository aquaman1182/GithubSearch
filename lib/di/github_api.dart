import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GitHubApi with ChangeNotifier {
  List _repositories = [];
  Map _userDetails = {};

  List get repositories {
    return [..._repositories];
  }

  Map get userDetails {
    return {..._userDetails};
  }

  Future<void> fetchRepositories(String query) async {
    final url = Uri.parse('https://api.github.com/search/repositories?q=$query');
    final response = await http.get(url);
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    _repositories = responseData['items'];
    notifyListeners();
  }

  Future<void> fetchUserDetails(String username) async {
    final url = Uri.parse('https://api.github.com/users/$username');
    final response = await http.get(url);
    _userDetails = json.decode(response.body) as Map<String, dynamic>;
    notifyListeners();
  }
}
