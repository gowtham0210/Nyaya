import 'package:flutter/material.dart';

import '../../../../core/localization/l10n.dart';

const _navy = Color(0xFF11233B);
const _gold = Color(0xFFD3A247);
const _supportText = Color(0xFF5E6878);
const _cardBorder = Color(0xFFECE5DB);
const _soonBackground = Color(0xFFFDE8E8);
const _soonText = Color(0xFFD64545);

/// Home's Ask Nyaya card, marked "Soon" until the feature exists (spec 026).
class AskNyayaCard extends StatelessWidget {
  const AskNyayaCard({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      key: const ValueKey('home.askNyaya'),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: _cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        key: const ValueKey('home.askNyaya.button'),
        button: true,
        label:
            '${l10n.homeAskNyayaTitle}, ${l10n.commonSoon}. '
            '${l10n.homeAskNyayaBody}',
        child: InkWell(
          onTap: onPressed,
          child: ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _gold.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.forum_outlined,
                      color: _gold,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              l10n.homeAskNyayaTitle,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: _navy,
                              ),
                            ),
                            DecoratedBox(
                              key: const ValueKey('home.askNyaya.soon'),
                              decoration: BoxDecoration(
                                color: _soonBackground,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                child: Text(
                                  l10n.commonSoon,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: _soonText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.homeAskNyayaBody,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: _supportText,
                          ),
                        ),
                      ],
                    ),
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
