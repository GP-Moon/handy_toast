library handy_toast;

import 'package:context_holder/context_holder.dart';
import 'package:flutter/material.dart';

/**
 * Created by GP
 * 2020/12/01.
 */

/// Toast.
class Toast {
  /// Toast a short time.
  static const int SHORT = 1;

  /// Toast a long time.
  static const int LONG = 2;

  static set defaultStyle(ToastStyle style) {
    _style = style;
  }

  /// Toast a message to screen.
  static void toast(
    dynamic message, {
    ToastStyle? style,
    int duration = Toast.SHORT,
    Gravity gravity = Gravity.bottom,
  }) {
    assert(_supportedMessage(message), 'message type ${message.runtimeType} not supported!!');
    OverlayEntry entry = OverlayEntry(builder: (context) {
      _ToastWidget widget = _ToastWidget(message, style ?? _style, gravity);
      return widget;
    });
    ContextHolder.currentOverlay.insert(entry);
    Future.delayed(Duration(seconds: duration)).then((value) {
      entry.remove();
    });
  }

  static bool _supportedMessage(dynamic message) {
    return message is String || message is Widget;
  }

  static ToastStyle _style = const ToastStyle();
}

/// Toast style.
class ToastStyle {
  /// Toast background color.
  final Color color;

  /// Toast background corner radius.
  final double radius;

  /// Toast background border.
  final Border? border;

  /// Toast background padding.
  final EdgeInsets padding;

  /// Toast text style.
  final TextStyle style;

  const ToastStyle({
    this.color = Colors.black54,
    this.radius = 10.0,
    this.border,
    this.padding = const EdgeInsets.only(
      top: 2.0,
      bottom: 2.0,
      left: 5.0,
      right: 5.0,
    ),
    this.style = const TextStyle(
      fontSize: 15.0,
      color: Colors.white,
      decoration: TextDecoration.none,
    ),
  });
}

/// Toast gravity.
enum Gravity {
  /// Toast at top of the screen.
  top,

  /// Toast at center of the screen.
  center,

  /// Toast at bottom of the screen.
  bottom,
}

/// String extension function for toast.
extension ToastableString on String {
  void toast({
    ToastStyle? style,
    int duration = 1,
    Gravity gravity = Gravity.bottom,
  }) {
    Toast.toast(
      this,
      duration: duration,
      style: style,
      gravity: gravity,
    );
  }
}

/// Widget extension function for toast.
extension ToastableWidget on Widget {
  void toast({
    ToastStyle? style,
    int duration = 1,
    Gravity gravity = Gravity.bottom,
  }) {
    Toast.toast(
      this,
      duration: duration,
      style: style,
      gravity: gravity,
    );
  }
}

/// Toast widget.
class _ToastWidget extends StatelessWidget {
  _ToastWidget(
    this._message,
    this._style,
    this._gravity,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(50.0),
      alignment: gravity,
      child: Container(
        padding: _style.padding,
        decoration: BoxDecoration(
          color: _style.color,
          border: _style.border,
          borderRadius: BorderRadius.circular(_style.radius),
        ),
        child: message,
      ),
    );
  }

  dynamic get message {
    if (this._message is Widget) return this._message;
    String _message = this._message.runtimeType == String ? this._message : '???';
    return Text(
      _message,
      softWrap: true,
      style: _style.style,
    );
  }

  Alignment get gravity {
    switch (_gravity) {
      case Gravity.top:
        return Alignment.topCenter;
      case Gravity.center:
        return Alignment.center;
      case Gravity.bottom:
      default:
        return Alignment.bottomCenter;
    }
  }

  final dynamic _message;
  final ToastStyle _style;
  final Gravity _gravity;
}
