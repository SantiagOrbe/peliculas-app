import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/search/search_delegate.dart';
import 'package:peliculas_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: 
        Row(
          children: const [
            HeroIcon(HeroIcons.film, color: Color(0xFF6C5CE7), size: 28),
            SizedBox(width: 8),
            Text('CineApp'),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MovieSearchDelegate(),
                );
              },
              icon: const Icon(Icons.search_rounded, color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Tarjetas principales
            CardSwiper(movies: moviesProvider.onDisplayMovies),

            const SizedBox(height: 20),

            // Slider de populares
            MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Popular ahora',
              icon: Icons.local_fire_department_rounded,
              iconColor: Colors.orangeAccent,
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}