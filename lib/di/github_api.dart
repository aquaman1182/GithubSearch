import 'dart:io';
import 'package:anycloud_pre_training/di/secret.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GitHubApi with ChangeNotifier {
  List<Map<String, dynamic>> _repositories = [];
  final ScrollController scrollController = ScrollController();

  Map _userDetails = {};

  String? _userAvatarUrl;

  String lastQuery = '';

  String? get userAvatarUrl {
    return _userAvatarUrl;
  }

  //サーキュラーインジケーターの表示・非表示を管理するフラグ
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  Future<void> fetchUserDetails(String username) async {
    try {
      final url = Uri.parse('https://api.github.com/users/$username');
      final response = await http.get(
        url, 
        headers: <String, String>{'Authorization': 'token $ACCESS_TOKEN'}, 
      );
      if (response.statusCode == 200) {
        _userDetails = json.decode(response.body) as Map<String, dynamic>;
        _userAvatarUrl = _userDetails['avatar_url'] as String;
        print('Fetched user details: $_userDetails');
        notifyListeners();
      } else {
        throw HttpException('Failed to load user details');
      }
    } catch (error) {
      print('Error fetching user details: $error');
      throw error;
    }
  }

  GitHubApi() {
    scrollController.addListener(() {  // ここを修正
      if (scrollController.position.atEdge) {  // ここを修正
        if (scrollController.position.pixels != 0) {  // ここを修正
          fetchRepositories(lastQuery);
        }
      }
    });
  }

  List<dynamic> get repositories {
    return [..._repositories];
  }

  Map get userDetails {
    return {..._userDetails};
  }

  void resetRepositoriesAndPageNumber() {
    _repositories.clear();
    _currentPage = 1;
  }


int _currentPage = 1;
int _perPage = 30;  // You can set this value to anything up to 100.

Future<void> fetchRepositories(String query) async {
  print('fetchRepositories called with query: $query');
  lastQuery = query;

  _isLoading = true;
  notifyListeners();
  print('fetchRepositories called with query: $query');
  lastQuery = query;

  print('fetchRepositories called with query: $query');

  final response = await http.get(
    Uri.parse('https://api.github.com/search/repositories?q=$query&page=$_currentPage&per_page=$_perPage'),
    headers: <String, String>{
      'Authorization': 'token $ACCESS_TOKEN',  // your github access token
    },
  );

  if (response.statusCode == 200) {
    var list = jsonDecode(response.body)['items'] as List<dynamic>;
    _repositories.addAll(list.map((e) => e as Map<String, dynamic>));
    notifyListeners();
  } else {
    print('リポジトリの取得に失敗しました、ステータスコード: ${response.statusCode}');
    throw Exception('リポジトリの取得に失敗しました、ステータスコード: ${response.statusCode}');
  }
  _isLoading = false;
  notifyListeners();
  _currentPage++;
}

Map<String, dynamic> getRepositoryByName(String repositoryName) {
  try {
    return _repositories.firstWhere((repo) => repo['name'] == repositoryName);
  } catch (e) {
    throw FlutterError('No repository found with the given name');
  }
}

}
