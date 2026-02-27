import 'package:Balkano/core/constants/app_colors.dart';
import 'package:Balkano/data/models/user.dart';
import 'package:Balkano/features/profile/data/datasource/profile_stats_remote_datasource.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class ProfileHeaderWithStats extends StatefulWidget {
  final User user;
  const ProfileHeaderWithStats({super.key, required this.user});

  @override
  State<ProfileHeaderWithStats> createState() => _ProfileHeaderWithStatsState();
}

class _ProfileHeaderWithStatsState extends State<ProfileHeaderWithStats> {
  int _activeListings = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final datasource = ProfileStatsRemoteDatasource(Supabase.instance.client);

    final count = await datasource.getMyActiveListingsCount();

    if (!mounted) return;

    setState(() {
      _activeListings = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 16),
      decoration: const BoxDecoration(
        color: AppColors.darkHeader,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          /// Avatar
          widget.user.profileImageUrl != null
              ? CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(widget.user.profileImageUrl!),
                )
              : const CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white, size: 35),
                ),

          const SizedBox(height: 8),

          Text(
            widget.user.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            "Member since ${widget.user.registerDate.substring(0, 10)}",
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),

          const SizedBox(height: 12),

          /// Stats inside header
          Row(
            children: [
              _StatItem(
                value: _activeListings.toString(),

                label: "active_listings".tr(),
              ),

              const SizedBox(width: 12),

              _StatItem(
                value: widget.user.salesCount.toString(),
                label: "sold_items".tr(),
              ),

              const SizedBox(width: 12),

              _StatItem(
                value: widget.user.rating.toString(),
                label: "${widget.user.reviewsCount} reviews",
                showStar: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final bool showStar;

  const _StatItem({
    required this.value,
    required this.label,
    this.showStar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.statCard,
          border: Border.all(color: Colors.grey[700]!, width: 2),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            bottomRight: Radius.circular(14),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showStar)
                  const Icon(Icons.star, color: Colors.amber, size: 16),

                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 3),

            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
