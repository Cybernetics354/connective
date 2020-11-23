part of connective;

class ConnectiveConfiguration {
  String url;
  Function whenOnline;
  Function whenOffline;
  Function onMobileData;
  Function onWifi;
  Function onNoNetwork;
  Duration delay;
  Duration timeout;

  ConnectiveConfiguration(this.url, {
    this.whenOffline,
    this.whenOnline,
    this.onMobileData,
    this.onNoNetwork,
    this.onWifi,
    this.delay,
    this.timeout
  });
}