import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../di/github_api.dart';

class MyHomePage extends StatelessWidget {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GitHubApi gitHubApi = context.read<GitHubApi>();
    return Scaffold(
      appBar: AppBar(
        title: Text("GitHub Search"),
        actions: <Widget>[
          IconButton(
            icon: gitHubApi.userAvatarUrl != null
                ? Image.network(gitHubApi.userAvatarUrl!)
                : Icon(Icons.account_circle),
            onPressed: () async {
              await gitHubApi.fetchUserDetails('aquaman1182');
              context.go('/user/${Uri.encodeComponent('aquaman1182')}');
            },
          ),
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
                fillColor: Colors.green[100],
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
                      return ListTile(
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
