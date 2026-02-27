import 'package:Balkano/features/auth/domain/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<void> call({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String location,
  }) {
    return repository.signUp(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      location: location,
    );
  }
}
