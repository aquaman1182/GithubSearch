import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../di/github_api.dart';

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
