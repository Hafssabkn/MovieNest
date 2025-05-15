import 'package:flutter/material.dart';
import 'package:movienest/constante.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movienest/pages/moviesDetails.dart';

class carouselSlider extends StatelessWidget {
  carouselSlider({super.key,required this.snapshot});

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: snapshot.data!.length,
        options: CarouselOptions(
          height: 300,
          autoPlay: true,
          viewportFraction: 0.55,
          enlargeCenterPage: true,
          pageSnapping: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: const Duration(seconds: 1),
        ),
        itemBuilder: (context, itemIndex, PageViewIndex) {
          return GestureDetector(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>MoviesDetails(movie: snapshot.data![itemIndex])));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                height: 300,
                width: 270,
                child: Image.network(
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                    '${Constante.imagePath}${snapshot.data![itemIndex].posterPath}'
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}