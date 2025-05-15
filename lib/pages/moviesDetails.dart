import 'package:flutter/material.dart';
import 'package:movienest/constante.dart';
import 'package:movienest/models/movie.dart';
import 'package:movienest/pages/data_base.dart';

class MoviesDetails extends StatefulWidget {
  const MoviesDetails({super.key, required this.movie});
  final Movie movie;

  @override
  State<MoviesDetails> createState() => _MoviesDetailsState();
}

class _MoviesDetailsState extends State<MoviesDetails> {
  bool _isFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final isFav = await DBService.isFavorite(widget.movie.id);
      if (mounted) {
        setState(() {
          _isFavorite = isFav;
        });
      }
    } catch (e) {
      debugPrint("Error checking favorite status: $e");
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to check favorite status')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final bool success = _isFavorite
          ? await DBService.removeFavorite(widget.movie.id)
          : await DBService.addFavorite(widget.movie);

      if (success && mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update favorite status')),
        );
      }
    } catch (e) {
      debugPrint("Error toggling favorite: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update favorite status')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF330f3d),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: Container(
              height: 70,
              width: 70,
              margin: const EdgeInsets.only(top: 16, left: 16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFFC68EFD),
                ),
              ),
            ),
            backgroundColor: const Color(0xFF330f3d),
            expandedHeight: 350,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.movie.title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(24),
                  topLeft: Radius.circular(24),
                ),
                child: _buildBackdropImage(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFFC68EFD),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.movie.overview,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackdropImage() {
    final hasValidBackdrop = widget.movie.backDropPath != null &&
        widget.movie.backDropPath.isNotEmpty;

    if (!hasValidBackdrop) {
      return Container(
        color: Colors.grey[800],
        child: const Center(
          child: Icon(Icons.movie, size: 50, color: Colors.white70),
        ),
      );
    }

    return Image.network(
      '${Constante.imagePath}${widget.movie.backDropPath}',
      filterQuality: FilterQuality.high,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        debugPrint("Error loading image: $error");
        return Container(
          color: Colors.grey[800],
          child: const Center(
            child: Icon(Icons.image_not_supported, size: 50, color: Colors.white70),
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[800],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
              color: const Color(0xFFC68EFD),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Release Date: ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFFC68EFD),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Flexible(
                  child: Text(
                    widget.movie.releaseDate ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFFC68EFD),
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.star_rate_rounded,
                color: Colors.amber,
              ),
              Text(
                '${widget.movie.voteAverage.toStringAsFixed(1)}/10',
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFFC68EFD),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: _isLoading ? null : _toggleFavorite,
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isLoading ? Colors.grey : const Color(0xFFC68EFD),
          ),
        )
      ],
    );
  }
  }