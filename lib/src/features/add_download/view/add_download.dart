import 'package:aria2cf/aria2cf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shed/constants/constants.dart';
import 'package:shed/src/providers/providers_index.dart';

part "../controller/url_validator.dart";

class DownloadLinkAdderDialog extends ConsumerStatefulWidget {
  const DownloadLinkAdderDialog({super.key});

  @override
  DownloadLinkAdderDialogState createState() => DownloadLinkAdderDialogState();
}

class DownloadLinkAdderDialogState
    extends ConsumerState<DownloadLinkAdderDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _addDownloadLinks() {
    if (_formKey.currentState?.validate() ?? false) {
      final urls = _urlController.text
          .split(RegExp(r'\s*,\s*')); // Split input by commas

      for (var url in urls) {
        if (url.isNotEmpty) {
          ref.read(aria2cSocketProvider).sendData(
                request: Aria2cRequest.addUrl(
                  secret: Env.aria2cSecret,
                  urls: [url],
                ),
              );
        }
      }

      Navigator.of(context).pop(); // Close dialog after adding the links
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Download Links',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Flexible(
                // Use Flexible or Expanded here
                child: TextFormField(
                  controller: _urlController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    labelText: 'Download URLs (comma-separated)',
                    border: OutlineInputBorder(),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: urlValidator,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _addDownloadLinks,
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
