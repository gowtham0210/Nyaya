import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../screens/help_resources_screen.dart';
import '../theme/app_colors.dart';

class NyayaAppBar extends StatefulWidget implements PreferredSizeWidget {
  const NyayaAppBar({
    super.key,
    required this.onNotificationTap,
    this.searchController,
    this.onSearchChanged,
    this.searchHint,
  });

  final VoidCallback onNotificationTap;

  /// When provided, a search icon appears next to the notification bell.
  /// Tapping it swaps the logo for an inline search field in the same row.
  /// [onSearchChanged] fires on every keystroke so the caller can filter
  /// its own real data — no fake/sample results are generated here.
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final String? searchHint;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  State<NyayaAppBar> createState() => _NyayaAppBarState();
}

class _NyayaAppBarState extends State<NyayaAppBar> {
  bool _searching = false;

  bool get _hasSearch => widget.searchController != null;

  void _openSearch() => setState(() => _searching = true);

  void _closeSearch() {
    widget.searchController?.clear();
    widget.onSearchChanged?.call('');
    setState(() => _searching = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              if (_searching && _hasSearch) ...[
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.beigeBorder),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        const Icon(Icons.search, size: 18, color: AppColors.muted),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: widget.searchController,
                            onChanged: widget.onSearchChanged,
                            autofocus: true,
                            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              hintText: widget.searchHint ?? tr('label_search'),
                              hintStyle: const TextStyle(fontSize: 13, color: AppColors.muted),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  button: true,
                  label: 'Close search',
                  child: InkWell(
                    onTap: _closeSearch,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.beigeBorder),
                      ),
                      child: const Icon(Icons.close_rounded, color: AppColors.navy, size: 21),
                    ),
                  ),
                ),
              ] else ...[
                Semantics(
                  label: 'NYAYA — Law Basic Quiz App',
                  image: true,
                  child: Image.asset(
                    'assets/images/nyaya_logo.png',
                    height: 42,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                  ),
                ),
                const Spacer(),
                if (_hasSearch) ...[
                  Semantics(
                    button: true,
                    label: 'Search',
                    child: InkWell(
                      onTap: _openSearch,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.beigeBorder),
                        ),
                        child: const Icon(Icons.search, color: AppColors.navy, size: 21),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Semantics(
                  button: true,
                  label: tr('help_res_title'),
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HelpResourcesScreen())),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.beigeBorder),
                      ),
                      child: const Icon(Icons.call_outlined, color: AppColors.navy, size: 21),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Semantics(
                  button: true,
                  label: 'Notifications',
                  child: InkWell(
                    onTap: widget.onNotificationTap,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.beigeBorder),
                      ),
                      child: const Icon(Icons.notifications_none_rounded, color: AppColors.navy, size: 21),
                    ),
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
