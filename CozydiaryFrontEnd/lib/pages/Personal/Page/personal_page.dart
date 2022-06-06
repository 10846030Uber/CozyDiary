import 'package:cozydiary/data/dataResourse.dart';
import 'package:cozydiary/main.dart';
import 'package:cozydiary/pages/Personal/IntroductionWidget.dart';
import 'package:cozydiary/pages/Personal/controller/PersonalController.dart';
import 'package:cozydiary/pages/Personal/controller/TabbarController.dart';

import 'package:cozydiary/pages/Personal/userIdWidget.dart';
import 'package:cozydiary/pages/Personal/userNameWidget.dart';
import 'package:cozydiary/widget/refresh_Widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import '../../../screen_widget/collect_GridView.dart';
import '../../../screen_widget/post_GridView.dart';
import '../DrawerWidget.dart';

import 'Edit_Personal.dart';
import '../followerWidget.dart';
import '../userHeaderWidget.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PersonalView();
  }
}

class PersonalView extends GetView<PersonalPageController> {
  const PersonalView({Key? key}) : super(key: key);

  Widget _buildSliverHeaderWidget() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverHeaderDelegate(400, 70),
    );
  }

  Widget _buildTabbarWidget(var controller, var tab) {
    return SliverPersistentHeader(
        pinned: true,
        floating: false,
        delegate: _TabbarDelegate(
          TabBar(
              controller: controller,
              indicatorWeight: 2,
              indicatorColor: Color.fromARGB(255, 175, 152, 100),
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: 40),
              tabs: tab),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final _tabController = Get.put(TabbarController());
    final _userHeaderKey = GlobalKey();
    final _userNameKey = GlobalKey();
    final _userIdKey = GlobalKey();
    final _introductionKey = GlobalKey();
    final _followerKey = GlobalKey();
    final _dividerKey = GlobalKey();
    late double oldIntroductionHeight = 0.0;
    final personalController = Get.put(PersonalPageController());
    late double _dynamicTotalHeight = 0;
    final List<double> _childWidgetHeights = [];
    dynamic image = UserHeaderImage != null
        ? FileImage(UserHeaderImage!)
        : NetworkImage(Image_List[3]);

    double _getWidgetHeight(GlobalKey key) {
      RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
      return renderBox.size.height;
    }

    void _refreshHeight() {
      if (personalController.difference == 0.0) {
        personalController.difference =
            _getWidgetHeight(_introductionKey) - oldIntroductionHeight;
        print(personalController.difference);
        personalController.increaseAppbarHeight();
      } else if (personalController.readmore.value) {
        personalController.reduceAppbarHeight();
      } else {
        personalController.increaseAppbarHeight();
      }
    }

    Widget Introduction(String text, int trimLines) {
      final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
      final colorClickableText = Colors.black;
      final widgetColor = Colors.black;
      @override
      TextSpan link = TextSpan(
          text: personalController.readmore.value ? "... 更多" : " 減少",
          style: TextStyle(
            color: colorClickableText,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              oldIntroductionHeight = _getWidgetHeight(_introductionKey);
              personalController.onTabReadmore();
              WidgetsBinding.instance!
                  .addPostFrameCallback((timeStamp) => _refreshHeight());
            });
      Widget result = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          assert(constraints.hasBoundedWidth);
          final double maxWidth = constraints.maxWidth;
          // Create a TextSpan with data
          final texts = TextSpan(
            text: text,
          );
          // Layout and measure link
          TextPainter textPainter = TextPainter(
            text: link,
            textDirection: TextDirection
                .rtl, //better to pass this from master widget if ltr and rtl both supported
            maxLines: trimLines,
            ellipsis: '...',
          );
          textPainter.layout(
              minWidth: constraints.minWidth, maxWidth: maxWidth);
          final linkSize = textPainter.size;
          // Layout and measure text
          textPainter.text = texts;
          textPainter.layout(
              minWidth: constraints.minWidth, maxWidth: maxWidth);
          final textSize = textPainter.size;
          // Get the endIndex of data
          int? endIndex;
          final pos = textPainter.getPositionForOffset(Offset(
            textSize.width - linkSize.width,
            textSize.height,
          ));
          endIndex = textPainter.getOffsetBefore(pos.offset);
          var textSpan;
          if (textPainter.didExceedMaxLines) {
            textSpan = TextSpan(
              text: personalController.readmore.value
                  ? text.substring(0, endIndex)
                  : text,
              style: TextStyle(
                color: widgetColor,
              ),
              children: <TextSpan>[link],
            );
          } else {
            textSpan = TextSpan(
              text: text,
            );
          }
          return RichText(
            softWrap: true,
            overflow: TextOverflow.clip,
            text: textSpan,
          );
        },
      );
      return result;
    }

    Widget _DetailSliverWidget() {
      return SliverToBoxAdapter(
        child: Container(
          constraints: BoxConstraints.tightFor(
              width: MediaQuery.of(context).size.width,
              height: personalController.constraintsHeight.value),
          color: Colors.white,
          height: 90,
          child: Column(
            children: <Widget>[
              Divider(
                color: Colors.black54,
                indent: 40,
                endIndent: 40,
                height: 3,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: Container(
                    key: _introductionKey,
                    child: Introduction(PersonalValue_Map["Introduction"]!, 3),
                  )),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const DrawerWidget(),
      backgroundColor: Color.fromARGB(255, 227, 227, 227),
      body:
          // CustomScrollView(
          //   slivers: [
          //     SliverPersistentHeaderWidget(
          //         _tabController.controller, _tabController.tabs),
          //   ],
          // )
          NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  _buildSliverHeaderWidget(),
                  Obx(() => _DetailSliverWidget()),
                  _buildTabbarWidget(
                      _tabController.controller, _tabController.tabs)
                ];
              },
              body: TabBarView(
                controller: _tabController.controller,
                children: const [InitPostGridView(), InitCollectGridView()],
              )),
    );
  }
}

class _TabbarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tab;

  _TabbarDelegate(
    this.tab,
  );
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Center(child: tab),
    );
  }

  @override
  double get maxExtent => tab.preferredSize.height;

  @override
  double get minExtent => tab.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverHeaderDelegate(this.expandedHeight, this.tabbarHeight);

  final double expandedHeight;
  final double tabbarHeight;

  @override
  double get minExtent => 0;
  @override
  double get maxExtent => expandedHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: <Widget>[
        Image.network(
          Image_List[3],
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: expandedHeight,
        ),
        Container(
          color: Color.fromARGB(100, 0, 0, 0),
          height: expandedHeight,
        ),
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Icon(Icons.more_horiz_outlined, color: Colors.white),
              )
            ],
          ),
        ),
        Positioned(
            top: expandedHeight - tabbarHeight - shrinkOffset,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: tabbarHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45)),
              ),
              child: follower_Widget(),
            )),
        Positioned(
          top: expandedHeight - 140 - shrinkOffset,
          left: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                PersonalValue_Map["UserName"]!,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              Text(
                "UID:" + PersonalValue_Map["UID"]!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        Positioned(
            top: expandedHeight - 130 - shrinkOffset,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Get.to(Edit_PersonalPage(), transition: Transition.downToUp);
              },
              child: Text("編輯個人資料"),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(176, 202, 175, 154),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
            ))
      ],
    );
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return false;
  }
}
