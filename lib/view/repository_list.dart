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
      //- ヘッダーを作成して、ログイン中のユーザーのアイコンを表示する - Github API（ `/[user](https://docs.github.com/ja/rest/users/users?apiVersion=2022-11-28#get-the-authenticated-user)` ）を利用する。ヘッダーはすべての画面で表示すること
      appBar: AppBar(
        title: Text("GitHub Search"),
        actions: [
          IconButton(
            //自分のアカウントへ遷移する
            onPressed: () {
              gitHubApi.fetchUserDetails('');
            },
            icon: Icon(Icons.account_circle),
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
                hintText: 'ここに入力してください',
                border: OutlineInputBorder(),
                filled: true,
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
            ),
            ElevatedButton(
              onPressed: () {
                //ボタンを押すと、入力した文字列を検索して、検索結果を表示する
                gitHubApi.fetchRepositories(textController.text);
              },
              child: const Text('Search'),
            ),
            Expanded(
              //検索結果を表示する
              child: Consumer<GitHubApi>(
                builder: (context, gitHubApi, _) => ListView.builder(
                  //検索結果のアイテムをタップしたら、該当リポジトリの詳細（リポジトリ名、オーナーアイコン、プロジェクト言語、Star数、Watcher数、Fork数、Issue数）を表示する
                  //ページネーションを実装する
                  itemCount: gitHubApi.repositories.length,
                  itemBuilder: (ctx, i) => ListTile(
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
                      //詳細画面へ遷移する
                      final repoName =
                          gitHubApi.repositories[i]['name'].toString();
                      context
                          .go('/repository/${Uri.encodeComponent(repoName)}');
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
