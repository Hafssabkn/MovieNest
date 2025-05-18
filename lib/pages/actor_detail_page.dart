import 'package:flutter/material.dart';

import '../services/api_services.dart';


class ActorDetailPage extends StatelessWidget {
  final int actorId;

  const ActorDetailPage({required this.actorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F1B),
      appBar: AppBar(
        title: Text('Actor Details'),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: ApiService().getActorDetails(actorId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final actor = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${actor.profilePath}',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    actor.name,
                    style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    actor.biography,
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Movies',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  FutureBuilder(
                    future: ApiService().getActorMovies(actorId),
                    builder: (context, movieSnapshot) {
                      if (movieSnapshot.hasData) {
                        final movies = movieSnapshot.data!;
                        return SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: movies.length,
                            itemBuilder: (context, index) {
                              final movie = movies[index];
                              return Container(
                                width: 120,
                                margin: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Image.network(
                                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                      height: 140,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      movie.title,
                                      style: TextStyle(color: Colors.white),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
