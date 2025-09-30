# Flutter Local Notifications Setup Guide

Follow steps below to set up platforms (Android, iOS) to work with [FlutterLocalNotificationService] correctly

## Platform Setup

### Android Setup

#### 1. Update AndroidManifest.xml

Add the following permission to `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- For flutter_local_notifications plugin -->
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

Add the following receivers inside the `<application>` tag:

```xml
<!-- For flutter_local_notifications plugin -->
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
</receiver>
```

#### 2. Update build.gradle.kts

Add the following to `android/app/build.gradle.kts`:

In the `android` block's `defaultConfig`:

```kotlin
// For local notifications to work
isCoreLibraryDesugaringEnabled = true
```

In the `dependencies` block:

```kotlin
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
```

### iOS Setup

#### Update AppDelegate.swift

Add the following line to `ios/Runner/AppDelegate.swift` in the `application` method:

```swift
UNUserNotificationCenter.current().delegate = self
```
