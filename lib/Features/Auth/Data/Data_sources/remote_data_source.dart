import 'package:taskflow/Core/Utils/api_service.dart';
import 'package:taskflow/Features/Auth/Data/Models/user_model.dart';

abstract class AuthRemoteDataSource {
  // here we return a Tuple containing both the UserModel and the token, so we can cache them together in the Repo layer
  Future<(UserModel, String)> login(String email, String password);

  Future<(UserModel, String)> register(
    String firstname,
    String lastname,
    String email,
    String password,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<(UserModel, String)> login(String email, String password) async {
    final response = await _apiService.postData(
      endpoint: "auth/login",
      data: {"email": email, "password": password},
    );

    // 👈 1. الدخول إلى صندوق الـ "data" الرئيسي
    final responseData = response['data'];
    
    // 👈 2. استخراج كائن المستخدم من داخل مفتاح "user"
    final userData = UserModel.fromJson(responseData['user']);
    
    // 👈 3. استخراج التوكن باسمه الصحيح "accessToken"
    final String token = responseData['accessToken'];

    return (userData, token);
  }

  @override
  Future<(UserModel, String)> register(
    String firstname,
    String lastname,
    String email,
    String password,
  ) async {
    final response = await _apiService.postData(
      endpoint: "auth/register",
      data: {"firstname": firstname, "lastname": lastname, "email": email, "password": password},
    );

    // 👈 تطبيق نفس المنطق الصحيح في شاشة التسجيل (لأن السيرفر سيرد بنفس الهيكلة غالباً)
    final responseData = response['data'];
    final userData = UserModel.fromJson(responseData['user']);
    final String token = responseData['accessToken'];
    
    return (userData, token);
  }
}