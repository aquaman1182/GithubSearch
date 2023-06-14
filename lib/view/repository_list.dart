import 'package:anycloud_pre_training/view/components/icon_button_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../di/github_api.dart';

class MyHomePage extends StatelessWidget {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GitHubApi gitHubApi = context.read();
    return Scaffold(
      appBar: AppBar(
        title: Text("GitHub Search"),
        actions: <Widget>[
          UserProfileIconButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: textController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                fillColor: Colors.grey[300],
                hintText: '検索',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                isDense: true
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.singleLineFormatter,
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return "文字を入れて下さい";
                }
                return null;
              },
              onFieldSubmitted: (_) {
                gitHubApi.resetRepositoriesAndPageNumber();
                gitHubApi.fetchRepositories(textController.text);
              },
            ),
            Expanded(
              child: Consumer<GitHubApi>(
                builder: (context, gitHubApi, _) => ListView.builder(
                  controller: gitHubApi.scrollController,
                  itemCount: gitHubApi.repositories.length + (gitHubApi.isLoading ? 1 : 0),
                  itemBuilder: (ctx, i) {
                    if (i < gitHubApi.repositories.length) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            tileColor: Colors.greenAccent[100],
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  gitHubApi.repositories[i]['owner']['avatar_url']),
                            ),
                            title: Text(gitHubApi.repositories[i]['name'].toString()),
                            subtitle:
                                Text(gitHubApi.repositories[i]['language'].toString()),
                            trailing: Text(
                              "⭐️" +
                                  gitHubApi.repositories[i]['stargazers_count']
                                      .toString(),
                            ),
                            onTap: () {
                              final repoName = gitHubApi.repositories[i]['name'].toString();
                              context.go('/repository/${Uri.encodeComponent(repoName)}');
                            },
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
