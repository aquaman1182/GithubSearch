import 'package:anycloud_pre_training/view/repository_datail.dart';
import 'package:anycloud_pre_training/view/repository_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
GoRouter createGoRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: MyHomePage()
        ),
        routes: [
          GoRoute(
            path: 'repository/:name',
            pageBuilder: (context, state) {
              final goRouter = GoRouter.of(context);
              final repositoryName = goRouter.location;

              return MaterialPage(
                key: state.pageKey,
                child: RepositoryDetailPage(repository: {}, repositoryName: repositoryName,)
              );
            },
          ),

        ]
      ),
    ],
  );
}
