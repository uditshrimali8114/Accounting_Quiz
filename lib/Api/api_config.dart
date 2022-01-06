class ApiConfig {
  @override
  noSuchMethod(Invocation invocation) async {
    return super.noSuchMethod(invocation);
  }

  // final key_auth = 'Authorization';
  final x_api_key = 'x-api-key';
  final x_api_key_value = 'c0fa1bc00534b69726b6d616e20000000722227335444556666c657321a516ea6ea959d6658e';

  final content_type = 'Authorization';
  final content_type_value = 'Basic YXl0YWRtaW46MTIzNDU2Nzg=';
  //final key_auth_value =
  //'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvdGVjaG5vbGl0ZS5pblwvc3RhZ2luZ1wvbWVkaGF2aVwvYXBpXC9sb2dpbiIsImlhdCI6MTYzNjk2NDY4OCwiZXhwIjoxNjM2OTY4Mjg4LCJuYmYiOjE2MzY5NjQ2ODgsImp0aSI6Ilc3cTFieVN5b1NyanRYTUMiLCJzdWIiOjEwLCJwcnYiOiI4N2UwYWYxZWY5ZmQxNTgxMmZkZWM5NzE1M2ExNGUwYjA0NzU0NmFhIn0.kRWE52JhIpMonIgmDLBt2bcr1gq4FYgaqIzKsrfrnF8';
  final slider_img_path = "uploads/slider/";

  final employee_expense_img_path = "/uploads/employee_expense/";

  final profile_img_path = "/uploads/employee/";

  String baseurl = "http://44.240.103.45:4009/v1";

  String baseurl_img = "https://technolite.in/staging/easyhomecare/";

  String api_login = "/login";
  String api_verify = "/verify";
  String api_register = "/register";
  String api_profile = "/profile";
  String api_createQuiz = "/create-quiz";
  String api_updateProfile = "/profile-update";
  String api_countries = "/countries";
  String api_states = "/states";
  String api_cities = "/cities";
  String api_contactus = "/contacts";
  String api_forgetPass = "/forgot-password";
  String api_resetPass = "/reset-password";
  String api_label_code = "/labels-code/";
  String api_question_states = "/question-states";
  String api_start_quiz = "/start-quiz";
  String api_create_quiz = "/create-quiz";
  String api_submit_ans = "/submit-quiz";
  String api_complete_quiz = "/complete-quiz";
  String api_get_resultList = "/result";
  String api_post_result = "/result";

  // String api_setting = "setting";
  // String api_forgot_password = "forgot-password";
  //
  // String api_reset_password = "reset-password";
  // String api_change_password = "change-password";
  // String api_dashboard = "get-dashboard";
  // String api_categorylist = "get-category-list";
  // String api_videolistcategorylist = "get-videolist-by-category/";
  // String api_notificationlist = "notification-list";
  // String api_cmspg = "cms/";




  String api_get_all_booking = "getbookings?driver_id=";

  // String api_get_profile = "employee";

  String api_update_profile = "employee_update";
  String api_updated_profile = "employee/";
}
