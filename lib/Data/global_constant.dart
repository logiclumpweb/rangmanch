import 'dart:async';

import 'package:flutter/animation.dart';
final int PAUSE = -1;
final int PLAY = -11;
final StreamController<int> videoStatusUpdate = StreamController.broadcast();
late AnimationController animationController;
