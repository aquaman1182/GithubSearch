import 'package:anycloud_pre_training/di/github_api.dart';
import 'package:anycloud_pre_training/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async {
  final goRouter = createGoRouter(); // 追加: goRouterを作成

  runApp(
    ChangeNotifierProvider(
      create: (context) => GitHubApi(),
      child: MyApp(goRouter: goRouter),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoRouter goRouter; // 追加: goRouterのフィールド

  MyApp({required this.goRouter}); // 追加: goRouterをコンストラクタで受け取る

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'リポジトリ検索アプリ',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      //下記を追加すると動いた
      routeInformationProvider: goRouter.routeInformationProvider,
      routeInformationParser: goRouter.routeInformationParser,
      routerDelegate: goRouter.routerDelegate,
      debugShowCheckedModeBanner: false,
    );
  }
}
