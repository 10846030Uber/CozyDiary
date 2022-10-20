import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:cozydiary/Model/UserDataModel.dart';
import 'package:cozydiary/login_controller.dart';
import 'package:cozydiary/pages/Home/HomePageTabbar.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData, Response;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class RegisterController extends GetxController {
  //controller
  final _loginController = LoginController();

  String googleId = "";
  RxString name = "".obs;
  RxString sex = "1".obs;
  RxString introduction = "".obs;
  RxString birth = "2000-01-01".obs;
  String email = "";
  RxString pic = "".obs;
  RxString picorigin = "".obs;
  RxList f = [].obs;
  late Rx<io.File?> previewImage = File("").obs;
  final _imagePicker = ImagePicker();

  late bool choicesex = true;
  var userData = <User>[].obs;

  @override
  void onInit() {
    // firebaseauth.FirebaseAuth.instance
    //     .authStateChanges()
    //     .listen((firebaseauth.User? user) {
    //   googleId = user!.providerData[0].uid!;
    //   email = user.providerData[0].email!;
    //   name.value = user.providerData[0].displayName!;
    //   pic.value = user.providerData[0].photoURL!;
    //   print(googleId);
    // });
    super.onInit();
  }

  void adddata() async {
    googleId = LoginController.tempData['uid'];
    email = LoginController.tempData['email'];
    // name.value = user.providerData[0].displayName!;
    pic.value = LoginController.tempData['pic'];
    userData.clear();
    // final picFile = await getImage(url: pic.value);

    var picsplit = pic.value.split("/").last;

    userData.add(User(
        googleId: googleId,
        name: name.value,
        sex: sex.value,
        introduction: introduction.value,
        birth: DateTime.parse(birth.value),
        email: email,
        pic: picsplit));
    print(LoginController.tempData);
    print(googleId + email);
    print(userData[0].toJson());
    register();
  }

  void choicemen() {
    sex.value = "1";
  }

  void choicegril() {
    sex.value = "0";
  }

  Future<void> openImagePicker() async {
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final image = io.File(pickedImage.path);
      previewImage.value = image;
      pic.value = pickedImage.path;
      picorigin.value = pickedImage.path;
    } else {
      return;
    }
  }

  void register() async {
    try {
      var dio = Dio();
      var postUserData = UserDataModel(user: userData[0]);
      var jsonData = jsonEncode(postUserData.toJson());
      var formData = FormData.fromMap({"jsondata": jsonData});
      formData.files
          .add(MapEntry("file", await MultipartFile.fromFile(picorigin.value)));
      print(formData);
      print(picorigin.value);
      var response = (await dio.post('http://140.131.114.166:80/userRegister',
          data: formData));

      if (response.statusCode == 200) {
        print("成功");
        Get.to(HomePageTabbar());
      } else {
        print("失敗");
      }
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }
}
