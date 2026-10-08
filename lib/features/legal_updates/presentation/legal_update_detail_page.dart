import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/localization/l10n.dart';
import 'legal_updates_view_model.dart';
import 'widgets/legal_update_card.dart';

const _pageBackground = NyayaColors.ivory;
const _navy = NyayaColors.ink;
const _imageBackground = NyayaColors.hairline;
const _muted = NyayaColors.inkSubtle;

/// Opens [update]'s detail page (spec 047).
void openLegalUpdate(BuildContext context, LegalUpdate update) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => LegalUpdateDetailPage(update: update),
    ),
  );
}

/// One legal update in full: image, category, title, date, source and the
/// whole summary (spec 047). Tapping the image opens it full screen.
class LegalUpdateDetailPage extends StatelessWidget {
  const LegalUpdateDetailPage({super.key, required this.update});

  final LegalUpdate update;

  @override
  Widget build(BuildContext context) {
    final imageUrl = update.imageUrl;
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        backgroundColor: _pageBackground,
        foregroundColor: _navy,
        surfaceTintColor: Colors.transparent,
        title: Text(
          context.l10n.legalUpdatesTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        key: const ValueKey('legalUpdateDetail.scroll'),
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          if (imageUrl != null) ...[
            _HeaderImage(url: imageUrl, heroTag: _heroTag(update)),
            const SizedBox(height: 16),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: LegalUpdateCategoryPill(category: update.category),
          ),
          const SizedBox(height: 10),
          Text(
            update.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.3,
              color: _navy,
            ),
          ),
          const SizedBox(height: 10),
          LegalUpdateMeta(update: update),
          if (update.summary.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              update.summary,
              style: const TextStyle(fontSize: 15, height: 1.6, color: _navy),
            ),
          ],
        ],
      ),
    );
  }
}

String _heroTag(LegalUpdate update) => 'legalUpdate.image.${update.id}';

/// A 16:9 image; tapping it opens [_ImageViewer].
class _HeaderImage extends StatelessWidget {
  const _HeaderImage({required this.url, required this.heroTag});

  final String url;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.legalUpdateViewImage,
      child: GestureDetector(
        key: const ValueKey('legalUpdateDetail.image'),
        onTap: () => Navigator.of(context).push(
          PageRouteBuilder<void>(
            opaque: false,
            pageBuilder: (_, _, _) => _ImageViewer(url: url, heroTag: heroTag),
            transitionsBuilder: (_, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(NyayaRadii.md),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Hero(
              tag: heroTag,
              child: Image.network(
                url,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : const _ImagePlaceholder(),
                errorBuilder: (_, _, _) =>
                    const _ImagePlaceholder(failed: true),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({this.failed = false});

  final bool failed;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _imageBackground,
      child: Center(
        child: failed
            ? const Icon(Icons.broken_image_outlined, size: 32, color: _muted)
            : const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
      ),
    );
  }
}

/// The image full screen; pinch or double-tap to zoom.
class _ImageViewer extends StatefulWidget {
  const _ImageViewer({required this.url, required this.heroTag});

  final String url;
  final String heroTag;

  @override
  State<_ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<_ImageViewer> {
  final _zoom = TransformationController();
  TapDownDetails? _doubleTap;

  @override
  void dispose() {
    _zoom.dispose();
    super.dispose();
  }

  void _toggleZoom() {
    final position = _doubleTap?.localPosition;
    if (_zoom.value.getMaxScaleOnAxis() > 1 || position == null) {
      _zoom.value = Matrix4.identity();
      return;
    }
    const scale = 2.5;
    _zoom.value = Matrix4.identity()
      ..translateByDouble(
        -position.dx * (scale - 1),
        -position.dy * (scale - 1),
        0,
        1,
      )
      ..scaleByDouble(scale, scale, 1, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('legalUpdateDetail.viewer'),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onDoubleTapDown: (details) => _doubleTap = details,
              onDoubleTap: _toggleZoom,
              child: InteractiveViewer(
                transformationController: _zoom,
                maxScale: 5,
                child: Center(
                  child: Hero(
                    tag: widget.heroTag,
                    child: Image.network(
                      widget.url,
                      fit: BoxFit.contain,
                      excludeFromSemantics: true,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.broken_image_outlined,
                        size: 40,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                key: const ValueKey('legalUpdateDetail.viewer.close'),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                color: Colors.white,
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
