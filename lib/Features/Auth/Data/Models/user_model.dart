import 'package:taskflow/Features/Auth/Domain/Entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstname,
    required super.lastname,
    super.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final first =
        (json['firstName'] ?? json['firstname']) as String? ?? '';
    final last = (json['lastName'] ?? json['lastname']) as String? ?? '';

    final rawProfile =
        json['profileImageUrl'] ?? json['image'] ?? json['profile_image'];
    final String? profileUrl = rawProfile is String &&
            rawProfile.trim().isNotEmpty
        ? rawProfile.trim()
        : null;

    return UserModel(
      id: json['id']?.toString() ?? '0',
      email: json['email'] as String? ?? '',
      firstname: first,
      lastname: last,
      profileImageUrl: profileUrl,
    );
  }

  /// Register API returns only `id`, `email`, `createdAt` in `data` — names come from the form.
  factory UserModel.fromRegisterApi(
    Map<String, dynamic> data, {
    required String firstName,
    required String lastName,
  }) {
    return UserModel(
      id: data['id']?.toString() ?? '0',
      email: data['email'] as String? ?? '',
      firstname: firstName,
      lastname: lastName,
      profileImageUrl: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'profileImageUrl': profileImageUrl,
    };
  }
}
