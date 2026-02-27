import 'package:Balkano/core/constants/app_colors.dart';
import 'package:Balkano/features/chat/presentation/pages/message_page.dart';
import 'package:Balkano/providers/chat_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactSellerButton extends StatefulWidget {
  final String sellerId;
  final String sellerName;
  final String? sellerAvatar;

  const ContactSellerButton({
    super.key,
    required this.sellerId,
    required this.sellerName,
    this.sellerAvatar,
  });

  @override
  State<ContactSellerButton> createState() => _ContactSellerButtonState();
}

class _ContactSellerButtonState extends State<ContactSellerButton> {
  bool _isLoading = false;

  Future<void> _handleContact(BuildContext context) async {
    if (_isLoading) return;

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    // 🚫 User cannot message himself
    if (currentUserId == widget.sellerId) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("cannot_message_yourself".tr())));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final convid = await context.read<ChatProvider>().getOrCreateConversation(
        widget.sellerId,
      );

      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatPage(
            otherUserId: widget.sellerId,
            conversationId: convid,
            otherUserName: widget.sellerName,
            otherUserAvatar: widget.sellerAvatar,
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("something_went_wrong".tr())));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        onPressed: _isLoading ? null : () => _handleContact(context),
        icon: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.chat_bubble_outline),
        label: Text(_isLoading ? "connecting".tr() : "contact_seller".tr()),
      ),
    );
  }
}
