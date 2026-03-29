import 'package:taskflow/Core/Utils/api_service.dart';
import 'package:taskflow/Features/Auth/Data/Models/user_model.dart';
import 'package:taskflow/Features/Auth/Domain/Entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<(UserModel, String)> login(String email, String password);

  Future<UserEntity> register(
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

    if (response is! Map) {
      throw const FormatException('Invalid login response');
    }
    if (response['success'] != true) {
      throw const FormatException('Login was not successful');
    }

    final rawData = response['data'];
    if (rawData is! Map) {
      throw const FormatException('Missing login data');
    }
    final responseData = Map<String, dynamic>.from(rawData);

    final userValue = responseData['user'];
    if (userValue is! Map) {
      throw const FormatException('Missing user in login response');
    }
    final userRaw = Map<String, dynamic>.from(userValue);

    final token = responseData['accessToken'];
    if (token is! String || token.trim().isEmpty) {
      throw const FormatException('Missing access token');
    }

    final userData = UserModel.fromJson(userRaw);
    return (userData, token);
  }

  @override
  Future<UserEntity> register(
    String firstname,
    String lastname,
    String email,
    String password,
  ) async {
    final response = await _apiService.postData(
      endpoint: "auth/register",
      data: {
        "firstName": firstname,
        "lastName": lastname,
        "email": email,
        "password": password,
      },
    );

    if (response is! Map) {
      throw const FormatException('Invalid registration response');
    }
    if (response['success'] != true) {
      throw const FormatException('Registration was not successful');
    }

    final rawData = response['data'];
    if (rawData is! Map) {
      throw const FormatException('Missing registration data');
    }
    final responseData = Map<String, dynamic>.from(rawData);

    return UserModel.fromRegisterApi(
      responseData,
      firstName: firstname,
      lastName: lastname,
    );
  }
}
