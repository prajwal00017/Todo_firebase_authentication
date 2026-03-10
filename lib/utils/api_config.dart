class ApiConfig {
  // Replace with your Firebase Project API Key
  static const String apiKey = 'AIzaSyCmcf4mHYe3vNHJgX6OSDtfpXO6o4-6gSQ';
  
  // Replace with your Firebase Realtime Database URL
  static const String databaseUrl = 'https://todo-app-f7d0f-default-rtdb.firebaseio.com';

  static String get signUpUrl => 
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';
      
  static String get signInUrl => 
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';
}
