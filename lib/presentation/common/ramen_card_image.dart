import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';

class RamenCardImage extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;

  const RamenCardImage({
    required this.imageUrl,
    this.width = 160,
    this.height = 160,
    super.key
  });

  @override
  State<RamenCardImage> createState() => _RamenCardImageState();
}

class _RamenCardImageState extends State<RamenCardImage> {
  bool _isLoading = true;
  bool _hasError = false;
  ImageProvider? _imageProvider;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() {
    final provider = NetworkImage(widget.imageUrl);
    final stream = provider.resolve(const ImageConfiguration());

    final listener = ImageStreamListener(
          (info, _) {
        if (mounted) {
          setState(() {
            _imageProvider = provider;
            _isLoading = false;
            _hasError = false;
          });
        }
      },
      onError: (_, __) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
        }
      },
    );

    stream.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Center(child: Icon(Icons.broken_image, color: NoodleColors.secondaryGray, size: 40));
    }

    if (_isLoading || _imageProvider == null) {
      return const Center(
        child: CircularProgressIndicator(color: NoodleColors.primary, strokeWidth: 2),
      );
    }

    return Transform.scale(
      scale: 0.8,
      child: Image(
        image: _imageProvider!,
        fit: BoxFit.cover,
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}
