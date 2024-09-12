import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// CanvasExtension
extension CanvasExtension on Canvas {
  void drawDashedLine(Offset start, Offset end, Paint paint,
      [List<double> dashArray = const [3, 1], double dashOffset = 0]) {
    Path path = Path();
    path.moveTo(start.dx, start.dy);
    path.lineTo(end.dx, end.dy);
    drawDashedPath(path, paint, dashArray, dashOffset);
  }

  void drawDashedPath(Path path, Paint paint,
      [List<double> dashArray = const [3, 1],
      double dashOffset = 0,
      bool drawOdd = false]) {
    Path dashedPath = Path();

    for (var metric in path.computeMetrics()) {
      if (drawOdd && dashOffset > 0) {
        dashedPath.addPath(metric.extractPath(0, dashOffset), Offset.zero);
      }
      double currentPosition = dashOffset;
      int i = 0;
      while (currentPosition < metric.length) {
        double newPosition = (currentPosition + dashArray[i % dashArray.length])
            .clampTop(metric.length);
        if (i % 2 == (drawOdd ? 1 : 0)) {
          dashedPath.addPath(
              metric.extractPath(currentPosition, newPosition), Offset.zero);
        }
        currentPosition = newPosition;
        i++;
      }
    }

    drawPath(dashedPath, paint);
  }
}

/// DoubleExtension
extension DoubleExtension on double {
  Duration get toDuration =>
      Duration(seconds: toInt(), milliseconds: (this % 1 * 1000).toInt());

  double clampBottom(double? lowerLimit) =>
      lowerLimit == null ? this : math.max(this, lowerLimit);

  double clampTop(double? upperLimit) =>
      upperLimit == null ? this : math.min(this, upperLimit);
}

/// IntExtension
extension IntExtension on int {
  Duration get toDuration => Duration(seconds: this);

  int clampBottom(int lowerLimit) => math.max(this, lowerLimit);

  int clampTop(int upperLimit) => math.min(this, upperLimit);
}

/// KeyExtension
extension KeyExtension on GlobalKey {
  Size? get size {
    RenderBox? box = currentContext?.findRenderObject() as RenderBox?;
    return box?.size;
  }

  Offset? get globalOffset {
    RenderBox? box = currentContext?.findRenderObject() as RenderBox?;
    return box?.localToGlobal(Offset.zero);
  }
}

/// ListExtension
class Lists {
  static List<E> filledSafe<E>(int length, E fill, {bool growable = false}) {
    return List.filled(length.clampBottom(0), fill, growable: growable);
  }
}

extension ListExtension<E> on List<E> {
  /// The sublist of this list from [start], inclusive, to [end], exclusive.
  /// if startIndex < 0 -> startIndex = length -1
  /// if endIndex <= startIndex -> []
  /// if endIndex < 0 -> endIndex = length -1
  List<E> sublistSafe(int startIndex, [int? endIndex]) {
    if (startIndex < 0) startIndex = length + startIndex;
    startIndex = startIndex.clamp(0, length);

    if (endIndex != null) {
      // if endIndex == -1 -> endIndex == length - 1
      if (endIndex < 0) {
        endIndex = length + endIndex;
      }

      endIndex = endIndex.clamp(0, length);

      if (endIndex >= 0 && endIndex <= startIndex) return [];
    }

    return sublist(startIndex, endIndex);
  }

  E? removeLastSafe() {
    if (isEmpty) return null;
    return removeLast();
  }

  void removeRangeSafe(int start, int end) {
    start = start.clamp(0, length);
    end = end.clamp(0, length);
    if (start >= end) return;
    removeRange(start, end);
  }
}

extension IterableExtension<E> on Iterable<E> {
  bool get twoOrMore {
    return length > 1;
  }

  /// Returns the last index
  /// -1 if list is empty
  int get lastIndex {
    return length - 1;
  }

  /// Returns the second element
  E get second {
    Iterator<E> it = iterator;
    if (!it.moveNext()) {
      throw StateError('No element');
    }
    if (!it.moveNext()) {
      throw StateError('No element');
    }
    return it.current;
  }

  /// Returns the second to last
  E get secondToLast {
    Iterator<E> it = iterator;
    if (!it.moveNext()) {
      throw StateError('No element');
    }
    E result = it.current;
    if (!it.moveNext()) {
      throw StateError('No element');
    }
    E result2;
    do {
      result2 = result;
      result = it.current;
    } while (it.moveNext());
    return result2;
  }

  /// Returns the first element or null.
  E? get firstOrNull {
    Iterator<E> it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    return it.current;
  }

  /// Returns the second element or null.
  E? get secondOrNull {
    Iterator<E> it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    if (!it.moveNext()) {
      return null;
    }
    return it.current;
  }

  /// Returns the second to last element or null.
  E? get secondToLastOrNull {
    Iterator<E> it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    E? result;
    E? result2;
    do {
      result2 = result;
      result = it.current;
    } while (it.moveNext());
    return result2;
  }

  /// Returns the last element or null.
  E? get lastOrNull {
    Iterator<E> it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    E result;
    do {
      result = it.current;
    } while (it.moveNext());
    return result;
  }

  /// Applies the function [f] to each element of this collection in iteration order.
  void forEachIndex(void Function(int i, E e) f) {
    int i = 0;
    for (E e in this) {
      f(i++, e);
    }
  }

  /// Returns the first element that satisfies the given predicate [test] or null.
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Returns the first element that satisfies the given predicate [test] or defaultValue.
  E firstWhereOr(bool Function(E element) test, E defaultValue) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return defaultValue;
  }

  E? lastWhereOrNull(bool Function(E element) test) {
    late E result;
    bool foundMatching = false;
    for (E element in this) {
      if (test(element)) {
        result = element;
        foundMatching = true;
      }
    }
    if (foundMatching) return result;
    return null;
  }

  /// Returns true if the test is true for at least one element.
  bool containsWhere(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return true;
    }
    return false;
  }

  int numWhere(bool Function(E element) test) {
    int c = 0;
    for (E element in this) {
      if (test(element)) c++;
    }
    return c;
  }

  /// Copies list element wise
  List<E> copy() {
    List<E> newList = [];
    for (E e in this) {
      newList.add(e);
    }
    return newList;
  }

  /// Returns a new list with mapped entries
  List<T> mapToList<T>(T Function(E) map, {bool Function(E)? where}) {
    List<T> newList = [];
    for (E e in this) {
      if (where == null || where(e)) {
        newList.add(map(e));
      }
    }
    return newList;
  }

  /// Returns a new list with mapped entries
  List<T> mapToListWithIndex<T>(T Function(int, E) map,
      {bool Function(E)? where}) {
    List<T> newList = [];
    int i = 0;
    for (E e in this) {
      if (where == null || where(e)) {
        newList.add(map(i++, e));
      }
    }
    return newList;
  }

  String mapAndJoin(String Function(E) map, {String separator = ''}) {
    String str = '';
    bool first = true;
    for (E e in this) {
      if (first) {
        first = false;
      } else {
        str += separator;
      }
      str += map(e);
    }
    return str;
  }

  /// Returns a new list with mapped entries
  List<E> filterList(bool Function(E) where) {
    List<E> newList = [];
    for (E e in this) {
      if (where(e)) {
        newList.add(e);
      }
    }
    return newList;
  }

  /// Returns true if all elements are identical
  bool equalTo(List<E>? otherList) {
    if (otherList == null || length != otherList.length) return false;

    int count = 0;
    for (E e in this) {
      if (e != otherList[count]) return false;
      count++;
    }
    return true;
  }

  int sumInt(int Function(E) getValue) {
    int s = 0;
    for (E e in this) {
      s += getValue(e);
    }
    return s;
  }

  int sumInt1(bool Function(E) condition) {
    int s = 0;
    for (E e in this) {
      if (condition(e)) s += 1;
    }
    return s;
  }

  int? averageInt(int Function(E) getValue, {bool Function(E)? where}) {
    int sum = 0;
    int count = 0;
    for (E e in this) {
      if (where == null || where(e)) {
        sum += getValue(e);
        count++;
      }
    }
    return count == 0 ? null : (sum / count).round();
  }

  int? maxInt(int Function(E) getValue, {bool Function(E)? where}) {
    int maxValue = 0;
    int count = 0;
    for (E e in this) {
      if (where == null || where(e)) {
        if (count == 0) {
          maxValue = getValue(e);
        } else {
          maxValue = math.max(getValue(e), maxValue);
        }
        count++;
      }
    }
    return count == 0 ? null : maxValue;
  }

  double? minDouble(double Function(E) getValue, {bool Function(E)? where}) {
    double minValue = 0;
    int count = 0;
    for (E e in this) {
      if (where == null || where(e)) {
        if (count == 0) {
          minValue = getValue(e);
        } else {
          minValue = math.min(getValue(e), minValue);
        }
        count++;
      }
    }
    return count == 0 ? null : minValue;
  }

  double? maxDouble(double Function(E) getValue, {bool Function(E)? where}) {
    double maxValue = 0;
    int count = 0;
    for (E e in this) {
      if (where == null || where(e)) {
        if (count == 0) {
          maxValue = getValue(e);
        } else {
          maxValue = math.max(getValue(e), maxValue);
        }
        count++;
      }
    }
    return count == 0 ? null : maxValue;
  }

  double sumDouble(double Function(E) getValue, {bool Function(E)? where}) {
    double s = 0;
    for (E e in this) {
      if (where == null || where(e)) {
        s += getValue(e);
      }
    }
    return s;
  }

  double? averageDouble(double Function(E) getValue,
      {bool Function(E)? where}) {
    double sum = 0;
    int count = 0;
    for (E e in this) {
      if (where == null || where(e)) {
        sum += getValue(e);
        count++;
      }
    }
    return count == 0 ? null : sum / count;
  }

  /// return true if every test is true
  bool isTrue(bool Function(E) test, {bool Function(E)? where}) {
    if (isEmpty) return false;
    for (E e in this) {
      if ((where == null || where(e)) && !test(e)) return false;
    }
    return true;
  }

  /// return true if list is not empty and at least one element is true
  bool isOneOrMoreTrue(bool Function(E) test) {
    if (isEmpty) return false;
    for (E e in this) {
      if (test(e)) return true;
    }
    return false;
  }

  /// return false if every test is false
  bool isAllFalse(bool Function(E) test, {bool Function(E)? where}) {
    for (E e in this) {
      if ((where == null || where(e)) && test(e)) return false;
    }
    return true;
  }
}

extension IntIterableExtension on Iterable<int> {
  int get sum {
    int c = 0;
    for (var v in this) {
      c += v;
    }
    return c;
  }
}

extension DoubleIterableExtension on Iterable<double> {
  double get sum {
    double c = 0;
    for (var v in this) {
      c += v;
    }
    return c;
  }
}

/// StringExtension
extension StringExtension on String {
  /// The substring of this string from [start],inclusive, to [end], exclusive.
  /// if endIndex <= startIndex -> ''
  /// if endIndex < 0 -> endIndex = length -1
  String substringSafe(int startIndex, [int? endIndex]) {
    if (startIndex < 0) startIndex = length + startIndex;
    startIndex = startIndex.clamp(0, length);

    if (endIndex != null) {
      // if endIndex == -1 -> endIndex == length - 1
      if (endIndex < 0) {
        endIndex = length + endIndex;
      }

      endIndex = endIndex.clamp(0, length);

      if (endIndex >= 0 && endIndex <= startIndex) return '';
    }

    return substring(startIndex, endIndex);
  }

  /// Returns the last index
  int get lastIndex {
    return length - 1;
  }

  String get first => this[0];

  String get last => this[lastIndex];
}
