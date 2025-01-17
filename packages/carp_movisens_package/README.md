# CARP Movisens Sampling Package

This library contains a sampling package for sampling data from the [Movisens Move4 and ECGMove4 devices](https://www.movisens.com/en/products/ecg-sensor/) to work with
the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package.
This packages supports sampling of the following [`Measure`](https://pub.dev/documentation/carp_core/latest/carp_core_protocols/Measure-class.html) type:

* `dk.cachet.carp.movisens`

See the [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki) for further documentation, particularly on available [measure types](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types).
See the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app) for an example of how to build a mobile sensing app in Flutter.

When running, the `MovisensProbe` in this package returns different [`MovisensDatum`](https://pub.dev/documentation/carp_movisens_package/latest/movisens/MovisensDatum-class.html) formats (note that the package defines its own namespace of `dk.cachet.carp.movisens`):

* `dk.cachet.carp.movisens.met_level`
* `dk.cachet.carp.movisens.met`
* `dk.cachet.carp.movisens.hr`
* `dk.cachet.carp.movisens.hrv`
* `dk.cachet.carp.movisens.is_hrv_valid`
* `dk.cachet.carp.movisens.body_position`
* `dk.cachet.carp.movisens.step_count`
* `dk.cachet.carp.movisens.movement_acceleration`
* `dk.cachet.carp.movisens.tap_marker`
* `dk.cachet.carp.movisens.battery_level`
* `dk.cachet.carp.movisens.connection_status`

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter).

If you're interested in writing you own sampling packages for CARP, see the description on
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/4.-Extending-CARP-Mobile-Sensing) CARP on the wiki.

## Installing

To use this package, add the following to you `pubspc.yaml` file. Note that
this package only works together with `carp_mobile_sensing`.

`````dart
dependencies:
  carp_core: ^latest
  carp_mobile_sensing: ^latest
  carp_movisens_package: ^latest
  ...
`````

### Android Integration

Add the following to your app's `manifest.xml` file located in `android/app/src/main`:

````xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="<your_package_name>"
    xmlns:tools="http://schemas.android.com/tools">

   ...
   
   <!-- The following permissions are used for CARP Mobile Sensing -->
   <uses-permission android:name="android.permission.RECORD_AUDIO"/>
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
   <uses-permission android:name="android.permission.PACKAGE_USAGE_STATS" tools:ignore="ProtectedPermissions"/>
   
   <!--   The following are used for Movisens package  -->
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
   <uses-permission android:name="android.permission.BLUETOOTH" />
   <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
        
   <!--   The following are activity specific to  movisens native Android library  that talks to flutter over platform channel   -->  
   <activity
        android:name="de.kn.uni.smartact.movisenslibrary.screens.view.Activity_BluetoothUser"
        android:configChanges="orientation|keyboardHidden|keyboard"
        android:exported="true"
        android:label="@string/app_name"
        android:launchMode="singleTop"
        android:screenOrientation="portrait">
        <meta-data
            android:name="android.support.PARENT_ACTIVITY"
            android:value="de.kn.uni.smartact.movisenslibrary.screens.view.Activity_BluetoothStart" />
   </activity>  
   <activity
         android:name="de.kn.uni.smartact.movisenslibrary.screens.view.Activity_BluetoothDeviceScan"
         android:configChanges="orientation|keyboardHidden|keyboard"
         android:exported="true"
         android:label="@string/app_name"
         android:launchMode="singleTop"
         android:screenOrientation="portrait">
         <meta-data
             android:name="android.support.PARENT_ACTIVITY"
             android:value="de.kn.uni.smartact.movisenslibrary.screens.view.Activity_BluetoothStart" />
    </activity>   
    <activity
         android:name="de.kn.uni.smartact.movisenslibrary.screens.NoMeasurmentDialog"
         android:configChanges="orientation|keyboardHidden|keyboard"
         android:theme="@style/Theme.AppCompat.Light"
         android:exported="true"
         android:label="@string/app_name"
         android:launchMode="singleTop"
         android:screenOrientation="portrait">
         <meta-data
             android:name="android.support.PARENT_ACTIVITY"
             android:value="de.kn.uni.smartact.movisenslibrary.screens.view.Activity_BluetoothStart" />
    </activity>     
    <activity
         android:name="de.kn.uni.smartact.movisenslibrary.screens.view.Activity_BluetoothData"
         android:configChanges="orientation|keyboardHidden|keyboard"
         android:exported="true"
         android:label="@string/app_name"
         android:launchMode="singleTop"
         android:screenOrientation="portrait">
         <meta-data
             android:name="android.support.PARENT_ACTIVITY"
             android:value="de.kn.uni.smartact.movisenslibrary.screens.view.Activity_BluetoothStart" />
     </activity>     
     <activity
          android:name="de.kn.uni.smartact.movisenslibrary.screens.view.Activity_BluetoothStart"
          android:configChanges="orientation|keyboardHidden|keyboard"
          android:exported="true"
          android:label="@string/app_name"
          android:launchMode="singleTop"
          android:screenOrientation="portrait">
     </activity>
  
     <service android:name="de.kn.uni.smartact.movisenslibrary.bluetooth.MovisensService" />
  
     <receiver android:name="de.kn.uni.smartact.movisenslibrary.reboot.RebootReceiver">
          <intent-filter>
              <action android:name="android.intent.action.BOOT_COMPLETED" />
          </intent-filter>
     </receiver>
</manifest>
````

### iOS Integration

iOS is not supported by Movisens.

## Usage

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:movisens_package/movisens.dart';
`````

Before creating a study and running it, register this package in the
[SamplingPackageRegistry](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry.html).

`````dart
 SamplingPackageRegistry().register(MovisensSamplingPackage());
`````

Once the package is registered, a `MovisensMeasure` can be added to a study protocol like this.

````dart
// register this sampling package before using its measures
SamplingPackageRegistry().register(MovisensSamplingPackage());

// Create a study protocol
StudyProtocol protocol = StudyProtocol(
  ownerId: 'owner@dtu.dk',
  name: 'Context Sensing Example',
);

// define which devices are used for data collection - both phone and MoviSens
Smartphone phone = Smartphone();
DeviceDescriptor movisens = DeviceDescriptor(roleName: 'main_ecg');

protocol
  ..addMasterDevice(phone)
  ..addConnectedDevice(movisens);

// adding a movisens measure
protocol.addTriggeredTask(
  ImmediateTrigger(), // a simple trigger that starts immediately
  AutomaticTask(name: 'Movisens Task')
    ..addMeasure(MovisensMeasure(
        type: MovisensSamplingPackage.MOVISENS,
        name: 'Movisens ECG device',
        description:
           "Collects heart rythm data from the Movisens EcgMove4 sensor",
        enabled: true,
        address: '06-00-00-00-00-00',
        deviceName: "ECG-223",
        height: 178,
        weight: 77,
        age: 32,
        gender: Gender.male,
        sensorLocation: SensorLocation.chest)),
    movisens);
````
