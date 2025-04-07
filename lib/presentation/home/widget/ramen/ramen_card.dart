import 'package:flutter/material.dart';
import 'package:noodle_timer/domain/entity/ramen_entity.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';

class RamenCard extends StatefulWidget {
  final RamenEntity ramen;

  const RamenCard({
    required this.ramen,
    super.key
  });

  @override
  State<RamenCard> createState() => _RamenCardState();
}

class _RamenCardState extends State<RamenCard> {
  bool _isLoading = true;
  bool _hasError = false;
  late final ImageProvider _imageProvider;
  ImageStream? _imageStream;
  ImageStreamListener? _listener;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void dispose() {
    _removeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: NoodleColors.secondaryGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [_buildContent(), if (_isLoading) _buildLoadingIndicator()],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_hasError) {
      return const Center(
        child: Icon(Icons.broken_image, color: Colors.white54, size: 40),
      );
    }

    return Transform.scale(
      scale: 0.8,
      child: Image(image: _imageProvider, fit: BoxFit.cover),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: NoodleColors.primary,
        strokeWidth: 3.0,
      ),
    );
  }

  void _loadImage() {
    _imageProvider = NetworkImage(widget.ramen.imageUrl);
    _removeListeners();

    _listener = ImageStreamListener(
          (ImageInfo image, bool synchronousCall) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = false;
          });
        }
      },
      onError: (Object exception, StackTrace? stackTrace) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
        }
      },
    );

    _imageStream = _imageProvider.resolve(const ImageConfiguration());
    _imageStream?.addListener(_listener!);
  }

  void _removeListeners() {
    if (_imageStream != null && _listener != null) {
      _imageStream?.removeListener(_listener!);
    }
    _listener = null;
    _imageStream = null;
  }
}
