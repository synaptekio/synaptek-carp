/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of esense;

/// A [DeviceDescriptor] for an eSense device used in a [StudyProtocol].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ESenseDevice extends DeviceDescriptor {
  /// The type of a eSense device.
  static const String DEVICE_TYPE =
      '${DeviceDescriptor.DEVICE_NAMESPACE}.ESenseDevice';

  /// The default rolename for a eSense device.
  static const String DEFAULT_ROLENAME = 'esense';

  /// The name of the eSense device.
  /// Used for connecting to the eSense hardware device over BTLE.
  /// eSense devices are typically named `eSense-xxxx`.
  String? deviceName;

  /// The sampling rate in Hz of getting sensor data from the device.
  int? samplingRate;

  ESenseDevice({
    String? roleName,
    this.deviceName,
    this.samplingRate,
    List<String>? supportedDataTypes,
  }) : super(
          roleName: roleName ?? DEFAULT_ROLENAME,
          isMasterDevice: false,
          supportedDataTypes: supportedDataTypes,
        );

  Function get fromJsonFunction => _$ESenseDeviceFromJson;
  factory ESenseDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as ESenseDevice;
  Map<String, dynamic> toJson() => _$ESenseDeviceToJson(this);
}

/// A [DeviceManager] for the eSense device.
class ESenseDeviceManager extends DeviceManager {
  // the last known voltage level of the eSense device
  double _voltageLevel = 4;

  /// A handle to the [ESenseManager] plugin.
  ESenseManager? manager;

  @override
  ESenseDevice? get deviceDescriptor => super.deviceDescriptor as ESenseDevice;

  @override
  String get id => deviceDescriptor?.deviceName ?? 'eSense-????';

  @override
  void onInitialize(DeviceDescriptor descriptor) {
    assert(descriptor is ESenseDevice,
        '$runtimeType initialized with a wrong device descriptor of type ${descriptor.runtimeType}');
    assert(
        deviceDescriptor?.deviceName != null &&
            deviceDescriptor!.deviceName!.isNotEmpty,
        'Cannot initialize an $runtimeType with a null or empty device name. '
        "Please specify a valid device name, typically on the form 'eSense-1234'");
  }

  /// A estimate of the battery level of the eSense device.
  ///
  /// It assumes a liniar relationship based on a regression on
  /// these measures:
  ///
  /// ```
  ///   B  |  V
  ///  ----+------
  ///  1.0	| 4.1
  ///  0.8	| 3.9
  ///  0.6	| 3.8
  ///  0.4	| 3.7
  ///  0.2	| 3.4
  ///  0.0  | 3.1
  /// ```
  ///
  /// which gives; `B = 1.19V - 3.91`.
  ///
  /// See e.g. https://en.wikipedia.org/wiki/State_of_charge#Voltage_method
  @override
  int get batteryLevel => ((1.19 * _voltageLevel - 3.91) * 100).toInt();

  @override
  bool canConnect() => status == DeviceStatus.paired;

  @override
  Future<bool> onConnect() async {
    if (deviceDescriptor?.deviceName == null ||
        deviceDescriptor!.deviceName!.isEmpty) return false;

    manager = ESenseManager(id);
    // listen for connection events
    manager?.connectionEvents.listen((event) {
      debug('$runtimeType - $event');

      switch (event.type) {
        case ConnectionType.connected:
          status = DeviceStatus.connected;

          // this is a hack! - don't know why, but the sensorEvents stream
          // needs a kick in the ass to get started...
          manager?.sensorEvents.listen(null);

          // when connected, listen for battery events
          manager!.eSenseEvents
              .where((event) => event is BatteryRead)
              .listen((event) {
            _voltageLevel = (event as BatteryRead).voltage ?? 4;
          });

          // set up a timer that asks for the voltage level
          Timer.periodic(const Duration(minutes: 5), (timer) {
            if (status == DeviceStatus.connected) {
              debug('$runtimeType - requesting voltage...');
              manager?.getBatteryVoltage();
            }
          });
          break;
        case ConnectionType.unknown:
          status = DeviceStatus.unknown;
          break;
        case ConnectionType.device_found:
          status = DeviceStatus.paired;
          break;
        case ConnectionType.device_not_found:
        case ConnectionType.disconnected:
          status = DeviceStatus.disconnected;
          // _eventSubscription?.cancel();
          break;
      }
    });

    // debug('$runtimeType - configuring sampling rate...');
    // await manager?.setSamplingRate(deviceDescriptor?.samplingRate ?? 10);
    debug('$runtimeType - connecting to eSense device, name: $id');
    return await manager?.connect() ?? false;
  }

  @override
  Future<bool> onDisconnect() async => await manager?.disconnect() ?? false;
}
