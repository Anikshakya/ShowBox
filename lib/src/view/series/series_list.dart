import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/controller/series_controller.dart';
import 'package:showbox/src/view/series/series_details.dart';
import 'package:showbox/src/widgets/custom_image_widget.dart';

class SeriesListPage extends StatefulWidget {
  const SeriesListPage({super.key});

  @override
  State<SeriesListPage> createState() => _SeriesListPageState();
}

class _SeriesListPageState extends State<SeriesListPage> {
  final SeriesController seriesCon = Get.put(SeriesController());
  ScrollController paginationScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    paginationScrollController.addListener(_scrollListener);
    initialise();
  }

  initialise() async{
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await seriesCon.getSeriesList();
    });
  }

  void _scrollListener() {
    if (paginationScrollController.position.pixels ==
        paginationScrollController.position.maxScrollExtent) {
      // When the user reaches the end of the list
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    seriesCon.pageNum = seriesCon.pageNum + 1;
    await seriesCon.getPagination();
    setState(() { });
  }   

  @override
  void dispose() {
    paginationScrollController.removeListener(_scrollListener);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() => seriesCon.isLoading.isTrue
          ? const SizedBox(
            height: 750,
            child: Center(
              child: CircularProgressIndicator(color: Colors.red,),
            ),
          )
          : Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  controller: paginationScrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: seriesCon.seriesList.length,
                  itemBuilder: (context, index) {
                    return MovieCard(
                      title: seriesCon.seriesList[index]["name"] ?? "",
                      year: seriesCon.seriesList[index]["first_air_date"].split("-")[0],
                      rating: double.parse(seriesCon.seriesList[index]["vote_average"].toStringAsFixed(1)),
                      image: seriesCon.seriesList[index]["poster_path"],
                      onTap: (){
                        Get.to(() => SeriesDetailPage(id: seriesCon.seriesList[index]["id"],));
                      },
                    );
                  },
                ),
              ),
              seriesCon.isPageLoading.isTrue ?
              Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.grey.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                ),
              )
              : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final String title;
  final String year;
  final double rating;
  final String image;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.title,
    required this.year,
    required this.rating,
    required this.image, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Use an AspectRatio or SizedBox to constrain the image
            CustomImageNetworkWidget(
              imagePath: "${AppConstants.imageUrl}$image",
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6)
                  ),
                ),
                child: Text(
                  year,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    topRight: Radius.circular(6)
                  ),
                ),
                child: Text(
                  rating.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
