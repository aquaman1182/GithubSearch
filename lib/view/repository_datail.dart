import 'package:anycloud_pre_training/di/github_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RepositoryDetailPage extends StatelessWidget {
  final String repoName;

  RepositoryDetailPage({required this.repoName});

  @override
  Widget build(BuildContext context) {
    final GitHubApi gitHubApi = context.read();
    final repository = gitHubApi.getRepositoryByName(repoName);

    return Scaffold(
      appBar: AppBar(
        title: Text(repository['name'].toString()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/");
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.green[100],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                children: <Widget>[
                  if (gitHubApi.userDetails['avatar_url'] != null)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(gitHubApi.userDetails['avatar_url']),
                  ),
                  Text('🎌' + 'Language: ${repository['language'].toString()}'),
                  SizedBox(height: 10), // 間隔を追加
                  Text('⭐️' + 'Stars: ${repository['stargazers_count'].toString()}'),
                  SizedBox(height: 10), // 間隔を追加
                  Text('👀' + 'Watchers: ${repository['watchers_count'].toString()}'),
                  SizedBox(height: 10), // 間隔を追加
                  Text('©️' + 'Forks: ${repository['forks_count'].toString()}'),
                  SizedBox(height: 10), // 間隔を追加
                  Text('🤡' + 'Issues: ${repository['open_issues_count'].toString()}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
