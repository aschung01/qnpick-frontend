import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:math' as Math;

Math.Random _random = Math.Random();

String formatPercentage(double val) {
  return getCleanTextFromDouble(val * 100) + '%';
}

String formatNumberFromInt(int number) {
  var f = NumberFormat("###,###", "en_US");
  return f.format(number);
}

String formatNumberFromDouble(double number) {
  var f = NumberFormat("###,###.#", "en_US");
  return f.format(number);
}

String formatNumberFromStr(String number) {
  var f = NumberFormat("###,###", "en_US");
  return f.format(int.parse(number));
}

String getCleanTextFromDouble(num val) {
  if (val % 1 != 0) {
    return formatNumberFromDouble(val.toDouble());
  } else {
    return formatNumberFromInt(val.toInt());
  }
}

String formatDateTimeRawString(String rawString) {
  print(rawString);
  DateTime dt = DateTime.parse(rawString);
  print(dt);
  return DateFormat('MM/dd kk:mm').format(dt);
}

String formatDateRawString(String rawString) {
  print(rawString);
  DateTime dt = DateTime.parse(rawString);
  print(dt);
  return DateFormat('MM/dd').format(dt);
}

String formatCurrentDDay(DateTime dueDate) {
  DateTime now = DateTime.now();

  Duration diff = dueDate.difference(now);
  if (diff.inDays < 1) {
    return "D-Day";
  } else {
    return "D-${diff.inDays}";
  }
}

extension FancyIterable on Iterable<int> {
  int get max => reduce(Math.max);

  int get min => reduce(Math.min);
}

class PhoneNumFormatter extends TextInputFormatter {
  final List<String> masks;
  final String separator;

  PhoneNumFormatter({required this.masks, required this.separator});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    final oldText = oldValue.text;
    String? _separator;
    List<String>? _masks;
    String? _prevMask;
    _separator = (separator.isNotEmpty) ? separator : null;
    if (masks.isNotEmpty) {
      _masks = masks;
      _masks.sort((l, r) => l.length.compareTo(r.length));
      _prevMask = masks[0];
    }

    if (newText.isEmpty ||
        newText.length < oldText.length ||
        _masks == null ||
        _separator == null) {
      return newValue;
    }

    final pasted = (newText.length - oldText.length).abs() > 1;
    final mask = _masks.firstWhere((value) {
      final maskValue = pasted ? value.replaceAll(_separator!, '') : value;
      return newText.length <= maskValue.length;
    }, orElse: () => '');

    if (mask == '') {
      return oldValue;
    }

    final needReset =
        (_prevMask != mask || newText.length - oldText.length > 1);
    _prevMask = mask;

    if (needReset) {
      final text = newText.replaceAll(_separator, '');
      String resetValue = '';
      int sep = 0;

      for (int i = 0; i < text.length; i++) {
        if (mask[i + sep] == _separator) {
          resetValue += _separator;
          ++sep;
        }
        resetValue += text[i];
      }

      return TextEditingValue(
          text: resetValue,
          selection: TextSelection.collapsed(
            offset: resetValue.length,
          ));
    }

    if (newText.length < mask.length &&
        mask[newText.length - 1] == _separator) {
      final text =
          '$oldText$_separator${newText.substring(newText.length - 1)}';
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(
          offset: text.length,
        ),
      );
    }

    return newValue;
  }
}

String returnDueDateOrProgress(String? dueDate, double progress) {
  if (dueDate != null) {
    DateTime due = DateTime.parse(dueDate);
    if (due.difference(DateTime.now()).inDays < 2) {
      return '마감 ' + formatCurrentDDay(due);
    }
  }
  return '진행률 ' + formatPercentage(progress);
}

List getRandomCategories() {
  int _numValues = 3 + _random.nextInt(3);
  List _list = [];
  for (int i = 0; i < _numValues; i++) {
    addRandomIntToList(_list);
  }
  return _list..sort();
}

void addRandomIntToList(List list) {
  int _randomInt = _random.nextInt(26);
  if (!list.contains(_randomInt)) {
    list.add(_randomInt);
  } else {
    addRandomIntToList(list);
  }
}

List getListFromStr(String str) {
  str = str.substring(1, str.length - 1);
  List ls = str.split(',');
  ls = ls.map((tag) {
    if (tag.startsWith(' ')) {
      tag = tag.substring(1);
    }
    if (tag.endsWith(' ')) {
      tag = tag.substring(0, tag.length - 1);
    }
    if (tag.startsWith("'")) {
      tag = tag.substring(1);
    }
    if (tag.endsWith("'")) {
      tag = tag.substring(0, tag.length - 1);
    }
    return tag;
  }).toList();

  return ls;
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = Math.cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * Math.asin(Math.sqrt(a)) * 1000; // in meters
}

double getDistanceBetweenPositions(LatLng pos1, LatLng pos2) {
  return Geolocator.distanceBetween(
      pos1.latitude, pos1.longitude, pos2.latitude, pos2.longitude);
}

bool hasLocationPermission(LocationPermission per) {
  return per == LocationPermission.always ||
      per == LocationPermission.whileInUse;
}
