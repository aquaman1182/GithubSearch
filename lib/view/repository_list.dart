import 'package:anycloud_pre_training/di/github_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RepositoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GitHubApi>(
      builder: (ctx, gitHubApi, _) => ListView.builder(
        itemCount: gitHubApi.repositories.length,
        itemBuilder: (ctx, i) => ListTile(
          title: Text(gitHubApi.repositories[i]['name']),
          onTap: () {
            // Navigate to repository details page
          },
        ),
      ),
    );
  }
}
