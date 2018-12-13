/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_backend;

/// An abstract class handling initialization and authentication to CARP.
abstract class CarpDataManager extends AbstractDataManager implements FileDataManagerListener {
  CarpEndPoint carpEndPoint;
  CarpApp _app;
  CarpUser _user;

  FileDataManager fileDataManager;

  CarpDataManager() {}

  @override
  Future initialize(Study study) async {
    super.initialize(study);
    assert(study.dataEndPoint is CarpEndPoint);
    carpEndPoint = study.dataEndPoint as CarpEndPoint;

    if (carpEndPoint.uploadMethod == CarpUploadMethod.FILE) {
      // Create a [FileDataManager] and wrap it.
      fileDataManager = new FileDataManager();
      fileDataManager.addFileDataManagerListener(this);
    }
  }

  Future<CarpApp> get app async {
    if (_app == null) {
      _app = new CarpApp(
          study: study,
          name: carpEndPoint.name,
          uri: Uri.parse(carpEndPoint.uri),
          oauth: OAuthEndPoint(clientID: carpEndPoint.clientId, clientSecret: carpEndPoint.clientSecret));
    }
    return _app;
  }

  Future<CarpUser> get user async {
    if (_user == null) {
      CarpService.configure(await app);
      _user = await CarpService.instance.authenticate(username: carpEndPoint.email, password: carpEndPoint.password);
      print("signed in as " + _user.email + " - uid: " + _user.uid);
    }
    return _user;
  }

  /// Handle upload of data depending on the specified [CarpUploadMethod].
  Future<bool> uploadData(Datum data) async {
    assert(data is CARPDatum);
    await user;

    if (user != null) {
      switch (carpEndPoint.uploadMethod) {
        case CarpUploadMethod.DATA_POINT:
          {
            return (await CarpService.instance
                    .getDataPointReference()
                    .postDataPoint(CARPDataPoint.fromDatum(study.id, study.userId, data)) !=
                null);
          }
        case CarpUploadMethod.BATCH_DATA_POINT:
          {
            throw UnimplementedError;
          }
        case CarpUploadMethod.FILE:
          {
            // Forward to [FileDataManager]
            return fileDataManager.uploadData(data);
          }
        case CarpUploadMethod.OBJECT:
          {
            return (await CarpService.instance.collection('/users').object().setData(json.decode(json.encode(data))) !=
                null);
          }
      }
    }

    return false;
  }

  /// Called by the [FileDataManager]
  Future notify(FileDataManagerEvent event) async {
    print("CarpDataManager : {event: ${event.event}, path : ${event.path}");
    switch (event.event) {
      case FileEvent.created:
        break;
      case FileEvent.closed:
        {
          _uploadFileToCarp(event.path);
          break;
        }
    }
  }

  Future<int> _uploadFileToCarp(String path) async {
    //final String filename = localFilePath.substring(localFilePath.lastIndexOf('/') + 1);

    print("Upload to Firestore started - path : '$path'");

    final File file = File(path);
    final String deviceID = Device.deviceID.toString();
    final String studyID = study.id;
    final String userID = (await user).email;

    final FileUploadTask uploadTask = CarpService.instance
        .getFileStorageReference()
        .upload(file, {'device_id': '$deviceID', 'study_id': '$studyID', 'user_id': '$userID'});

    // await the upload is successful
    CarpFileResponse response = await uploadTask.onComplete;
    int id = response.id;

    print("Upload to Firestore finished - remote id : $id ");
    // then delete the local file.
    file.delete();
    print("File deleted : ${file.path}");

    return id;
  }

  Future close() async {
    return;
  }
}
