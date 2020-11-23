# connective

A package for checking connection periodically and when the network changes

## Purpose

Sometimes our apps need internet so badly, and the user who use our app must have internet connection, so we need to check connection

## Usage

Connective using `connectivity` package to listen on network change and then doing lookup to the address
the usage is pretty simple, just initialize it

```dart
void main() {
  runApp(MyApp());

  String url = "google.com";
  Connective.instance.initialize(ConnectiveConfiguration(
    url,
    delay: Duration(seconds: 2),
    timeout: Duration(seconds: 3),
    onMobileData: () {
      Fluttertoast.showToast(msg: "Mobile Data");
    },
    onWifi: () {
      Fluttertoast.showToast(msg: "Wifi");
    },
    onNoNetwork: () {
      Fluttertoast.showToast(msg: "No network");
    },
    whenOffline: () {
      Fluttertoast.showToast(msg: "Cant connect to $url");
    },
    whenOnline: () {
      Fluttertoast.showToast(msg: "Connected to $url");
    }
  ));
}
```

and voila, now you can monitor your network changes, connectivity and doing callbacks on it.
Happy fluttering, @Cybernetics Core