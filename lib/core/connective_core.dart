part of connective;

enum ConnectiveStatus {online, offline}

class Connective {
  final _connectiveStatusController = new StreamController<ConnectiveStatus>.broadcast();
  Stream<ConnectiveStatus> get connectiveStream => _connectiveStatusController.stream;
  StreamSink<ConnectiveStatus> get _connectiveIn => _connectiveStatusController.sink;

  final _connectiveTypeController = new StreamController<ConnectivityResult>.broadcast();
  Stream<ConnectivityResult> get connectiveType => _connectiveTypeController.stream;
  StreamSink<ConnectivityResult> get _connectiveTypeIn => _connectiveTypeController.sink;

  ConnectiveConfiguration _configuration;
  static final Connective _singleton = Connective._();
  Connective._();
  static Connective get instance => _singleton;

  final Connectivity _connectivity = new Connectivity();
  StreamSubscription _connectionSubscribe;

  initialize(ConnectiveConfiguration configuration) {
    _configuration = configuration;
    checkConnective();
    _subscribe();
  }

  _subscribe() {
    _connectionSubscribe = _connectivity.onConnectivityChanged.listen(_handleNetwork);
  }

  _handleNetwork(ConnectivityResult result) {
    _connectiveTypeIn.add(result);
    switch (result) {
      case ConnectivityResult.mobile: {
        _configuration.onMobileData();
        _lookupAddress();
        break;
      }

      case ConnectivityResult.wifi: {
        _configuration.onWifi();
        _lookupAddress();
        break;
      }

      case ConnectivityResult.none: {
        _configuration.onNoNetwork();
        _configuration.whenOffline();
        break;
      }
        
      default: {
        _configuration.onMobileData();
        _lookupAddress();
      }
    }
  }

  Future checkConnective() async {
    final ConnectivityResult result = await _connectivity.checkConnectivity();
    _handleNetwork(result);
  }

  Future _lookupAddress() async {
    try {
      final res = await InternetAddress.lookup(_configuration.url).timeout(_configuration.timeout);
      if(res.isNotEmpty && res[0].rawAddress.isNotEmpty) {
        _connectiveIn.add(ConnectiveStatus.online);
        _configuration.whenOnline();
      } else {
        _connectiveIn.add(ConnectiveStatus.offline);
        _configuration.whenOffline();
        await Future.delayed(_configuration.delay);
        _lookupAddress();
      }
    } catch (e) {
      _connectiveIn.add(ConnectiveStatus.offline);
      _configuration.whenOffline();
      await Future.delayed(_configuration.delay);
      _lookupAddress();
    }
  }

  void dispose() {
    _connectionSubscribe?.cancel();
    _connectiveStatusController?.close();
    _connectiveTypeController?.close();
  }
}