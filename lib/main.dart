import 'package:anycloud_pre_training/di/github_api.dart';
import 'package:anycloud_pre_training/view/repository_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GitHubApi(),
      child: MaterialApp(
        title: 'GitHub Search',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'GitHub Search', key: Key('home-page'),),
      ),
    );
  }
}
