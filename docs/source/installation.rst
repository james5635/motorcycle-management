Installation
============

Requirements
------------

* Flutter SDK ^3.8.1
* Android Studio or VS Code
* Android SDK (for Android)
* Xcode (for iOS, macOS only)

Setup
-----

1. Install Dependencies
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   flutter pub get

2. Configure API URL
~~~~~~~~~~~~~~~~~~~~

Edit ``lib/config.dart``:

.. code-block:: dart

   var config = {
     // Android emulator
     "apiUrl": "http://10.0.2.2:8080",
     
     // iOS simulator
     // "apiUrl": "http://localhost:8080",
     
     // Physical device (use your computer's IP)
     // "apiUrl": "http://192.168.1.100:8080",
   };

3. Run the App
~~~~~~~~~~~~~~

Android:

.. code-block:: bash

   flutter run

iOS (macOS only):

.. code-block:: bash

   flutter run

Troubleshooting
---------------

**Build fails**

.. code-block:: bash

   flutter clean
   flutter pub get

**Gradle issues (Android)**

.. code-block:: bash

   cd android
   ./gradlew clean
   cd ..
   flutter run

**iOS CocoaPods issues**

.. code-block:: bash

   cd ios
   rm -rf Pods Podfile.lock
   pod install
   cd ..
