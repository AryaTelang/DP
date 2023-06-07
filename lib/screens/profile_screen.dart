import 'package:bachat_cards/controllers/post_login_screen_controller.dart';
import 'package:bachat_cards/sevrices/shared_prefs.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constants/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _fillColor = const Color(0xFFE4F1ED);

  final _textStyle = latoSemiBold13.copyWith(fontWeight: FontWeight.w700);

  final postLoginScreenController = Get.find<PostLoginScreenController>();

  String gender = 'M';
  String date = '';

  late TextEditingController nameController;
  late TextEditingController mailController;
  late TextEditingController numberController;
  late Dio dio;

  @override
  void initState() {
    dio = Dio(BaseOptions(
        headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));
    nameController = TextEditingController();
    mailController = TextEditingController();
    numberController = TextEditingController();
    nameController.text =
        '${postLoginScreenController.userProfile.value.userInfo?.firstName ?? ''} ${postLoginScreenController.userProfile.value.userInfo?.lastName ?? ''}';
    mailController.text =
        postLoginScreenController.userProfile.value.userInfo?.email ?? '';
    numberController.text = SharedPrefs.getPhoneNumber();
    gender = postLoginScreenController.userProfile.value.userInfo?.gender ?? '';
    super.initState();
  }

  Future<void> updateProfile() async {
    try {
      await dio.post('${Constants.url}/um/v1/updateProfile', data: {
        'user_info': {
          'user_id': SharedPrefs.getUserEarnestId(),
          'mobile_no': SharedPrefs.getPhoneNumber(),
          'email': mailController.text.trim(),
          'user_status': 'A',
          'gender': gender,
          'operator_id': 'null',
          'first_name': nameController.text.trim().split(' ')[0],
          'last_name': nameController.text.trim().split(' ').length > 1
              ? nameController.text.trim().split(' ')[1]
              : '',
        }
      });
      Get.snackbar('Info', 'Profile update successful');
      Get.find<PostLoginScreenController>().getUserinfo(dio);
    } on DioError catch (e) {
      Get.snackbar('Error', e.message ?? '');
      if (kDebugMode) {
        print(e.response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 3,
              left: 3,
              child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 6.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, -1.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 80, left: 36, right: 36),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _spacer(),
                            _profileRows(
                              'Your Name',
                              _textField('Your Name', TextInputType.name,
                                  nameController),
                            ),
                            _spacer(),
                            _profileRows(
                              'Your Mail',
                              _textField('Your Mail',
                                  TextInputType.emailAddress, mailController),
                            ),
                            _spacer(),
                            _profileRows(
                              'Your Number',
                              _textField('Your Number', TextInputType.phone,
                                  numberController,
                                  enabled: false),
                            ),
                            _spacer(),
                            // _profileRows(
                            //   'Gender',
                            //   Row(
                            //     children: [
                            //       Container(
                            //         width: 85,
                            //         decoration: BoxDecoration(
                            //             color: _fillColor,
                            //             borderRadius: BorderRadius.circular(10),
                            //             border: Border.all(
                            //                 color:
                            //                     Colors.black.withOpacity(.20))),
                            //         child: ListTileTheme(
                            //           horizontalTitleGap: 0,
                            //           child: RadioListTile(
                            //             title: Text(
                            //               'Male',
                            //               style: _textStyle,
                            //             ),
                            //             contentPadding: EdgeInsets.zero,
                            //             activeColor: primaryColor,
                            //             value: 'M',
                            //             groupValue: gender,
                            //             onChanged: (value) {
                            //               setState(() {
                            //                 gender = value!;
                            //               });
                            //             },
                            //           ),
                            //         ),
                            //       ),
                            //       const Spacer(),
                            //       Container(
                            //         width: 100,
                            //         decoration: BoxDecoration(
                            //             color: _fillColor,
                            //             borderRadius: BorderRadius.circular(10),
                            //             border: Border.all(
                            //                 color:
                            //                     Colors.black.withOpacity(.20))),
                            //         child: ListTileTheme(
                            //           horizontalTitleGap: 0,
                            //           child: RadioListTile(
                            //             title: Text(
                            //               'Female',
                            //               style: _textStyle,
                            //             ),
                            //             value: 'F',
                            //             activeColor: primaryColor,
                            //             contentPadding: EdgeInsets.zero,
                            //             groupValue: gender,
                            //             onChanged: (value) {
                            //               setState(() {
                            //                 gender = value!;
                            //               });
                            //             },
                            //           ),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 0,
              left: 0,
              child: CircleAvatar(
                radius: 80,
                child: Image.asset('assets/images/sample_profile.png'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.save_rounded,
          color: Colors.white,
        ),
        onPressed: () {
          updateProfile();
        },
      ),
    );
  }

  _spacer() {
    return const SizedBox(
      height: 20,
    );
  }

  _profileRows(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: latoBold16.copyWith(fontSize: 14),
        ),
        const SizedBox(
          height: 8,
        ),
        child
      ],
    );
  }

  _textField(String hintText, TextInputType inputType,
      TextEditingController controller,
      {bool? enabled = true}) {
    final border = OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black.withOpacity(.20),
        ),
        borderRadius: BorderRadius.circular(10));

    return TextField(
      enabled: enabled,
      keyboardType: inputType,
      controller: controller,
      style: _textStyle,
      decoration: InputDecoration(
          border: border,
          hintText: hintText,
          enabledBorder: border,
          focusedBorder: border,
          filled: true,
          hintStyle: _textStyle,
          fillColor: _fillColor),
    );
  }
}
