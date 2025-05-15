import 'package:flutter/material.dart';
import 'package:movienest/constante.dart';
import 'package:movienest/pages/moviesDetails.dart';

class TrendingSlider extends StatelessWidget {
  const TrendingSlider({super.key,required this.snapshot});

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (context)=>MoviesDetails(movie: snapshot.data![index])));
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                height: 300,
                width: 270,
                child: Image.network(
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                  '${Constante.imagePath}${snapshot.data![index].posterPath}',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
