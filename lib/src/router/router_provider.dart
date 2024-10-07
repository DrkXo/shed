import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shed/src/common/widgets/scaffold_with_navbar.dart';
import 'package:shed/src/features/add_download/view/add_download.dart';
import 'package:shed/src/features/downloads/view/downloads_page.dart';
import 'package:shed/src/features/error/view/error_page.dart';
import 'package:shed/src/features/initialization/view/initialization_page.dart';
import 'package:shed/src/features/settings/view/settings_page.dart';
import 'package:shed/src/providers/providers_index.dart';
import 'package:shed/src/router/modal_page/dialog_page.dart';
import 'package:shed/src/router/routes.dart';
import 'package:shed/src/shed_base_page.dart';
import 'package:shed/src/utils/logger.dart';

part 'router_provider.g.dart';

// ignore: unused_element
final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(RouterRef ref) {
  final isComplete = ref
      .watch(inItNotifierProvider.select((state) => state.value!.isComplete));
  final hasError =
      ref.watch(inItNotifierProvider.select((state) => state.value!.hasError));

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: Routes.loading.path,
    observers: [
      BotToastNavigatorObserver(),
    ],
    redirect: (context, state) {
      // Get the current path
      final currentPath = state.matchedLocation;

      // Log the current path for debugging
      logger.d('Current path: $currentPath');

      if (hasError && currentPath != Routes.error.path) {
        return Routes.error.path;
      } else if (isComplete && currentPath == Routes.error.path) {
        return Routes.downloads.path;
      } else if (isComplete && currentPath == Routes.loading.path) {
        return Routes.downloads.path;
      } else {
        return null;
      }
    },
    routes: <RouteBase>[
      ShellRoute(
        pageBuilder: (
          BuildContext context,
          GoRouterState state,
          Widget child,
        ) {
          return MaterialPage(
            child: ShedBasePage(
              key: state.pageKey,
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            path: Routes.loading.path,
            name: Routes.loading.name,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return MaterialPage(
                maintainState: true,
                child: InitializationPage(),
              );
            },
          ),
          GoRoute(
            path: Routes.error.path,
            name: Routes.error.name,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return MaterialPage(
                maintainState: true,
                child: ErrorPage(),
              );
            },
          ),
          ShellRoute(
            pageBuilder: (
              BuildContext context,
              GoRouterState state,
              Widget child,
            ) {
              return MaterialPage(
                child: ScaffoldWithNavBar(
                  child: child,
                ),
              );
            },
            routes: [
              GoRoute(
                path: Routes.downloads.path,
                name: Routes.downloads.name,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return MaterialPage(
                    maintainState: true,
                    child: DownloadsPage(),
                  );
                },
                routes: [
                  GoRoute(
                    path: Routes.add.path,
                    name: Routes.add.name,
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return DialogPage(
                        builder: (_) => DownloadLinkAdderDialog(),
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: Routes.settings.path,
                name: Routes.settings.name,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return MaterialPage(
                    child: SettingsPage(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
