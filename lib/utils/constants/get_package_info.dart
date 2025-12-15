import 'package:package_info_plus/package_info_plus.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/utils/constants/core_prep_paths.dart';


Future<PackageInfo> getPackageInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String buildNumber = packageInfo.buildNumber;
  String appVersion = packageInfo.version;
  String packageName = packageInfo.packageName;
  String appNameFromPackage = packageInfo.appName;

  corePrefs.write(CorePrepPaths.appBuildNumber, buildNumber);
  corePrefs.write(CorePrepPaths.appVersion, appVersion);
  corePrefs.write(CorePrepPaths.packageName, packageName);
  // corePrefs.write("TOKEN", "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MjU1MzYsIm5hbWUiOiJtYWhlbmRyYSBzZW4iLCJwaG9uZSI6Ijk1ODgwMDE2NzUiLCJlbWFpbCI6bnVsbH0.lTj0fri99yd3Z0EJlqtZO_ponr5mr7cAHW_VjO3cGV8");

  // if the package info needed anywhere in the app then access from here
  return packageInfo;
}

class CoreAppInfo {
  static CoreAppInfo? _instance;

  CoreAppInfo._();

  factory CoreAppInfo() {
    _instance ??= CoreAppInfo._();
    return _instance!;
  }

  // App Names
  static const String gradding = "Gradding";
  static const String courseFinder = "Course-Finder";
  static const String collegePredictor = "College-Predictor";
  static const String ieltsPrep = "IELTS-Prep";
  static const String ptePrep = "PTE-Prep";
  static const String accommodation = "Accommodation";

  // Internal fields
  String _appName = '';
  String _packageName = '';
  String _version = '';
  String _buildNumber = '';
  String _coreAppName = '';

  // Getters
  String get appName => _appName;

  String get packageName => _packageName;

  String get version => _version;

  String get buildNumber => _buildNumber;

  String get coreAppName => _coreAppName;

  /// Initializes the CoreAppInfo with values from [PackageInfo].
  Future<void> initialize() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    _appName = packageInfo.appName;
    _packageName = packageInfo.packageName;
    _version = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
    _coreAppName = _getCoreAppName(_packageName);

    // Persist values using GetStorage
    corePrefs.write(CorePrepPaths.appBuildNumber, _buildNumber);
    corePrefs.write(CorePrepPaths.appVersion, _version);
    corePrefs.write(CorePrepPaths.packageName, _packageName);
  }

  /// Optional: get PackageInfo outside of initialization
  static Future<PackageInfo> getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  /// Maps known package names to internal app names
  String _getCoreAppName(String packageName) {
    switch (packageName) {
      case 'com.gradding':
        return gradding;
      case 'com.gradding.finder':
        return courseFinder;
      case 'com.gradding.predictor':
        return collegePredictor;
      case 'com.gradding.ieltsprep':
        return ieltsPrep;
      case 'com.gradding.pteprep':
        return ptePrep;
      case 'com.gradding.homes':
        return accommodation;
      case "com.gradding.pte":
        return ptePrep;
      default:
        return gradding;
    }
  }
}
