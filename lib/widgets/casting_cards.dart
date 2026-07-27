import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatefulWidget {
  final int movieId;
  const CastingCards({super.key, required this.movieId});

  @override
  State<CastingCards> createState() => _CastingCardsState();
}

class _CastingCardsState extends State<CastingCards> {
  late Future<List<Cast>> _castFuture;

  @override
  void initState() {
    super.initState();
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    _castFuture = moviesProvider.getMovieCast(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cast>>(
      future: _castFuture,
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 160,
            child: Center(child: CupertinoActivityIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(
              child: Text('Sin actores disponibles', style: TextStyle(color: Colors.grey)),
            ),
          );
        }

        final List<Cast> cast = snapshot.data!;

        return SizedBox(
          width: double.infinity,
          height: 170,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: cast.length > 10 ? 10 : cast.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) => _CastCard(actor: cast[index]),
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast actor;

  const _CastCard({required this.actor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 90,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(actor.fullProfilePath),
                height: 85,
                width: 85,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}