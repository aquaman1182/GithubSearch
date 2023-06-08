import 'package:anycloud_pre_training/di/github_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailsScreen extends StatelessWidget {
  final String userName;

  UserDetailsScreen({required this.userName});

  @override
  Widget build(BuildContext context) {
    final GitHubApi gitHubApi = context.read();

    return FutureBuilder(
      future: gitHubApi.fetchUserDetails(userName),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(gitHubApi.userDetails['name'] ?? 'N/A'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (gitHubApi.userDetails['avatar_url'] != null)
                    Image.network(gitHubApi.userDetails['avatar_url']),
                  Text('Name: ' + (gitHubApi.userDetails['name'] ?? 'N/A')),
                  Text('Following: ' + (gitHubApi.userDetails['following']?.toString() ?? 'N/A')),
                  Text('Followers: ' + (gitHubApi.userDetails['followers']?.toString() ?? 'N/A')),
                  Text('Bio: ' + (gitHubApi.userDetails['bio'] ?? 'N/A')),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
