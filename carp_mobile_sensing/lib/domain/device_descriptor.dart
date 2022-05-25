/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// An online service which works as a "software device" in a protocol.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class OnlineService extends DeviceDescriptor {
  OnlineService({
    required String roleName,
    List<String>? supportedDataTypes,
  }) : super(
          roleName: roleName,
          isMasterDevice: false,
          supportedDataTypes: supportedDataTypes,
        );

  Function get fromJsonFunction => _$OnlineServiceFromJson;
  factory OnlineService.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as OnlineService;
  Map<String, dynamic> toJson() => _$OnlineServiceToJson(this);
}

// /// Describes any type of device which can be "connected" to this phone.
// ///
// /// This can be a wearable device, a sensor, or internet service (e.g. FitBit API)
// /// that collects data via this phone.
// @JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
// class ConnectableDeviceDescriptor extends DeviceDescriptor {
//   /// The unique device type. For example `esense`.
//   String deviceType;

//   /// A printer-fiendly name of this device.
//   String? name;

//   ConnectableDeviceDescriptor({
//     required this.deviceType,
//     required String roleName,
//     List<String> supportedDataTypes = const [],
//     this.name,
//   }) : super(
//           roleName: roleName,
//           isMasterDevice: false,
//           supportedDataTypes: supportedDataTypes,
//         );

//   /// The list of measures that this device is collecting as part of a
//   /// [StudyProtocol].
//   List<String> collectingMeasureTypes = [];

//   Function get fromJsonFunction => _$ConnectableDeviceDescriptorFromJson;
//   factory ConnectableDeviceDescriptor.fromJson(Map<String, dynamic> json) =>
//       FromJsonFactory().fromJson(json) as ConnectableDeviceDescriptor;
//   Map<String, dynamic> toJson() => _$ConnectableDeviceDescriptorToJson(this);

//   String toString() =>
//       '${super.toString}, deviceType: $deviceType, name: $name';
// }

