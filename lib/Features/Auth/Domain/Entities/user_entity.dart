class UserEntity {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String? profileImageUrl; // Nullable لأن المستخدم قد لا يمتلك صورة

  const UserEntity({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    this.profileImageUrl,
  });
}