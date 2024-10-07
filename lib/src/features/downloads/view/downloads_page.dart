import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shed/src/features/downloads/widgets/aria2c_task_tie.dart';
import 'package:shed/src/providers/providers_index.dart';
import 'package:shed/src/router/routes.dart';

class DownloadsPage extends ConsumerStatefulWidget {
  const DownloadsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends ConsumerState<DownloadsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeTasks =
        ref.watch(aria2cActiveTasksProvider.select((x) => x.value ?? []));
    final stoppedTasks =
        ref.watch(aria2cStoppedTasksProvider.select((x) => x.value ?? []));

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (activeTasks.isNotEmpty)
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: activeTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  final eachDownload = activeTasks[index];
                  return Aria2cTaskTile(
                    task: eachDownload,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ),
            if (stoppedTasks.isNotEmpty)
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: stoppedTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  final eachDownload = stoppedTasks[index];
                  return Aria2cTaskTile(
                    task: eachDownload,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              )
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          /* // ignore: unused_local_variable
          final req = Aria2cRequest.addUrl(
            secret: Env.aria2cSecret,
            urls: [
              'https://file-examples.com/storage/fe36b23e6a66fc0679c1f86/2017/04/file_example_MP4_1920_18MG.mp4'
            ],
          );

          ref.read(aria2cSocketProvider).sendData(request: req); */

          context.pushNamed(
            Routes.add.name,
          );
        },
        child: Text('Downloads'),
      ),
    );
  }
}
