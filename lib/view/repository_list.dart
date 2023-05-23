import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../di/github_api.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({required Key key, required this.title}) : super(key: key);

  final String title;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter a search term',
            ),
            onSubmitted: (value) {
              Provider.of<GitHubApi>(context, listen: false).fetchRepositories(value);
            },
          ),
          Expanded(
            child: Consumer<GitHubApi>(
              builder: (context, gitHubApi, _) => ListView.builder(
                itemCount: gitHubApi.repositories.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(gitHubApi.repositories[i]['name']),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
