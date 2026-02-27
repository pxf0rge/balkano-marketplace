import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileStatsRemoteDatasource {
  final SupabaseClient client;
  ProfileStatsRemoteDatasource(this.client);

  Future<int> getMyActiveListingsCount() async {
    final uid = client.auth.currentUser!.id;

    final data = await client.from('products').select('id').eq('seller', uid);

    return (data as List).length;
  }
}
