import 'package:anycloud_pre_training/di/github_api.dart';
import 'package:anycloud_pre_training/view/components/icon_button_profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          return Text('エラー: ${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(gitHubApi.userDetails['name'] ?? 'N/A'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  context.go("/");
                },
              ),
              actions: [
                UserProfileIconButton()
              ],
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
                        SizedBox(height: 10),
                        Text('Name: ' + (gitHubApi.userDetails['name'] ?? 'N/A')),
                        Text('Following: ' + (gitHubApi.userDetails['following']?.toString() ?? 'N/A')),
                        Text('Followers: ' + (gitHubApi.userDetails['followers']?.toString() ?? 'N/A')),
                        Text('Bio: ' + (gitHubApi.userDetails['bio'] ?? 'N/A')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
