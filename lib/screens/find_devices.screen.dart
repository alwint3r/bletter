import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  Future<void> _onRefresh() async {
    var isScanning = await FlutterBlue.instance.isScanning.first;
    if (!isScanning) {
      FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4));
    }
  }

  StreamBuilder<List<ScanResult>> _getScannedDevices() {
    return StreamBuilder<List<ScanResult>>(
      stream: FlutterBlue.instance.scanResults,
      initialData: const [],
      builder: (context, snapshot) {
        return Column(
          children: snapshot.data!
              .where((result) => result.device.name.isNotEmpty)
              .map((result) => ListTile(
                    title: Text(result.device.name),
                    subtitle: Text('${result.rssi} dBm'),
                    // trailing: _getConnectActionButton(result.device),
                  ))
              .toList(),
        );
      },
    );
  }

  StreamBuilder<bool> _getAppBarActions() {
    return StreamBuilder<bool>(
      stream: FlutterBlue.instance.isScanning,
      initialData: false,
      builder: (context, snapshot) {
        TextStyle? style = Theme.of(context)
            .primaryTextTheme
            .button
            ?.copyWith(color: Colors.white);

        if (snapshot.data!) {
          return TextButton(
            child: Text('STOP SCAN', style: style),
            onPressed: () => FlutterBlue.instance.stopScan(),
          );
        }

        return TextButton(
          onPressed: _onRefresh,
          child: Text('START SCAN', style: style),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find BLE Devices'),
        actions: [_getAppBarActions()],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _getScannedDevices(),
                ],
              )),
        ),
      ),
    );
  }
}
