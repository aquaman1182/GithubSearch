import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GitHubApi with ChangeNotifier {
  List<dynamic> _repositories = [];
  Map _userDetails = {};

  List<dynamic> get repositories {
    return [..._repositories];
  }

  Map get userDetails {
    return {..._userDetails};
  }
  
  Future<void> fetchRepositories(String query) async {
    final response = await http.get(Uri.parse('https://api.github.com/search/repositories?q=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _repositories = data['items'];
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
    
  }
}
