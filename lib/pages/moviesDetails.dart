import 'package:flutter/material.dart';
import 'package:movienest/constante.dart';
import 'package:movienest/models/Movie.dart';

class MoviesDetails extends StatelessWidget {
  const MoviesDetails({super.key, required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF330f3d),
        body:CustomScrollView(
            slivers: [
              SliverAppBar.large(
                leading: Container(
                    height: 70,
                    width: 70,
                    margin: EdgeInsets.only(top: 16,left: 16),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(0, 255, 255, 255),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFFC68EFD),
                      ),
                    )
                ),
                backgroundColor: Color(0xFF330f3d),
                expandedHeight: 350,
                pinned: true,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                        movie.title,
                        style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 255, 255, 255),fontWeight: FontWeight.w600)
                    ),
                    background:ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(24),
                        topLeft: Radius.circular(24),
                      ),
                      child: Image.network(
                        '${Constante.imagePath}${movie.backDropPath}',
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                      ),
                    )
                ),
              ),
              SliverToBoxAdapter(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Overview',
                              style: TextStyle(fontSize: 17,color: Color(0xFFC68EFD),fontWeight: FontWeight.w600)
                          ),
                          const SizedBox(height: 10),
                          Text(
                            movie.overview,
                            style: TextStyle(fontSize: 15,color: Color.fromARGB(255, 255, 255, 255),fontWeight: FontWeight.w400),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                          'Release Date: ',
                                          style: TextStyle(fontSize: 17,color: Color(0xFFC68EFD),fontWeight: FontWeight.bold)
                                      ),
                                      Text(
                                          '${movie.releaseDate} ',
                                          style: TextStyle(fontSize: 17,color: Color(0xFFC68EFD),fontWeight: FontWeight.bold)
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [

                                      Icon(
                                        Icons.star_rate_rounded,
                                        color: Colors.amber,
                                      ),
                                      Text(
                                          '${movie.voteAverage.toStringAsFixed(1)}/10',
                                          style: TextStyle(fontSize: 17,color: Color(0xFFC68EFD),fontWeight: FontWeight.bold)
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                  )
              ),
            ]
        )
    );
  }
}
