import 'package:anycloud_pre_training/di/github_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RepositoryDetailPage extends StatelessWidget {
  final String repositoryName;

  RepositoryDetailPage({required this.repositoryName, required Map repository});

  @override
  Widget build(BuildContext context) {
    final gitHubApi = context.read<GitHubApi>();
    final repository = gitHubApi.getRepositoryByName(repositoryName);

    return Scaffold(
      appBar: AppBar(
        title: Text(repository['name']),
      ),
      body: Column(
        children: <Widget>[
          Text('Language: ${repository['language']}'),
          Text('Stars: ${repository['stargazers_count']}'),
          // Add more fields as needed
        ],
      ),
    );
  }
}