part of 'providers_index.dart';



enum NetworkStatus { connected, disconnected }

@riverpod
class ConnectivityService extends _$ConnectivityService {
  late final Connectivity _connectivity;
  late Stream<ConnectivityResult> _connectivityStream;

  @override
  ConnectivityResult build() {
    _connectivity = Connectivity();
    _connectivityStream =
        _connectivity.onConnectivityChanged.asyncMap((convert) => convert.last);

    // Set up a listener for connectivity changes
    _connectivityStream.listen((ConnectivityResult result) {
      //state = _mapConnectivityResultToStatus(result);
      state = result;
    });

    // Get initial connectivity status
    _checkInitialConnectivity();
    return ConnectivityResult.none;
  }

  // Check the initial connectivity status when the app starts
  Future<void> _checkInitialConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    // state = _mapConnectivityResultToStatus(result.last);
    state = result.last;
  }

  // Convert the connectivity result to NetworkStatus enum
  NetworkStatus mapConnectivityResultToStatus() {
    switch (state) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        return NetworkStatus.connected;
      case ConnectivityResult.none:
      default:
        return NetworkStatus.disconnected;
    }
  }
}