import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GitHubApi with ChangeNotifier {
  List<dynamic> _repositories = [];
  Map _userDetails = {};

  int _page = 1;
  ScrollController _scrollController = ScrollController();

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


  Future<void> fetchUserDetails(String username) async {
    try {
      final url = Uri.parse('https://api.github.com/users/$username');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        _userDetails = json.decode(response.body) as Map<String, dynamic>;
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

  getRepositoryByName(String repositoryName) {
    return _repositories.firstWhere((repo) => repo['name'] == repositoryName,
        orElse: () => null);
  }
}
