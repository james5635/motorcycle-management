Troubleshooting
===============

Build Issues
------------

**flutter pub get fails**

.. code-block:: bash

   flutter clean
   rm -f pubspec.lock
   flutter pub get

**Android build fails**

.. code-block:: bash

   cd android
   ./gradlew clean
   cd ..
   flutter pub get
   flutter run

**iOS build fails**

.. code-block:: bash

   cd ios
   rm -rf Pods Podfile.lock
   pod deintegrate
   pod install
   cd ..
   flutter clean
   flutter run

API Issues
----------

**API calls not working**

Check config.dart:

.. code-block:: dart

   // Android emulator
   "apiUrl": "http://10.0.2.2:8080"
   
   // iOS simulator  
   "apiUrl": "http://localhost:8080"
   
   // Physical device
   "apiUrl": "http://YOUR_COMPUTER_IP:8080"

**Images not loading**

Add error builder:

.. code-block:: dart

   Image.network(
     url,
     errorBuilder: (context, error, stackTrace) {
       return Icon(Icons.error);
     },
   )

**CORS errors (web)**

The app uses mobile-specific features (image picker) that don't work on web. Test on mobile emulator or device.

State Issues
------------

**UI not updating**

Ensure listener is set up:

.. code-block:: dart

   @override
   void initState() {
     super.initState();
     controller.addListener(() {
       if (mounted) setState(() {});
     });
   }
   
   @override
   void dispose() {
     controller.removeListener(() {});
     super.dispose();
   }

Common Errors
-------------

**Null check operator on null**

Add null checks:

.. code-block:: dart

   if (data != null) {
     return data.length;
   }
   return 0;

**setState after dispose**

Always check mounted:

.. code-block:: dart

   if (mounted) {
     setState(() {});
   }

**Image picker crashes (iOS)**

Add to ios/Runner/Info.plist:

.. code-block:: xml

   <key>NSPhotoLibraryUsageDescription</key>
   <string>Upload profile and product images</string>
   <key>NSCameraUsageDescription</key>
   <string>Take photos for uploads</string>

Debugging
---------

Enable verbose logging:

.. code-block:: bash

   flutter run -v

View logs:

.. code-block:: bash

   flutter logs

Hot restart during development:

.. code-block:: bash

   Press 'r' in terminal
