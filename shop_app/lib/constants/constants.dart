abstract class Api {
  static String database =
      'flutter-training-bbbe2-default-rtdb.asia-southeast1.firebasedatabase.app';
  static String signup =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp';
  static String signin =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword';
}

enum AuthMode { signup, login }

const userDataKey = 'shopApp_userData';
