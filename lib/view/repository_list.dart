import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../di/github_api.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({required Key key, required this.title}) : super(key: key);

  final String title;
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GitHubApi gitHubApi = context.read<GitHubApi>();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                gitHubApi.fetchRepositories(textController.text);
              }, 
              child: const Text('Search'),
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
      ),
    );
  }
}
