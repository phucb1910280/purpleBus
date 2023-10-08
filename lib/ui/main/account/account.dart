import 'package:bluebus/models/user.dart';
import 'package:bluebus/shared/mcolors.dart';
import 'package:bluebus/shared/mtext.dart';
import 'package:bluebus/shared/sbox.dart';
import 'package:bluebus/ui/auth/welcome_screen.dart';
import 'package:bluebus/ui/main/account/profile_edit.dart';
import 'package:bluebus/ui/main/account/profile_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountSceen extends StatefulWidget {
  const AccountSceen({Key? key}) : super(key: key);

  @override
  State<AccountSceen> createState() => _AccountSceenState();
}

class _AccountSceenState extends State<AccountSceen> {
  var user = Users(
    fullName: "",
    address: "",
    email: "",
    phoneNumber: "",
    profilePhoto:
        "https://firebasestorage.googleapis.com/v0/b/purplebus-ee57f.appspot.com/o/default_avatar.png?alt=media&token=14653759-47ca-4964-995d-63c0f628e84d&_gl=1*1xdiu81*_ga*NjgzODM5Njg5LjE2ODQ4OTgwNTA.*_ga_CW55HF8NVT*MTY5NjE3NzMzNS4yOS4xLjE2OTYxNzczNDcuNDguMC4w",
  );

  @override
  void initState() {
    // loadUserData();
    super.initState();
  }

  // Future loadUserData() async {
  //   var data = await FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(FirebaseAuth.instance.currentUser!.email)
  //       .get();
  //   if (data.exists) {
  //     var tempUser = Users(
  //         fullName: data["fullName"],
  //         address: data["address"],
  //         email: data["email"],
  //         phoneNumber: data["phoneNumber"],
  //         isNewUser: data["isNewUser"],
  //         point: data["point"],
  //         profilePhoto: data["profilePhoto"]);
  //     setState(() {
  //       user = tempUser;
  //     });
  //   }
  // }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    if (FirebaseAuth.instance.currentUser == null) {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
          (route) => false,
        );
      }
    }
  }

  Future<void> showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Thông báo'),
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SBox(height: 20, width: 0),
                  Image.asset(
                    "assets/icons/caution.png",
                    color: MColors.primary,
                    height: 100,
                  ),
                  const SBox(height: 30, width: 0),
                  const Center(
                    child: Text(
                      "Bạn muốn đăng xuất?",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MColors.primaryContainer,
                      foregroundColor: MColors.primary,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "Hủy",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SBox(height: 0, width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: signOut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MColors.primary,
                      foregroundColor: MColors.background,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "Đồng ý",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tài khoản"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  FirebaseAuth.instance.currentUser!.emailVerified
                      ? userCard(snapshot.data["fullName"].toString(),
                          snapshot.data["profilePhoto"].toString())
                      : emailVerification(),
                  const SBox(height: 10, width: 0),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: MColors.primaryContainer.withOpacity(.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const EditProfile(),
                                    ),
                                  );
                                },
                                child: const MText(
                                  content: "Cập nhật thông tin",
                                  size: 20,
                                  bold: false,
                                  italic: false,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: const MText(
                                  content: "Điểm khuyến mãi",
                                  size: 20,
                                  bold: false,
                                  italic: false,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: const MText(
                                  content: "Thông báo",
                                  size: 20,
                                  bold: false,
                                  italic: false,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: const MText(
                                  content: "Vé xe của tôi",
                                  size: 20,
                                  bold: false,
                                  italic: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: MColors.primaryContainer.withOpacity(.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const MText(
                              content: "Liên hệ",
                              size: 20,
                              bold: false,
                              italic: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: MColors.primaryContainer.withOpacity(.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: showAlertDialog,
                            child: const MText(
                              content: "Đăng xuất",
                              size: 20,
                              bold: false,
                              italic: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Tài khoản"),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 5),
  //       child: ListView(
  //         children: [
  //           FirebaseAuth.instance.currentUser!.emailVerified
  //               ? userCard()
  //               : emailVerification(),
  //           const SBox(height: 10, width: 0),
  //           Padding(
  //             padding: const EdgeInsets.all(10),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: MColors.primaryContainer.withOpacity(.3),
  //                 borderRadius: BorderRadius.circular(15),
  //               ),
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     children: [
  //                       TextButton(
  //                         onPressed: () {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) => const EditProfile(),
  //                             ),
  //                           );
  //                         },
  //                         child: const MText(
  //                           content: "Cập nhật thông tin",
  //                           size: 20,
  //                           bold: false,
  //                           italic: false,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       TextButton(
  //                         onPressed: () {},
  //                         child: const MText(
  //                           content: "Điểm khuyến mãi",
  //                           size: 20,
  //                           bold: false,
  //                           italic: false,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       TextButton(
  //                         onPressed: () {},
  //                         child: const MText(
  //                           content: "Thông báo",
  //                           size: 20,
  //                           bold: false,
  //                           italic: false,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: [
  //                       TextButton(
  //                         onPressed: () {},
  //                         child: const MText(
  //                           content: "Vé xe của tôi",
  //                           size: 20,
  //                           bold: false,
  //                           italic: false,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(10),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: MColors.primaryContainer.withOpacity(.3),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: Row(
  //                 children: [
  //                   TextButton(
  //                     onPressed: () {},
  //                     child: const MText(
  //                       content: "Liên hệ",
  //                       size: 20,
  //                       bold: false,
  //                       italic: false,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(10),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 color: MColors.primaryContainer.withOpacity(.3),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: Row(
  //                 children: [
  //                   TextButton(
  //                     onPressed: showAlertDialog,
  //                     child: const MText(
  //                       content: "Đăng xuất",
  //                       size: 20,
  //                       bold: false,
  //                       italic: false,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget userCard(String name, String imgUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileInfoScreen(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 100,
          decoration: const BoxDecoration(
            color: MColors.primaryContainer,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SBox(height: 0, width: 15),
              CircleAvatar(
                backgroundImage: NetworkImage(
                  imgUrl,
                ),
                radius: 35,
              ),
              const SBox(height: 0, width: 15),
              Flexible(
                child: SizedBox(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          // user.fullName.toString(),
                          style: const TextStyle(fontSize: 25),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SBox(height: 10, width: 0),
                      const Row(
                        children: [
                          MText(
                            content: "Xem chi tiết",
                            size: 15,
                            bold: false,
                            italic: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SBox(height: 0, width: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailVerification() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () async {
          await FirebaseAuth.instance.currentUser!.sendEmailVerification();
        },
        child: Container(
          height: 130,
          decoration: const BoxDecoration(
            color: MColors.primaryContainer,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            image: DecorationImage(
                image: AssetImage("assets/images/email_ver.jpg"),
                opacity: 0.5,
                fit: BoxFit.cover),
          ),
          child: const Center(
            child: Text(
              "Xác thực email",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
