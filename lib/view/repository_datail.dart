import 'package:anycloud_pre_training/di/github_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go("/");
            },
          )
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text('🎌' + 'Language: ${repository['language'].toString()}'),
                Text('⭐️' + 'Stars: ${repository['stargazers_count'].toString()}'),
                Text('👀' + 'Watchers: ${repository['subscribers_count'].toString()}'),
                Text('©️' + 'Forks: ${repository['forks_count'].toString()}'),
                Text('🤡' + 'Issues: ${repository['open_issues_count'].toString()}'),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Repository not found'),
        ),
      );
    }
  }
}
