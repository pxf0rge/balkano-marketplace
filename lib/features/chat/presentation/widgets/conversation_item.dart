import 'package:Balkano/core/cache/app_cache_manager.dart';
import 'package:Balkano/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ConversationItem extends StatefulWidget {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String? imageUrl;
  final Future<void> Function()? onTap;

  const ConversationItem({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.imageUrl,
    this.unreadCount = 0,
    this.onTap,
  });

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  bool _isLoading = false;

  Future<void> _handleTap() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      if (widget.onTap != null) {
        await widget.onTap!();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 👇 اصلی
        AbsorbPointer(
          absorbing: _isLoading, // 🚫 غیر فعال شدن کلیک
          child: InkWell(
            onTap: _handleTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey,
                    backgroundImage: widget.imageUrl != null
                        ? AppCacheManager.instance.getImage(widget.imageUrl!)
                        : const AssetImage("assets/images/profile.png")
                              as ImageProvider,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (widget.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            widget.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        /// 👇 لایه سفید + لودر
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.6),
              child: const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
