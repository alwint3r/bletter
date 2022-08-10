import 'package:flutter_blue/flutter_blue.dart';

String bluetoothStateToString(BluetoothState? state) {
  if (state == null) {
    return 'not available';
  }

  switch (state) {
    case BluetoothState.unknown:
    case BluetoothState.on:
    case BluetoothState.off:
    case BluetoothState.unavailable:
    case BluetoothState.unauthorized:
      return state.toString().split('.')[1];
    case BluetoothState.turningOff:
      return 'turning off';
    case BluetoothState.turningOn:
      return 'turning on';
  }
}
