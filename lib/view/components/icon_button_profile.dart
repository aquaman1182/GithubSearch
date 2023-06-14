import 'package:anycloud_pre_training/di/github_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserProfileIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GitHubApi gitHubApi = context.read();
    return IconButton(
      icon: gitHubApi.userAvatarUrl != null
          ? Image.network(gitHubApi.userAvatarUrl!)
          : Icon(Icons.account_circle),
      onPressed: () async {
        await gitHubApi.fetchUserDetails('aquaman1182');
        context.go('/user/${Uri.encodeComponent('aquaman1182')}');
      },
    );
  }
}
