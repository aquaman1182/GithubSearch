import 'package:anycloud_pre_training/di/github_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RepositoryDetailPage extends StatelessWidget {
  final String repoName;
  RepositoryDetailPage({required this.repoName});

  @override
  Widget build(BuildContext context) {
    final gitHubApi = context.read<GitHubApi>();
    final repository = gitHubApi.getRepositoryByName(repoName);

    if (repository != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(repository['name'].toString()),
        ),
        body: Column(
          children: <Widget>[
            Text('Language: ${repository['language'].toString()}'),
            Text('Stars: ${repository['stargazers_count'].toString()}'),
            // Add more fields as needed
          ],
        ),
      );
    } else {
      // Handle the case where repository is null
      return Scaffold(
        appBar: AppBar(
          title: Text('エラー'),
        ),
        body: Center(
          child: Text('リポジトリが見つかりませんでした'),
        ),
      );
    }
  }
}
