import 'package:Balkano/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/usecases/get_current_user_usecase.dart';
import '../../core/constants/global_values.dart';

class AuthHelper {
  static Future<void> loadCurrentUser() async {
    final client = Supabase.instance.client;

    final datasource = ProfileRemoteDatasource(client);
    final repo = ProfileRepositoryImpl(datasource);
    final usecase = GetCurrentUserUseCase(repo);

    final user = await usecase();

    GlobalValues.currentUser = user;
  }
}
