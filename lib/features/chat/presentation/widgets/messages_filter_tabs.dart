import 'package:Balkano/core/constants/app_colors.dart';
import 'package:Balkano/data/enums/message_filter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MessagesFilterTabs extends StatefulWidget {
  final ValueChanged<MessageFilter> onChanged;

  const MessagesFilterTabs({super.key, required this.onChanged});

  @override
  State<MessagesFilterTabs> createState() => _MessagesFilterTabsState();
}

class _MessagesFilterTabsState extends State<MessagesFilterTabs> {
  MessageFilter _selected = MessageFilter.all;

  void _onSelect(MessageFilter filter) {
    setState(() {
      _selected = filter;
    });
    widget.onChanged(filter);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _TabItem(
            title: "filter_all".tr(),
            isActive: _selected == MessageFilter.all,
            onTap: () => _onSelect(MessageFilter.all),
          ),
          _TabItem(
            title: "filter_read".tr(),
            isActive: _selected == MessageFilter.read,
            onTap: () => _onSelect(MessageFilter.read),
          ),
          _TabItem(
            title: "filter_unread".tr(),
            isActive: _selected == MessageFilter.unread,
            onTap: () => _onSelect(MessageFilter.unread),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
