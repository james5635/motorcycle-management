Authentication
==============

Screens
-------

**start.dart** - Landing page

* Login button → ``/login``
* Create Account button → ``/user``

**login.dart** - Login form

Fields:

* Username (TextFormField with validation)
* Password (TextFormField with obscure toggle)

Validation:

* Username: required
* Password: required, min 6 characters

**user.dart** - Registration form

Fields:

* Full Name (required, min 2 chars)
* Password (required, min 6 chars)
* Email (required, valid format)
* Phone Number (required, valid format)
* Address (required, min 5 chars)
* Role (dropdown: customer, admin, guest)
* Profile Image (optional, picked from gallery)

API Endpoints
-------------

**Login**

.. code-block:: dart

   POST /auth/login
   Content-Type: application/json
   
   {
     "username": "user",
     "password": "pass"
   }

**Register**

.. code-block:: dart

   POST /user
   Content-Type: multipart/form-data
   
   Parts:
   - user: JSON string
   - profileImage: file (optional)

User Data Flow
--------------

1. Login/Register returns user data
2. Data passed via navigation arguments
3. Retrieved in ``home.dart`` with ``ModalRoute.of(context)!.settings.arguments``
4. User ID used for orders, profile, etc.

Password Change
---------------

In ``tab/setting.dart``:

* ``ChangePasswordScreen`` widget
* Form with new password and confirm
* PUT request to ``/user/{id}``

Logout
------

Clears navigation stack and returns to ``/start``:

.. code-block:: dart

   Navigator.pushNamedAndRemoveUntil(
     context,
     '/start',
     (_) => false,
   );
