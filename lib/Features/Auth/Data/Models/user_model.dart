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
    return UserModel(
      // 1. استخدمنا toString() مع الـ id لأنه أحياناً يأتي من السيرفر كـ int (رقم) وأحياناً String
      id: json['id']?.toString() ?? '0', 
      
      // 2. لاحظ علامة الاستفهام الملاصقة للـ String? 
      email: json['email'] as String? ?? "",
      
      // 3. إصلاح علامة الاستفهام هنا أيضاً، مع توقع أسماء أخرى من السيرفر
      firstname: json['firstname'] as String? ?? "",
      lastname: json['lastname'] as String? ?? "",
      
      
      // 4. إصلاح علامة الاستفهام هنا أيضاً، مع توقع أسماء أخرى من السيرفر
      profileImageUrl: (json['profileImageUrl'] ?? json['image'] ?? json['profile_image']) as String? ?? "",
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