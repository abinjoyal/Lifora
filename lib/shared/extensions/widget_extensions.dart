import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  /// Wraps widget with uniform padding.
  Widget paddingAll(double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  /// Wraps widget with symmetric horizontal and vertical padding.
  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );

  /// Wraps widget with directional padding.
  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    ),
    child: this,
  );

  /// Centers the widget inside a Center widget.
  Widget centered() => Center(child: this);

  /// Wraps widget in an Expanded widget.
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  /// Wraps widget in a Flexible widget.
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(flex: flex, fit: fit, child: this);

  /// Wraps widget in a SliverToBoxAdapter.
  Widget toSliver() => SliverToBoxAdapter(child: this);
}
