class UserEntity {
  final String id;
  final String fullName;
  final String email;
  final String? profileImageUrl; // Nullable لأن المستخدم قد لا يمتلك صورة

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.profileImageUrl,
  });
}