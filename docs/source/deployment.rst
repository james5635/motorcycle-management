Deployment
==========

Build APK (Android)
-------------------

Debug build:

.. code-block:: bash

   flutter build apk --debug

Release build:

.. code-block:: bash

   flutter build apk --release

Output: ``build/app/outputs/flutter-apk/app-release.apk``

Build App Bundle (Play Store)
------------------------------

.. code-block:: bash

   flutter build appbundle --release

Output: ``build/app/outputs/bundle/release/app-release.aab``

Build iOS (macOS only)
----------------------

.. code-block:: bash

   flutter build ios --release

Then archive in Xcode and upload to App Store Connect.

Configuration
-------------

Before building:

1. Update version in ``pubspec.yaml``:

   .. code-block:: yaml

      version: 1.0.0+1

2. Update API URL in ``lib/config.dart`` to production:

   .. code-block:: dart

      var config = {
        "apiUrl": "https://your-api.com",
      };

3. Verify icons are set:

   * Android: ``android/app/src/main/res/``
   * iOS: ``ios/Runner/Assets.xcassets/AppIcon.appiconset/``

Signing
-------

Android
~~~~~~~

Create ``android/key.properties``:

.. code-block:: properties

   storePassword=your-password
   keyPassword=your-password
   keyAlias=your-alias
   storeFile=/path/to/keystore.jks

Update ``android/app/build.gradle``:

.. code-block:: groovy

   signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile file(keystoreProperties['storeFile'])
           storePassword keystoreProperties['storePassword']
       }
   }

iOS
~~~

Configure in Xcode:

* Select Runner
* Signing & Capabilities
* Select your team
* Set unique Bundle ID

Troubleshooting
---------------

**Build fails**

.. code-block:: bash

   flutter clean
   flutter pub get

**Android: Gradle issues**

.. code-block:: bash

   cd android
   ./gradlew clean
   cd ..

**iOS: CocoaPods issues**

.. code-block:: bash

   cd ios
   rm -rf Pods Podfile.lock
   pod install
   cd ..
