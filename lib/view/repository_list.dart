import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../di/github_api.dart';

class RepositoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GitHubApi>(
      builder: (ctx, gitHubApi, _) => ListView.builder(
        itemCount: gitHubApi.repositories.length,
        itemBuilder: (ctx, i) => Text(gitHubApi.repositories[i]['name']),
      ),
    );
  }
}
