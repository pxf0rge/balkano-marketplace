import 'package:Balkano/data/models/user.dart';
import 'package:Balkano/features/profile/data/datasource/profile_remote_datasource.dart';

import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<User> getCurrentUser() {
    return remote.getCurrentUserProfile();
  }
}
