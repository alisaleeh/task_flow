import 'package:taskflow/Core/Utils/api_service.dart';
import 'package:taskflow/Features/Auth/Data/Models/user_model.dart';

abstract class RemoteDataSource {
  // here we return a Tuple containing both the UserModel and the token, so we can cache them together in the Repo layer
  Future<(UserModel, String)> login(String email, String password);

  Future<(UserModel, String)> register(
    String fullName,
    String email,
    String password,
  );
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiService _apiService;

  RemoteDataSourceImpl(this._apiService);

  @override
  Future<(UserModel, String)> login(String email, String password) async {
    final response = await _apiService.postData(
      endpoint: "auth/login",
      data: {"email": email, "password": password},
    );
    final userData = UserModel.fromJson(response['data']);
    final String token = response["data"]["token"];

    return (userData, token);
  }

  @override
  Future<(UserModel, String)> register(
    String fullName,
    String email,
    String password,
  ) async {
    final response = await _apiService.postData(
      endpoint: "auth/register",
      data: {"fullName": fullName, "email": email, "password": password},
    );
    final userData = UserModel.fromJson(response['data']);
    final String token = response["data"]["token"];
    return (userData, token);
  }
}
