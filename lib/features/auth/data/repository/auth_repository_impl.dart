import 'package:Balkano/features/auth/domain/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String location,
  }) {
    return remote.signUp(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      location: location,
    );
  }
}
