import 'package:flutter/material.dart';

import '../models/actor.dart';

class PopularActorsSlider extends StatelessWidget {
  final AsyncSnapshot<List<Actor>> snapshot;

  const PopularActorsSlider({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final actor = snapshot.data![index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                ClipOval(
                  child: Image.network(
                    actor.profilePath!.isNotEmpty
                        ? 'https://image.tmdb.org/t/p/w200${actor.profilePath}'
                        : 'https://via.placeholder.com/100',
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 80,
                  child: Text(
                    actor.name,
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
