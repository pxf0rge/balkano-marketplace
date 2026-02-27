import 'package:Balkano/core/constants/global_values.dart';
import 'package:Balkano/data/models/user.dart';
import 'package:Balkano/features/listing/presentation/pages/my_favs_page.dart';
import 'package:Balkano/features/listing/presentation/pages/my_listing_page.dart';
import 'package:Balkano/features/onboarding/presentation/pages/lets_try_screen.dart';
import 'package:Balkano/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:Balkano/features/profile/presentation/pages/privacy_policy_page.dart';
import 'package:Balkano/features/profile/presentation/widgets/profile_header_with_stats.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../widgets/contact_info_card.dart';
import '../widgets/profile_menu_item.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Widget edit = SvgPicture.asset(
    "assets/icons/edit.svg",
    semanticsLabel: "edit_profile".tr(),
  );

  final Widget listing = SvgPicture.asset(
    "assets/icons/listing.svg",
    semanticsLabel: "my_listings".tr(),
  );

  final Widget logoutIcon = SvgPicture.asset(
    width: 32,
    height: 32,
    "assets/icons/logout.svg",
    semanticsLabel: "logout".tr(),
  );

  final Widget privacyIcon = const Row(
    children: [
      SizedBox(width: 7),
      Icon(Icons.privacy_tip_outlined, size: 32),
    ],
  );

  Widget _buildLanguageOption(
    BuildContext context, {
    required String flag,
    required String language,
    required String locale,
  }) {
    final isSelected = context.locale.languageCode == locale;
    return Material(
      child: InkWell(
        onTap: () {
          context.setLocale(Locale(locale));
          setState(() {});
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Colors.blue, width: 2)
                : Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Row(
            children: [
              Text(
                flag,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  language,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.blue : Colors.black87,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.blue, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeaderWithStats(user: widget.user),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ContactInfoCard(user: widget.user),

                      const SizedBox(height: 16),

                      ProfileMenuItem(
                        icon: const Row(
                          children: [
                            SizedBox(width: 7),
                            Icon(Icons.language, size: 32),
                          ],
                        ),
                        text: "change_language".tr(),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: Text(
                                        "change_language".tr(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    _buildLanguageOption(
                                      context,
                                      flag: "🇬🇧",
                                      language: "English",
                                      locale: "en",
                                    ),
                                    const SizedBox(height: 8),
                                    _buildLanguageOption(
                                      context,
                                      flag: "🇭🇷",
                                      language: "Hrvatski",
                                      locale: "hr",
                                    ),
                                    const SizedBox(height: 8),
                                    _buildLanguageOption(
                                      context,
                                      flag: "🇩🇪",
                                      language: "Deutsch",
                                      locale: "de",
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 8),

                      ProfileMenuItem(
                        icon: edit,
                        text: "edit_profile".tr(),
                        onTap: () async {
                          final updatedUser = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfilePage(user: widget.user),
                            ),
                          );

                          if (updatedUser != null) {
                            setState(() {
                              widget.user.updateFrom(updatedUser);
                              GlobalValues.currentUser = updatedUser;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 8),

                      ProfileMenuItem(
                        icon: const Row(
                          children: [
                            SizedBox(width: 7),
                            Icon(Icons.favorite, color: Colors.red, size: 32),
                          ],
                        ),
                        text: "my_favorites".tr(),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyFavsPage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ProfileMenuItem(
                        icon: listing,
                        text: "my_listing".tr(),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyProductsPage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ProfileMenuItem(
                        icon: privacyIcon,
                        text: "privacy_title".tr(),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyPage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      ProfileMenuItem(
                        icon: Row(children: [const SizedBox(width: 7), logoutIcon]),
                        text: "logout".tr(),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: Text("confirm_logout".tr()),
                                content: Text("confirm_logout_message".tr()),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                    },
                                    child: Text("cancel".tr()),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(dialogContext); // close dialog

                                      await Supabase.instance.client.auth.signOut();

                                      if (!mounted) return;

                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (_) => const LetsTryScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    child: Text(
                                      "logout".tr(),
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
