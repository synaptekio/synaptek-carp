/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core;

// -----------------------------------------------------
// Deployment Service Requests
// See https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/infrastructure/DeploymentServiceRequest.kt
// -----------------------------------------------------

/// A [DeploymentServiceRequest] contains the data for sending a request
/// to the CARP web service.
///
/// All deployment requests to the CARP Service is defined in
/// [carp.core-kotlin](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/carp.deployment.core/src/commonMain/kotlin/dk/cachet/carp/deployment/infrastructure/DeploymentServiceRequest.kt)
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class DeploymentServiceRequest extends Serializable {
  String _infrastructurePackageNamespace =
      'dk.cachet.carp.deployment.infrastructure';
  DeploymentServiceRequest(this.studyDeploymentId) : super();

  /// The CARP study deployment ID.
  String studyDeploymentId;

  Function get fromJsonFunction => _$DeploymentServiceRequestFromJson;
  factory DeploymentServiceRequest.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DeploymentServiceRequestToJson(this);
  String get jsonType => '$_infrastructurePackageNamespace.$runtimeType';

  String toString() => '$runtimeType - studyDeploymentId: $studyDeploymentId';
}

abstract class ParticipationServiceRequest extends DeploymentServiceRequest {
  String _serviceRequestPackageNamespace =
      'dk.cachet.carp.deployment.infrastructure.ParticipationServiceRequest';
  ParticipationServiceRequest(String studyDeploymentId)
      : super(studyDeploymentId);
  String get jsonType => '$_serviceRequestPackageNamespace.$runtimeType';
}

/// A request for getting the deployment invitations for an account id.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class GetActiveParticipationInvitations extends ParticipationServiceRequest {
  GetActiveParticipationInvitations(this.accountId) : super('');

  @JsonKey(ignore: true)
  String studyDeploymentId;

  /// The CARP account (user) ID.
  String accountId;

  Function get fromJsonFunction => _$GetActiveParticipationInvitationsFromJson;
  factory GetActiveParticipationInvitations.fromJson(
          Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() =>
      _$GetActiveParticipationInvitationsToJson(this);

  String toString() => '$runtimeType - accountId: $accountId';
}

/// A request for getting the status of a study deployment.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class GetStudyDeploymentStatus extends ParticipationServiceRequest {
  GetStudyDeploymentStatus(String studyDeploymentId) : super(studyDeploymentId);

  Function get fromJsonFunction => _$GetStudyDeploymentStatusFromJson;
  factory GetStudyDeploymentStatus.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$GetStudyDeploymentStatusToJson(this);
}

/// A request for registering this device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class RegisterDevice extends DeploymentServiceRequest {
  RegisterDevice(
      String studyDeploymentId, this.deviceRoleName, this.registration)
      : super(studyDeploymentId);

  /// The role name of this device.
  String deviceRoleName;

  /// The registration.
  DeviceRegistration registration;

  Function get fromJsonFunction => _$RegisterDeviceFromJson;
  factory RegisterDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$RegisterDeviceToJson(this);

  String toString() => '${super.toString()}, deviceRoleName: $deviceRoleName';
}

/// A request for unregistering this device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class UnregisterDevice extends ParticipationServiceRequest {
  UnregisterDevice(String studyDeploymentId, this.deviceRoleName)
      : super(studyDeploymentId);

  /// The role name of this device.
  String deviceRoleName;

  Function get fromJsonFunction => _$UnregisterDeviceFromJson;
  factory UnregisterDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$UnregisterDeviceToJson(this);

  String toString() => '${super.toString()}, deviceRoleName: $deviceRoleName';
}

/// A request for getting the deployment for this master device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class GetDeviceDeploymentFor extends ParticipationServiceRequest {
  GetDeviceDeploymentFor(String studyDeploymentId, this.masterDeviceRoleName)
      : super(studyDeploymentId);

  /// The role name of this master device.
  String masterDeviceRoleName;

  Function get fromJsonFunction => _$GetDeviceDeploymentForFromJson;
  factory GetDeviceDeploymentFor.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$GetDeviceDeploymentForToJson(this);

  String toString() =>
      '${super.toString()}, masterDeviceRoleName: $masterDeviceRoleName';
}

/// A request for reporting this deployment as successful.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class DeploymentSuccessful extends GetDeviceDeploymentFor {
  DeploymentSuccessful(
    String studyDeploymentId,
    String masterDeviceRoleName,
    this.deviceDeploymentLastUpdateDate,
  ) : super(studyDeploymentId, masterDeviceRoleName) {
    this.deviceDeploymentLastUpdateDate.toUtc();
  }

  /// Timestamp when this was last updated in UTC
  DateTime deviceDeploymentLastUpdateDate;

  Function get fromJsonFunction => _$DeploymentSuccessfulFromJson;
  factory DeploymentSuccessful.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DeploymentSuccessfulToJson(this);

  String toString() =>
      '${super.toString()}, masterDeviceRoleName: $masterDeviceRoleName';
}
