import 'package:cozydiary/pages/Personal/Service/personalService.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:hive/hive.dart';
import '../../../../Model/catchPersonalModel.dart';
import '../../../../Model/postCoverModel.dart';
import '../../../../Model/trackerListModel.dart';

class SelfPageController extends GetxController {
  var constraintsHeight = 0.0.obs; //記錄自介高度
  var readmore = true.obs; //是否有延展
  var difference = 0.0; //高度差
  var isLoading = true.obs; //是否再載入
  var uid = ""; //使用者id
  var userData = UserData(
          uid: 0,
          googleId: "",
          name: "",
          age: 0,
          sex: 0,
          introduction: "",
          pic: "",
          birth: [],
          createTime: [],
          email: "",
          tracker: [],
          follower: [],
          userCategoryList: [],
          picResize: "")
      .obs; //使用者資料暫存
  var postCover = <PostCoverData>[].obs;
  var collectedPostCover = <PostCoverData>[].obs;
  var box = Hive.box("UidAndState");
  var trackerList = <TrackerList>[];
  @override
  void onInit() {
    uid = box.get("uid");
    getUserData();
    getUserPostCover(uid);
    getCollectedPostCover(uid);

    super.onInit();
  }

  Future<void> getUserData() async {
    try {
      isLoading(true);

      var UserData = await PersonalService.fetchUserData(uid);
      if (UserData != null) {
        if (UserData.status == 200) {
          userData.value = UserData.data;
        }
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> getUserPostCover(String uid) async {
    try {
      isLoading(true);
      var Posts = await PersonalService.fetchUserPostCover(uid);
      if (Posts != null) {
        if (Posts.status == 200) {
          postCover.value = Posts.data;
        }
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> getCollectedPostCover(String uid) async {
    try {
      isLoading(true);
      var Posts = await PersonalService.fetchUserCollectedPostCover(uid);
      if (Posts != null) {
        if (Posts.status == 200) {
          collectedPostCover.value = Posts.data;
        }
      }
    } finally {
      isLoading(false);
    }
  }

  Future<bool> checkIsCollect(String pid) async {
    bool result = false;
    if (collectedPostCover.isEmpty) {
      result = false;
    } else {
      for (var collectpost in collectedPostCover) {
        if (collectpost.pid.toString() == pid) {
          result = true;
          break;
        }
      }
    }

    return result;
  }
}
