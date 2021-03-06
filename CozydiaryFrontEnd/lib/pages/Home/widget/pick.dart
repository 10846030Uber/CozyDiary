import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:cozydiary/PostJsonService.dart';
import '../../../Model/WritePostModel.dart';
import '../../../login_controller.dart';

class pickController extends GetxController {
  final RxInt index = 0.obs; //抓取圖片index(type是FutureBuilder<Uint8List?>)
  List media = [].obs; //抓取圖片(type是FutureBuilder<Uint8List?>)
  RxBool isPick = false.obs; //判斷是否選取圖片，並顯示在最上面的container

  bool checkPressed = true; //單選多選判斷(用來開啟/關閉單選多選)
  RxBool MulitButtonColorCheck = true.obs; //切換目前切換單選多選按鈕顏色
  RxBool isMultiPick = false.obs; //判斷目前為單選多選

  static List<File?> allPicPath = []; //所有照片的path存在這
  //單選
  Map currPicFocusDic = {}; //選照片Focus

  static String singlePic = '';
  static var selectedPicPath = null;

  static List allPicName = []; //所有的picName.  !!!!!!!!!!!
  //多選
  var currNum;
  List selectOrder = [];

  static String multiPic = ''; //split前變數存放
  RxMap selectedPicDic = {}.obs; //多選Dictionary
  static List multiPicName = []; //每張的檔名
  static List finalPicPath = []; //多張照片路徑存放!!!!!!!!!
  static RxList selectedPicPathList =
      [].obs; //這是要把第一頁選的照片丟到第二頁(type是FutureBuilder<Uint8List?>)

  static String finalTitle = '';
  static String finalContent = '';
  static String finalFirstPicPath = '';
  //所有所選照片的path

  static Color themeColor = Color.fromRGBO(202, 175, 154, 1);

  late Post postsContext;
  var loginController = Get.put(LoginController());
  var postFiles = <PostFile>[];

  @override
  void onInit() {
    postsContext = Post(
        uid: "",
        title: "",
        content: "",
        likes: 0,
        collects: 0,
        cover: "",
        cid: 0,
        postFiles: []);
    super.onInit();
  }

  //傳到後端的資料
  void goToDataBase() async {
    var formdata = writePost();
    await PostService.postPostData(await formdata);
  }

  void setPost() {
    postsContext = Post(
        uid: "116177189475554672826",
        title: finalTitle,
        content: finalContent,
        likes: 0,
        collects: 0,
        cover: finalFirstPicPath,
        cid: 1,
        postFiles: postFiles);
  }

  Future<FormData> writePost() async {
    FormData formData = FormData();
    // int index = 1;
    allPicName.asMap().forEach((key, value) async {
      postFiles.add(PostFile(postUrl: value));
    });
    setPost();
    WritePostModule writePost = WritePostModule(post: postsContext);
    var jsonString = jsonEncode(writePost.toJson());
    formData = FormData.fromMap({"jsondata": jsonString});

    for (var i in finalPicPath) {
      formData.files
          .addAll([MapEntry("file", await MultipartFile.fromFile(i))]);
    }
    print(formData.files);
    return formData;
  }

  //最上面的照片選擇判斷
  void pick() {
    isPick.value = true;
  }

  //多選開關
  void multiPick() {
    if (checkPressed == true) {
      isMultiPick.value = true;
      checkPressed = false;
      MulitButtonColorCheck.value = false;
    } else {
      isMultiPick.value = false;
      checkPressed = true;
      MulitButtonColorCheck.value = true;
    }
  }

  //單選將第一頁選的照片丟到第二頁
  void singleSelectedPicNum() {
    selectedPicPath = media[index.toInt()];
    print(selectedPicPath );
  }

  //多選將第一頁選的照片丟到第二頁
  void selectedPicNum() {
    if (selectedPicDic[index] == true) {
      selectedPicPathList.add(media[index.value]);
    } else {
      selectedPicPathList.remove(media[index.value]);
    }
    print(selectedPicPathList);
  }

  void selectOrderSet() {
    if (selectOrder.contains(currNum) != true) {
      selectOrder.add(currNum);
    } else {
      selectOrder.remove(currNum);
    }
  }
}
