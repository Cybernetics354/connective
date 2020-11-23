part of connective;

class Connective {
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
        _configuration.whenOnline();
      } else {
        _configuration.whenOffline();
        await Future.delayed(_configuration.delay);
        _lookupAddress();
      }
    } catch (e) {
      _configuration.whenOffline();
      await Future.delayed(_configuration.delay);
      _lookupAddress();
    }
  }

  void dispose() {
    _connectionSubscribe?.cancel();
  }
}