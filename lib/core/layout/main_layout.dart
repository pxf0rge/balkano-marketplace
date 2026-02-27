import 'package:Balkano/core/constants/global_values.dart';
import 'package:Balkano/features/listing/presentation/pages/create_listing_page.dart';
import 'package:Balkano/features/profile/presentation/pages/profile_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../features/marketplace/presentation/pages/marketplace_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/chat/presentation/pages/conversations.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  DateTime? _lastBackPress;
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const MarketplacePage(),
      const SearchPage(),
      const MessagesPage(),
      ProfilePage(user: GlobalValues.currentUser!),
      const CreateListingPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvoked: (didPop) {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return;
        }

        final now = DateTime.now();

        if (_lastBackPress == null ||
            now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
          _lastBackPress = now;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Press back again to exit"),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        body: _pages[_currentIndex],
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SizedBox(
            height: 70,
            width: 70,
            child: FloatingActionButton(
              elevation: 4,
              backgroundColor: const Color(0xFF1E293B),
              foregroundColor: Colors.white,
              onPressed: () => setState(() => _currentIndex = 4),
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: 32),
            ),
          ),
        ),

        bottomNavigationBar: SafeArea(
          child: CustomBottomNavBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final house = PhosphorIcons.house();
  final search = PhosphorIcons.magnifyingGlass();
  final chat = PhosphorIcons.chatCircle();
  final user = PhosphorIcons.user();

  final houseFilled = PhosphorIcons.house(PhosphorIconsStyle.fill);
  final searchFilled = PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.fill);
  final chatFilled = PhosphorIcons.chatCircle(PhosphorIconsStyle.fill);
  final userFilled = PhosphorIcons.user(PhosphorIconsStyle.fill);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(double.infinity, 65),
            painter: BottomNavPainter(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _item(house, houseFilled, "nav_home", 0),
              _item(search, searchFilled, "nav_search", 1),

              const SizedBox(width: 70), // فضای FAB

              _item(chat, chatFilled, "nav_chat", 2),
              _item(user, userFilled, "nav_profile", 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item(IconData icon, IconData activeIcon, String labelKey, int index) {
    final active = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? activeIcon : icon,
              size: 24,
              color: active ? const Color(0xFF1E293B) : Colors.grey,
            ),
            const SizedBox(height: 2),
            Text(
              labelKey.tr(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: active ? const Color(0xFF1E293B) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // ---------- FILL ----------
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5);

    // ---------- BORDER ----------
    final borderPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width * 0.35, 0);

    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.42, 15);

    path.arcToPoint(
      Offset(size.width * 0.58, 15),
      radius: const Radius.circular(40),
      clockwise: false,
    );

    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, fillPaint);

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
