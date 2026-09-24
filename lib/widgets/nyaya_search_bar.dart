import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../theme/app_colors.dart';

class NyayaSearchBar extends StatelessWidget {
  const NyayaSearchBar({super.key, this.onTap, this.onFilterTap});

  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Semantics(
        button: true,
        label: 'Search laws, rights and recent updates',
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.beigeBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: AppColors.muted, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tr('search_bar_placeholder'),
                    style: const TextStyle(color: AppColors.muted, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Semantics(
                  button: true,
                  label: 'Filter search',
                  child: InkWell(
                    onTap: onFilterTap,
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.tune, color: AppColors.navy, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
