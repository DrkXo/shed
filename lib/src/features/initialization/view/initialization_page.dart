import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shed/src/providers/providers_index.dart';

class InitializationPage extends ConsumerStatefulWidget {
  const InitializationPage({super.key});

  @override
  ConsumerState<InitializationPage> createState() => _InitializationPageState();
}

class _InitializationPageState extends ConsumerState<InitializationPage> {
  @override
  void initState() {
    super.initState();
    // Trigger initialization when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(inItNotifierProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the AsyncValue of the InItNotifier
    final initializationState = ref.watch(inItNotifierProvider);

    return Scaffold(
      body: Center(
        child: initializationState.when(
          // Handle loading state
          loading: () => const CircularProgressIndicator(),

          // Handle error state
          error: (error, stackTrace) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 60),
              const SizedBox(height: 20),
              Text(
                'Initialization failed: ${error.toString()}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  ref.read(inItNotifierProvider.notifier).initialize();
                },
                child: const Text('Retry'),
              ),
            ],
          ),

          // Handle successful data state
          data: (state) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircularProgressIndicator(
                value: state.progress / 4, // Assuming 4 steps
              ),
              const SizedBox(height: 20),
              Text(
                state.messages.isNotEmpty
                    ? state.messages.last
                    : 'Initializing...',
                style: const TextStyle(fontSize: 18),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .then(delay: 200.ms) // baseline=800ms
                  .slide(),
            ],
          ),
        ),
      ),
    );
  }
}
