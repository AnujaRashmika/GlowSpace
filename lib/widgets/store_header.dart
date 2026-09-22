import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/colors.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/search/search_screen.dart';
import '../utils/page_transitions.dart';

/// Clean shop header:
/// [Back?] [Logo] -------- [Search] -------- [Login] [Cart]
/// Login + Cart are always pinned to the far right.
class StoreHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final String? pageTitle;
  final bool embedSearch;

  const StoreHeader({
    super.key,
    this.showBack = false,
    this.pageTitle,
    this.embedSearch = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 800;
    final isTablet = width >= 600 && width < 800;
    final auth = context.watch<AuthProvider>();
    final cartCount = context.watch<CartProvider>().itemCount;

    return Material(
      color: AppColors.white,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: 68,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 32 : 12,
              ),
              child: Row(
                children: [
                  // ── LEFT: back + brand ─────────────────────────
                  if (showBack) ...[
                    _HeaderIconButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                  ],
                  _BrandLogo(compact: !isWide),

                  // ── CENTER: search takes remaining space ───────
                  if (embedSearch && isWide) ...[
                    const SizedBox(width: 28),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: _HeaderSearchBar(),
                      ),
                    ),
                    const SizedBox(width: 28),
                  ] else ...[
                    const Spacer(),
                  ],

                  // ── RIGHT: always end-aligned actions ──────────
                  if (embedSearch && !isWide)
                    _HeaderIconButton(
                      icon: Icons.search_rounded,
                      onTap: () => pushFade(context, const SearchScreen()),
                    ),

                  if (isTablet || isWide)
                    _AuthButton(auth: auth)
                  else
                    _HeaderIconButton(
                      icon: auth.isLoggedIn
                          ? Icons.person_rounded
                          : Icons.person_outline_rounded,
                      onTap: () {
                        if (auth.isLoggedIn) {
                          pushFade(context, const ProfileScreen());
                        } else {
                          pushFade(context, const LoginScreen());
                        }
                      },
                    ),

                  const SizedBox(width: 4),
                  _CartButton(
                    count: cartCount,
                    showLabel: isWide || isTablet,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  final bool compact;

  const _BrandLogo({required this.compact});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE91E63), Color(0xFFFF6B9D)],
                ),
                borderRadius: BorderRadius.circular(11),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.spa_rounded, color: Colors.white, size: 20),
            ),
            if (!compact) ...[
              const SizedBox(width: 10),
              Text(
                'GlowSpace',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeaderSearchBar extends StatelessWidget {
  const _HeaderSearchBar();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => pushFade(context, const SearchScreen()),
        child: Container(
          height: 42,
          constraints: const BoxConstraints(maxWidth: 520),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE8E8EA)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(
                Icons.search_rounded,
                size: 20,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Search products, brands...',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    color: Colors.grey.shade500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE91E63), Color(0xFFD81B60)],
                  ),
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(24),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Search',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          child: Icon(icon, size: 22, color: const Color(0xFF333333)),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final AuthProvider auth;

  const _AuthButton({required this.auth});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = auth.isLoggedIn;
    final name = auth.user?.name.trim() ?? '';
    final label = !isLoggedIn
        ? 'Login'
        : (name.isEmpty
            ? (auth.user?.email.split('@').first ?? 'Account')
            : name.split(' ').first);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (isLoggedIn) {
            pushFade(context, const ProfileScreen());
          } else {
            pushFade(context, const LoginScreen());
          }
        },
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE8E8EA)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isLoggedIn ? Icons.person_rounded : Icons.person_outline_rounded,
                size: 20,
                color: const Color(0xFF333333),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  final int count;
  final bool showLabel;

  const _CartButton({required this.count, required this.showLabel});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => pushFade(context, const CartScreen()),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: showLabel ? 12 : 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: AppColors.primary.withValues(alpha: 0.08),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Badge(
                isLabelVisible: count > 0,
                backgroundColor: AppColors.primary,
                smallSize: 16,
                label: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 22,
                  color: AppColors.primary,
                ),
              ),
              if (showLabel) ...[
                const SizedBox(width: 6),
                Text(
                  'Cart',
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
