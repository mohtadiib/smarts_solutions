
import 'package:flutter/material.dart';

import 'authservice.dart';

class LoginPhone extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthService().editPhone((){},context);
  }
}