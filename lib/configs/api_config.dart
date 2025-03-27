//setting this variable from main or mainDevelopment file
// APIEnvironment environment = APIEnvironment.development;

class ApiConfig {
  static APIEnvironment environment = APIEnvironment.development;

  static String get domain {
    return environment.domain;
  }

  static String get apiVersionName {
    return '/api/v2';
  } 
  static String get apiVersionNameUploadAndStore {
    return '/api/v1/dynamic/uploadAndStore';
  }
  static String get apiVersionNameLocationContinueousSaving {
    return '/api/v1/dynamic/attendanceSave';
  }

  static String folderName() {
    return 'commune';
  }

  static String profilePicFolderName() {
    return 'commune/profile_pic';
  }

  static String postFolderName() {
    return 'commune/post_pic';
  }

  static String normalFolderName() {
    return 'commune/other_pic';
  }

  // String? get bearerToken {
  //   // var user = await SecureStorageService().getCurrentUser();
  //   var user = SharedPrefs().getCurrentUser;
  //   // if (user == null) {
  //   //   return null;
  //   // }
  //   debugPrint(user.token, wrapWidth: 1024);
  //   log("bearerToken====>${user.token}");
  //   return ("bearer ${user.token ?? ""}");
  // }

  // Common API's
  static String mfindEndpoint = '$domain/api/general/v2/mfind';
  static String commonSubmitEndPoint = '$domain/api/v2/dynamic/submitData';
  static String commonAttendenceEndPoint = '$domain/api/v1/auth/attendance';
  static String commonDeleteEndPoint = '$domain/api/v1/dynamic/data';
  static String dynamicData = '$apiVersionName/dynamic/data';
  static String loginAuth = '$apiVersionName/auth/login/oauth';
  static String loginWithOtp = '$apiVersionName/auth/login/otp';
  static String signupAuth = '$apiVersionName/auth/signup/oauth';
  static String verifyOtp = '$apiVersionName/auth/verify-otp';
  static String refreshToken = '$apiVersionName/auth/refresh-token';
  static String logout = '$apiVersionName/auth/logout';
  static String uploadStoreEndpoint = '$domain/api/uploadAndStore';
  static String addDataEndpoint = '$domain/api/general/adddata';
  static String deleteDataEndpoint = '$domain/api/general/deletedata';

  //auth
  static String get verifyUserEndpoint =>
      'https://crmapi.conscor.com/api/emails/send-otp';
}

enum APIEnvironment {
  development,
  staging,
  production,
}

extension APIEnvironmentDomain on APIEnvironment {
  String get domain {
    switch (this) {
      case APIEnvironment.development:
        // return "http://65.21.185.41:555/api";
        return "https://crmapi.conscor.com";
      case APIEnvironment.staging:
        return "";
      case APIEnvironment.production:
        return "";
    }
  }
}
