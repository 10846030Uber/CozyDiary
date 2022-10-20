import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../../Self/widget/buildCard_personal.dart';
import '../Controller/OtherPersonController.dart';

class InitOtherPersonPostGridView extends StatelessWidget {
  const InitOtherPersonPostGridView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var personalPageController = Get.find<OtherPersonPageController>();
    return Obx(() {
      return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: MasonryGridView.count(
              crossAxisCount: 2,
              itemCount: personalPageController.postCover.value.length,
              itemBuilder: (context, index) {
                return BuildCard(
                  index: index,
                  userPostCover: personalPageController.postCover.value,
                );
              }));
    });
  }
}
