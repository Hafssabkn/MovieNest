import 'package:flutter/material.dart';
import 'package:movienest/constante.dart';
import 'package:movienest/models/movie.dart';
import 'package:movienest/services/data_base.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_services.dart';

class MoviesDetails extends StatefulWidget {
  const MoviesDetails({super.key, required this.movie});
  final Movie movie;

  @override
  State<MoviesDetails> createState() => _MoviesDetailsState();
}

class _MoviesDetailsState extends State<MoviesDetails> with SingleTickerProviderStateMixin {
  bool _isFavorite = false;
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    DBService.isFavorite(widget.movie.id).then((value) {
      setState(() {
        _isFavorite = value;
        _isLoading = false;
      });
    });
    _animationController.forward();
    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkFavoriteStatus() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final isFav = await DBService.isFavorite(widget.movie.id);
      if (mounted) setState(() => _isFavorite = isFav);
    } catch (e) {
      debugPrint("Error checking favorite status: $e");
      if (mounted) _showErrorSnackbar('Failed to check favorite status');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final bool success = _isFavorite
          ? await DBService.removeFavorite(widget.movie.id)
          : await DBService.addFavorite(widget.movie);

      if (success && mounted) {
        setState(() => _isFavorite = !_isFavorite);
        _showSuccessSnackbar(
          _isFavorite ? 'Added to favorites' : 'Removed from favorites',
        );
      } else if (mounted) {
        _showErrorSnackbar('Failed to update favorite status');
      }
    } catch (e) {
      debugPrint("Error toggling favorite: $e");
      if (mounted) _showErrorSnackbar('Failed to update favorite status');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1B),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar.large(
                  leading: _buildBackButton(),
                  actions: [_buildFavoriteButton()],
                  backgroundColor: Colors.transparent,
                  expandedHeight: 450,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      widget.movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    background: _buildBackdropImage(),
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMovieMetadata(),
                        const SizedBox(height: 25),
                        _buildSectionTitle('Synopsis'),
                        const SizedBox(height: 10),
                        _buildOverviewText(),
                        const SizedBox(height: 25),
                        _buildAdditionalDetails(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Container(
      margin: const EdgeInsets.only(top: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isLoading ? Colors.grey : const Color(0xFFE50914),
          size: 28,
        ),
        onPressed: _isLoading
            ? null
            : () async {
          setState(() => _isLoading = true);

          if (_isFavorite) {
            await DBService.removeFavorite(widget.movie.id);
          } else {
            await DBService.addFavorite(widget.movie);
          }

          setState(() {
            _isFavorite = !_isFavorite;
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isFavorite
                  ? 'Ajouté aux favoris'
                  : 'Retiré des favoris'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackdropImage() {
    if (widget.movie.backDropPath == null || widget.movie.backDropPath.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF330f3d).withOpacity(0.8),
              const Color(0xFF0F0F1B),
            ],
          ),
        ),
        child: const Center(
          child: Icon(Icons.movie, size: 100, color: Colors.white24),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          '${Constante.imagePath}${widget.movie.backDropPath}',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                color: const Color(0xFFE50914),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[900],
            child: const Center(
              child: Icon(Icons.image_not_supported, size: 50, color: Colors.white70),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                const Color(0xFF0F0F1B).withOpacity(0.1),
                const Color(0xFF0F0F1B),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieMetadata() {
    return Column(
      children: [
        // Rating Bar
        RatingBar.builder(
          initialRating: widget.movie.voteAverage / 2,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 28,
          itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {},
          ignoreGestures: true,
        ),
        const SizedBox(height: 8),

        // Release Date and Duration
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMetadataChip(
              icon: Icons.calendar_today,
              text: widget.movie.releaseDate?.substring(0, 4) ?? 'N/A',
            ),
            const SizedBox(width: 15),
            _buildMetadataChip(
              icon: Icons.timer_outlined,
              text: '${(widget.movie.runtime ?? 120) ~/ 60}h ${(widget.movie.runtime ?? 120) % 60}min',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetadataChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildOverviewText() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Text(
        widget.movie.overview,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w400,
          height: 1.6,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildAdditionalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.movie.genres != null && widget.movie.genres!.isNotEmpty)
          _buildDetailSection('Genres', widget.movie.genres!.join(', ')),
        if (widget.movie.originalLanguage != null)
          _buildDetailSection('Original Language', widget.movie.originalLanguage!),
        if (widget.movie.popularity != null)
          _buildDetailSection('Popularity', widget.movie.popularity!.toStringAsFixed(0)),
      ],
    );
  }

  Widget _buildDetailSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Watch Trailer Button
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow, size: 24),
              label: const Text('BANDE-ANNONCE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE50914),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                _launchTrailer(widget.movie.id); // <-- Assure-toi que `movie.id` est correct ici
              },
            ),
          ),
          const SizedBox(width: 15),

          // Add to Watchlist Button
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 24),
              label: const Text('WATCHLIST'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white70),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                // Implement watchlist functionality
              },
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _launchTrailer(int movieId) async {
    final trailer = await ApiService().getTrailer(movieId);

    if (trailer != null && trailer.site == 'YouTube') {
      final url = Uri.parse('https://www.youtube.com/watch?v=${trailer.key}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        print("Impossible d’ouvrir la bande-annonce");
      }
    } else {
      print("Trailer non disponible");
    }
  }
  }

