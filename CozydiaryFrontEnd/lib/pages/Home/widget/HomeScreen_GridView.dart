import 'package:cozydiary/PostController.dart';
import 'package:cozydiary/pages/Home/widget/buildCard_home.dart';
import 'package:cozydiary/pages/Home/widget/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postCoverController = Get.put(PostController());
    return Obx(() {
      if (postCoverController.isLoading.value) {
        return Center(
            child: SpinKitCircle(
          size: 20,
          color: Colors.black54,
        ));
      } else {
        return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: MasonryGridView.count(
                crossAxisSpacing: 0,
                crossAxisCount: 2,
                itemCount: postCoverController.postCover.length,
                itemBuilder: (context, index) {
                  return BuildCardHome(
                    PostCovers: postCoverController.postCover.value,
                    index: index,
                  );
                }));
      }
    });
  }
}
