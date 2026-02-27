abstract class AuthRepository {
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String location,
  });
}
