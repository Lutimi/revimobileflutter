import 'dart:convert';

/* To handle(read/write) complex json in dart */
/* Reference https://dev.to/onmyway133/how-to-resolve-deep-json-object-in-dart-5c5l */
/* Usage:-
    var myjson = '''your strigified json''';
    var jsonObject = DartJson(myjson);
    var jsonObject = DartJson(myjson, customSeperator: '/');
    var newObj = jsonObject.read('Employee.Entitlements.GP.Balance');
    newObj.read('xyz.abc').raw();
    var newObj = jsonObject.read('Employee.Entitlements.GP.Balance', rawData: true); //return rawValues instead of DartJSON object
    jsonObject.read('Employee.Entitlements.GP.Balance', defaultValue: 0);
    jsonObject.read('Dependents.0.Relationship').raw();
    jsonObject.write('Dependents.5.Relationship', 10); //create new segments as object only
    jsonObject.write('Dependents.5.Relationship', {'newKey1': true, 'newKey2': '3'}, appendMode: true); //appendItem if already exists(works on both array and object)
    jsonObject.write('Dependents.5.Relationship', 10, arrayMode: true); //create new segments as array if possible
    jsonObject.write('Dependents.5.Relationship', null, delete: true); //create new segments as object only
    jsonObject.encode(); //encodeJSON object as string
    jsonObject.type();  //check basic return type existing currently
    jsonObject.raw(); //return the raw value of object else it will always be wrapped in a DartJson wrapper. Need always to get values.
    jsonObject.raw('path.to.value'); //return the raw value of object on given path
    jsonObject.isValid(); //if passed string is a valid json
*/
class DartJson {
  dynamic _json;
  String customSeperator;
  bool _isInvalidJson = false;
  final bool isReadOnly;
  static final ThemeAction themeAction = ThemeAction();

  int toInt({dynamic jsMode = true}) =>
      themeAction.toInt(_json, jsMode: jsMode);
  bool toBool({bool isStrict = false}) =>
      themeAction.toBool(_json, isStrict: isStrict);
  List toList() => themeAction.toList(_json);
  double toDouble({dynamic jsMode = true}) =>
      themeAction.toDouble(_json, jsMode: jsMode);
  String toString() => themeAction.toStr(_json);

  /// Constructs a DartJson Object
  /// The constructor accepts any type of object
  /// and if it is a string then tries parsing to JSON object
  /// if parsing fails then marks it as invalid json
  /// a customSeperator can be used to seperate perperties of object
  /// by default the seperator is .(dot)
  DartJson(json, {this.customSeperator: '.', this.isReadOnly: false}) {
    if (json is DartJson) {
      json = json.raw();
    }
    if (json is String) {
      try {
        _json = jsonDecode(json);
      } catch (e) {
        _isInvalidJson = true;
        _json = json;
      }
    } else {
      if (json is! Map<String, dynamic>) {
        _isInvalidJson = true;
      }
      _json = json;
    }
  }

  void forEach(Function fun) {
    if (_json != null) {
      if (_json is Map) {
        (_json as Map).forEach(fun);
      } else if (_json is List) {
        (_json as List).forEach(fun);
      }
    }
  }

  bool isTypeOf<T>() {
    return this._json is T;
  }

  /// If the json/object is a valid Map<String, dynamic>
  bool isValid() {
    return !_isInvalidJson;
  }

  /// If json is a valid Map<String, dynamic> object
  /// then return stringified version else return blank string
  String encode({bool doCatch: true}) {
    try {
      return jsonEncode(_json);
    } catch (e) {
      if (doCatch) {
        return '';
      } else {
        throw e;
      }
    }
  }

  /// Edit json content by defining the path
  /// The path should have the same seperator as defined in the constructor
  /// delete: If some attribute needs to be deleted(false by default)
  /// arrayMode: Try creating array based structure i.e. if integers are passed in path and new object has to created
  ///   then it would be an array (false by default). arrayMode scenario:-
  ///   obj.write('con.2.a', 6, arrayMode: true) -> {'con': [null, null, 'a': 6]}
  ///   obj.write('con.2.a', 6) -> {'con': {'2': {'a': 6}}}
  /// appendMode: If true then try to append Map or List items in existing List or Map, by default false which means
  /// replace with given value(object/array or any other)
  /// onReplace: is a callback function which will be invoke to edit the current value
  DartJson write(String path, newValue,
      {bool delete: false,
      bool arrayMode: false,
      bool appendMode: false,
      Function onReplace}) {
    try {
      if (!isReadOnly && (_json is Map || _json is List)) {
        dynamic current = _json;
        var pathArr = path.split(this.customSeperator);
        int counter = 0;
        for (final segment in pathArr) {
          final maybeInt = int.tryParse(segment);
          var isArray = (maybeInt != null && current is List);
          if (isArray && maybeInt >= current.length) {
            while (maybeInt >= current.length) {
              current.add(null);
            }
          }
          var nextIndex = maybeInt == null || !arrayMode ? segment : maybeInt;
          if (isArray) {
            nextIndex = int.tryParse(nextIndex);
          }
          if (counter == pathArr.length - 1) {
            if (delete) {
              if (maybeInt != null) {
                current[maybeInt] = null;
              } else {
                current.remove(segment);
              }
              return this;
            } else {
              if (onReplace != null) {
                current[nextIndex] = onReplace(current[nextIndex]);
              } else if (appendMode && current[nextIndex] is List) {
                var arr = (current[nextIndex] as List);
                (newValue is List) ? arr.addAll(newValue) : arr.add(newValue);
              } else if (appendMode && current[nextIndex] is Map) {
                var obj = (current[nextIndex] as Map);
                (newValue is Map)
                    ? obj.addAll(newValue)
                    : obj[nextIndex] = newValue;
              } else {
                current[nextIndex] = newValue;
              }
              return this;
            }
          }

          var nextValue = current[nextIndex];

          if ((isArray && current[maybeInt] == null) ||
              (current is Map && current[segment] == null) ||
              (nextValue is! Map && nextValue is! List)) {
            final segmentNext = pathArr[counter + 1];
            final maybeIntNext = int.tryParse(segmentNext);

            if (maybeIntNext != null && arrayMode) {
              current[nextIndex] = List<dynamic>();
            } else {
              current[nextIndex] = Map<String, dynamic>();
            }
          }

          current = current[nextIndex];
          counter++;
        }
      }
    } catch (error) {
      print(error);
    }
    return this;
  }

  DartJson writeAll<K, T>(Map<K, T> newMap, {bool forceCreate = false}) {
    if (newMap != null) {
      if (forceCreate && (_json is! Map || _json == null)) {
        _json = {};
        _isInvalidJson = false;
      }
      (_json as Map).addAll(newMap);
    }
    return this;
  }

  operator [](String key) {
    return raw(of: key);
  }

  /// provide path to read the value, if blank then returned the stored value of current node
  /// defaultValue will be returned if nothing found(by default null)
  /// raw value is returned
  /// caseInSensitive(default false), if true search for keys ignoring case
  dynamic raw<T>({
    String of = '',
    dynamic defaultValue,
    bool caseInSensitive = false,
  }) {
    if (of == '') {
      return (this._json is T ? this._json : null) ?? defaultValue;
    }
    try {
      if (_json is! Map && _json is! List) {
        return (defaultValue);
      }
      dynamic current = _json;
      var pathArr = of.split(this.customSeperator);
      for (final segment in pathArr) {
        final maybeInt = int.tryParse(segment);
        if (maybeInt != null && current is List<dynamic>) {
          current = current.length <= maybeInt ? null : current[maybeInt];
        } else if (current is Map) {
          if (caseInSensitive && current[segment] == null) {
            var lowerSegment = segment.toLowerCase();
            current = current[(current as Map).keys.firstWhere(
                (key) => themeAction.toStr(key).toLowerCase() == lowerSegment,
                orElse: () => segment)];
          } else {
            current = current[segment];
          }
        } else {
          current = defaultValue;
          break;
        }
      }
      return ((current is T ? current : null) ?? defaultValue);
    } catch (error) {
      print(error);
      return (defaultValue);
    }
  }

  /// provide path to read the value
  /// defaultValue will be returned if nothing found(by default null)
  /// DartJson wrapped object to perform further operations
  /// caseInSensitive(default false), if true search for keys ignoring case
  DartJson read(
    String path, {
    dynamic defaultValue,
    bool caseInSensitive = false,
  }) {
    return DartJson(this.raw(
      of: path,
      defaultValue: defaultValue,
      caseInSensitive: caseInSensitive,
    ));
  }
}

class ThemeAction {
  bool isNullOrEmpty(value) {
    if (value == null) {
      return true;
    } else if (value is List || value is Map || value is String) {
      return value.isEmpty;
    } else {
      return false;
    }
  }

  /// Convert to int from int, double, bool, string etc. along with null values
  int toInt(value, {bool jsMode: true}) {
    if (value is num) {
      return value.toInt();
    } else if (value is bool) {
      return value ? 1 : 0;
    } else if (value is String) {
      var i = num.tryParse(value);
      return jsMode ? (value.isEmpty ? 0 : (i ?? 1).toInt()) : (i ?? 0);
    }
    return value == null ? 0 : 1;
  }

  /// Convert to double from int, double, bool, string etc. along with null values
  double toDouble(value, {bool jsMode: true}) {
    if (value is num) {
      return value.toDouble();
    } else if (value is bool) {
      return value ? 1.0 : 0.0;
    } else if (value is String) {
      var i = num.tryParse(value);
      return jsMode
          ? (value.isEmpty ? 0.0 : (i ?? 1.0).toDouble())
          : (i ?? 0.0);
    }
    return value == null ? 0 : 1;
  }

  /// Convert to bool from int, double, bool, string etc. along with null values
  /// Useful while directly using in the if and other conditional statements
  bool toBool(value, {bool isStrict: false}) {
    if (value is num) {
      return value != null && value != 0;
    } else if (value is bool) {
      return value;
    } else if (isStrict && value is List) {
      return value != null && value.length > 0;
    } else if (isStrict && value is Map) {
      return value != null && value.length > 0;
    } else if (value is String) {
      if (value == null || value.isEmpty) {
        return false;
      } else {
        return isStrict
            ? (num.tryParse(value) != 0 && value.toLowerCase() != "false")
            : num.tryParse(value) != 0;
      }
    }
    return value != null;
  }

  List toList(value, {bool forceOnKey = false, String splitKey = ","}) {
    if (value == null) {
      return [];
    } else if (value is Map) {
      return (forceOnKey ? value.keys : value.values).toList();
    } else if (value is List) {
      return value;
    } else if (value is String) {
      return value.split(splitKey);
    } else {
      return [];
    }
  }

  String toStr(value, [String defaultValue]) {
    var retVal = value == null ? '' : value.toString();
    return defaultValue != null && retVal.isEmpty ? defaultValue : retVal;
  }
}

void main() {
  print(DartJson('{"5": [1,3]}').raw(of: '5.1'));
}
