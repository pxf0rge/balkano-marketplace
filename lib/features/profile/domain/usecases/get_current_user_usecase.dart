import '../../../../data/models/user.dart';
import '../repositories/profile_repository.dart';

class GetCurrentUserUseCase {
  final ProfileRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<User> call() {
    return repository.getCurrentUser();
  }
}
