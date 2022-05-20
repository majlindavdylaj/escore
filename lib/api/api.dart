import 'package:flutter/foundation.dart';

class Api {

  static const HOST = kReleaseMode
      ? 'http://192.168.88.28:8000/api'
      : 'http://10.0.2.2:8000/api';

}