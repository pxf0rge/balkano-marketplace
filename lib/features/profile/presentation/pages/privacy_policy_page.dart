import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "privacy_title".tr(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection("privacy_section_1_title", "privacy_section_1_body"),
            const SizedBox(height: 24),
            _buildSection("privacy_section_2_title", "privacy_section_2_body"),
            const SizedBox(height: 24),
            _buildSection("privacy_section_3_title", "privacy_section_3_body"),
            const SizedBox(height: 24),
            _buildSection("privacy_section_4_title", "privacy_section_4_body"),
            const SizedBox(height: 24),
            _buildSection("privacy_section_5_title", "privacy_section_5_body"),
            const SizedBox(height: 24),
            _buildSection("privacy_section_6_title", "privacy_section_6_body"),
            const SizedBox(height: 24),
            _buildSection("privacy_section_7_title", "privacy_section_7_body"),
            const SizedBox(height: 24),
            _buildSection("privacy_section_8_title", "privacy_section_8_body"),
            const SizedBox(height: 24),
            _buildSection("privacy_section_9_title", "privacy_section_9_body"),
            const SizedBox(height: 24),
            _buildSection(
              "privacy_section_10_title",
              "privacy_section_10_body",
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String titleKey, String bodyKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleKey.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          bodyKey.tr(),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
