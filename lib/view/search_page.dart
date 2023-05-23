import 'package:anycloud_pre_training/di/github_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (value) {
        Provider.of<GitHubApi>(context, listen: false).fetchRepositories(value);
      },
    );
  }
}
