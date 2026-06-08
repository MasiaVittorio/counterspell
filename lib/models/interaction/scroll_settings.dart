import 'dart:convert';

import 'package:counter_spell/models/interaction/velocity_drag_update_details.dart';
import 'package:sid_base/sid_base.dart';

class ScrollSettings {
  // how much a full screen scroll gets you
  final double sensitivity;

  final bool applyPreOneBoost;
  final double preOneBoost;
  final bool applyOneTwoDampening;
  final double oneTwoDampening;
  final bool applyVelocityWeight;
  final double speedWeight;

  static const double maxVelocity = 750;

  ScrollSettings({
    this.sensitivity = 7.2,
    this.applyPreOneBoost = true,
    this.preOneBoost = 2,
    this.applyOneTwoDampening = true,
    this.oneTwoDampening = 0.6,
    this.applyVelocityWeight = true,
    this.speedWeight = 0.4,
  });

  double editValue({
    required double value,
    required bool vertical,
    required VelocityDragUpdateDetails details,
    required double screenWidth,
  }) {
    final speed = vertical
        ? details.velocity.pixelsPerSecond.dy
        : details.velocity.pixelsPerSecond.dx;
    final double speedMultiplier = switch (applyVelocityWeight) {
      false => 1,
      true => (speed).abs().rangeMap(
        from: (0, maxVelocity),
        to: (1, 1 + speedWeight),
      ),
    };

    final abs = value.abs();

    final double preOneMultiplier = switch ((applyPreOneBoost, abs)) {
      (true, < 1) => preOneBoost,
      _ => 1,
    };

    final double oneTwoMultiplier = switch ((applyOneTwoDampening, abs)) {
      (true, >= 1 && < 2) => oneTwoDampening,
      _ => 1,
    };

    final delta = vertical ? -details.delta.dy : details.delta.dx;

    return value +
        (delta / screenWidth) *
            sensitivity *
            speedMultiplier *
            preOneMultiplier *
            oneTwoMultiplier;
  }

  ScrollSettings copyWith({
    double? sensitivity,
    bool? applyPreOneBoost,
    double? preOneBoost,
    bool? applyOneTwoDampening,
    double? oneTwoDampening,
    bool? applyVelocityWeight,
    double? speedWeight,
  }) {
    return ScrollSettings(
      sensitivity: sensitivity ?? this.sensitivity,
      applyPreOneBoost: applyPreOneBoost ?? this.applyPreOneBoost,
      preOneBoost: preOneBoost ?? this.preOneBoost,
      applyOneTwoDampening: applyOneTwoDampening ?? this.applyOneTwoDampening,
      oneTwoDampening: oneTwoDampening ?? this.oneTwoDampening,
      applyVelocityWeight: applyVelocityWeight ?? this.applyVelocityWeight,
      speedWeight: speedWeight ?? this.speedWeight,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sensitivity': sensitivity,
      'applyPreOneBoost': applyPreOneBoost,
      'preOneBoost': preOneBoost,
      'applyOneTwoDampening': applyOneTwoDampening,
      'oneTwoDampening': oneTwoDampening,
      'applyVelocityWeight': applyVelocityWeight,
      'speedWeight': speedWeight,
    };
  }

  factory ScrollSettings.fromMap(Map<String, dynamic> map) {
    return ScrollSettings(
      sensitivity: map['sensitivity'] as double,
      applyPreOneBoost: map['applyPreOneBoost'] as bool,
      preOneBoost: map['preOneBoost'] as double,
      applyOneTwoDampening: map['applyOneTwoDampening'] as bool,
      oneTwoDampening: map['oneTwoDampening'] as double,
      applyVelocityWeight: map['applyVelocityWeight'] as bool,
      speedWeight: map['speedWeight'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScrollSettings.fromJson(String source) =>
      ScrollSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ScrollSettings(sensitivity: $sensitivity, applyPreOneBoost: $applyPreOneBoost, preOneBoost: $preOneBoost, applyOneTwoDampening: $applyOneTwoDampening, oneTwoDampening: $oneTwoDampening, applyVelocityWeight: $applyVelocityWeight, speedWeight: $speedWeight)';
  }

  @override
  bool operator ==(covariant ScrollSettings other) {
    if (identical(this, other)) return true;

    return other.sensitivity == sensitivity &&
        other.applyPreOneBoost == applyPreOneBoost &&
        other.preOneBoost == preOneBoost &&
        other.applyOneTwoDampening == applyOneTwoDampening &&
        other.oneTwoDampening == oneTwoDampening &&
        other.applyVelocityWeight == applyVelocityWeight &&
        other.speedWeight == speedWeight;
  }

  @override
  int get hashCode {
    return sensitivity.hashCode ^
        applyPreOneBoost.hashCode ^
        preOneBoost.hashCode ^
        applyOneTwoDampening.hashCode ^
        oneTwoDampening.hashCode ^
        applyVelocityWeight.hashCode ^
        speedWeight.hashCode;
  }
}
