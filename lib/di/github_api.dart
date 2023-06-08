import 'dart:io';
import 'package:anycloud_pre_training/di/secret.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GitHubApi with ChangeNotifier {
  List<dynamic> _repositories = [];
  Map _userDetails = {};


//ユーザーのアバターを取得するための変数
  String? _userAvatarUrl;

//ユーザーのアバターを取得するためのメソッド
  String? get userAvatarUrl {
    return _userAvatarUrl;
  }

  //リポジトリーを取得するためのメソッド
  //ユーザー情報を取得するためのメソッド
  Future<void> fetchUserDetails(String username) async {
    try {
      final url = Uri.parse('https://api.github.com/users/$username');
      final response = await http.get(
        url, 
        headers: <String, String>{'Authorization': 'token $ACCESS_TOKEN'}, // ここにトークンを追加
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

  // Future<void> fetchUserDetails(String username) async {
  //   try {
  //     final url = Uri.parse('https://api.github.com/users/aquaman1182');
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       _userDetails = json.decode(response.body) as Map<String, dynamic>;
  //       _userAvatarUrl = _userDetails['avatar_url'] as String;
  //       print('Fetched user details: $_userDetails');
  //       notifyListeners();
  //     } else {
  //       throw HttpException('Failed to load user details');
  //     }
  //   } catch (error) {
  //     print('Error fetching user details: $error');
  //     throw error;
  //   }
  // }

  //ページネーションのための変数
  int _page = 1;
  //スクロールコントローラーのための変数
  ScrollController _scrollController = ScrollController();

  //ページネーションのためのメソッド
  GitHubApi() {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          // When we're at the bottom of the ListView, fetch more data.
          fetchRepositories('');
        }
      }
    });
  }

  //スクロールコントローラーのためのメソッド
  ScrollController get scrollController => _scrollController; 


  List<dynamic> get repositories {
    return [..._repositories];
  }

  Map get userDetails {
    return {..._userDetails};
  }

  Future<void> fetchRepositories(String query) async {
    final response = await http.get(
      Uri.parse('https://api.github.com/search/repositories?q=$query&page=$_page'),
      headers: <String, String>{'Authorization': 'token $ACCESS_TOKEN'}, // ここにトークンを追加
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _repositories.addAll(data['items']); // append new data to existing list
      _page++; // increment page number
      notifyListeners();
    } else {
      throw Exception('Failed to load repositories');
    }
  }

  getRepositoryByName(String repositoryName) {
    return _repositories.firstWhere((repo) => repo['name'] == repositoryName,
        orElse: () => null);
  }
}
