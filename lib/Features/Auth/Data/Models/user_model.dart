import 'package:taskflow/Features/Auth/Domain/Entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // 1. استخدمنا toString() مع الـ id لأنه أحياناً يأتي من السيرفر كـ int (رقم) وأحياناً String
      id: json['id']?.toString() ?? '0', 
      
      // 2. لاحظ علامة الاستفهام الملاصقة للـ String? 
      email: json['email'] as String? ?? "",
      
      // 3. غالباً السيرفرات ترسل الاسم بصيغة name أو full_name، فوضعت لك احتياطياً للبحث عنهم!
      fullName: (json['fullName'] ?? json['name'] ?? json['full_name']) as String? ?? 'New User', 
      
      // 4. إصلاح علامة الاستفهام هنا أيضاً، مع توقع أسماء أخرى من السيرفر
      profileImageUrl: (json['profileImageUrl'] ?? json['image'] ?? json['profile_image']) as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'profileImageUrl': profileImageUrl,
    };
  }
}