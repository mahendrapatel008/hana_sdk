class Strings {
  static const String home = 'Home';
  static const String history = 'History';
  static const String profile = 'Profile';
  static const String shuttleRequest = 'Shuttle Request';
  static const String dispatch = 'Dispatch';
  static const String completedRides = 'Completed Rides';
  static const String setting = 'Setting';
  static const String allRequests = 'All Requests';
  static const String incidents = 'Incidents';
  static const String scheduler = 'Scheduler';
  static const String loginInGotham = 'Log in to Gotham Shuttle';
  static const String loginIn = 'Log in';
  static const String continueWithGoogle = 'Continue With Google';
  static const String currentPickUpTime = 'Current Pick-Up Time';
  static const String dos = 'D/O/S';
  static const String patientName = 'Patient Name';
  static const String companyName = 'Company Name';
  static const String pickUpAddress = 'Pick-Up Address';
  static const String dropOffAddress = 'Drop-Off Address';
  static const String contactInfo = 'Contact Information';
  static const String typeOfVehicle = 'Type Of Vehicle';
  static const String requestNotes = 'Request Notes';
  static const String finalFare = 'Final Fare';
  static const String submittedOn = 'Submitted On';
  static const String submittedBy = 'Submitted By';
  static const String driverCarType = 'Driver Car Type';
  static const String driverMake = 'Driver Make';
  static const String driverModel = 'Driver Model';
  static const String driverColor = 'Driver Color';

  // error handler
  static const String strNoRouteFound = "no_route_found";
  static const String strAppName = "app_name";
  static const String success = "success";
  static const String strBadRequestError = "bad_request_error";
  static const String strNoContent = "no_content";
  static const String strForbiddenError = "forbidden_error";
  static const String strUnauthorizedError = "unauthorized_error";
  static const String strNotFoundError = "not_found_error";
  static const String strConflictError = "conflict_error";
  static const String strInternalServerError = "internal_server_error";
  static const String strUnknownError = "unknown_error";
  static const String strTimeoutError = "timeout_error";
  static const String strDefaultError = "default_error";
  static const String strCacheError = "cache_error";
  static const String strNoInternetError = "no_internet_error";
  static const String strFormatError = "format_error";
}

extension StringExtension on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }

  bool isValidPassword() {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(this);
  }
}
