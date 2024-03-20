import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/modals/user_modal.dart';

import '../../helpers/firestore_helper.dart';
import '../../modals/follower_modal.dart';

class FollowerDetailPage extends StatefulWidget {
  const FollowerDetailPage({super.key});

  @override
  State<FollowerDetailPage> createState() => _FollowerDetailPageState();
}

class _FollowerDetailPageState extends State<FollowerDetailPage> {
  String username = "";
  @override
  Widget build(BuildContext context) {
    UserModal userModal =
        ModalRoute.of(context)!.settings.arguments as UserModal;

    Size s = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter username",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  username = val;
                });
              },
            ),
            username.isNotEmpty
                ? StreamBuilder(
                    stream: FireStoreHelper.fireStoreHelper
                        .getFollowerData(username: username),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        QuerySnapshot<Map<String, dynamic>>? data =
                            snapshot.data;
                        List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            allDocs = data?.docs ?? [];

                        List<FollowModal> allFollowers = allDocs
                            .map((e) => FollowModal.fromMap(data: e.data()))
                            .toList();

                        return Expanded(
                          child: ListView.builder(
                            itemCount: allFollowers.length,
                            itemBuilder: (context, index) {
                              FollowModal users = allFollowers[index];

                              return Container(
                                padding: const EdgeInsets.all(8),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      foregroundImage: FileImage(
                                        File(users.image),
                                      ),
                                    ),
                                    SizedBox(
                                      width: s.width * 0.04,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        log(users.username);
                                        Navigator.of(context).pushNamed(
                                            'profile_page',
                                            arguments: users);
                                      },
                                      child: Text(
                                        users.username,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: s.width * 0.04,
                                    ),
                                    SizedBox(
                                      height: 45,
                                      child: StreamBuilder(
                                        stream: FireStoreHelper.fireStoreHelper
                                            .followingData(),
                                        builder: (context, snaps) {
                                          if (snaps.hasData) {
                                            QuerySnapshot<Map<String, dynamic>>?
                                                data = snaps.data;

                                            List<
                                                    QueryDocumentSnapshot<
                                                        Map<String, dynamic>>>
                                                allDocs = data?.docs ?? [];

                                            List<FollowModal?> allFollowers =
                                                allDocs
                                                    .map((e) =>
                                                        FollowModal.fromMap(
                                                            data: e.data()))
                                                    .toList();

                                            if (allFollowers[index]!
                                                .email
                                                .contains(users.email)) {
                                              return ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    Colors.deepPurple,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  log(allFollowers[index]!
                                                      .username);
                                                  FireStoreHelper
                                                      .fireStoreHelper
                                                      .unfollow(
                                                          followEmail:
                                                              allFollowers[
                                                                      index]!
                                                                  .email);
                                                },
                                                child: const Text(
                                                  "Unfollow",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    Colors.deepPurple,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  log(allFollowers[index]!
                                                      .username);
                                                  FireStoreHelper
                                                      .fireStoreHelper
                                                      .unfollow(
                                                          followEmail:
                                                              allFollowers[
                                                                      index]!
                                                                  .email);
                                                },
                                                child: const Text(
                                                  "Unfollow",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              );
                                            }
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                : Expanded(
                    flex: 50,
                    child: ListView.builder(
                      itemCount: userModal.followerUsers.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> users =
                            userModal.followerUsers[index];
                        log(userModal.followerUsers[index]['username']
                            .toString());
                        log("======================");

                        return Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                foregroundImage: FileImage(
                                  File(userModal.followerUsers[index]['image']),
                                ),
                              ),
                              SizedBox(
                                width: s.width * 0.05,
                              ),
                              Text(
                                userModal.followerUsers[index]['username'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                height: 45,
                                child: StreamBuilder(
                                  stream: FireStoreHelper.fireStoreHelper
                                      .followingData(),
                                  builder: (context, snaps) {
                                    if (snaps.hasData) {
                                      QuerySnapshot<Map<String, dynamic>>?
                                          data = snaps.data;

                                      List<
                                              QueryDocumentSnapshot<
                                                  Map<String, dynamic>>>
                                          allDocs = data?.docs ?? [];

                                      List<FollowModal?> allFollowers = allDocs
                                          .map((e) => FollowModal.fromMap(
                                              data: e.data()))
                                          .toList();

                                      log(userModal.email);

                                      log(users['email']);

                                      if (userModal.followingUsers.any(
                                          (element) =>
                                              element['email'] ==
                                              users['email'])) {
                                        return ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Colors.deepPurple,
                                            ),
                                          ),
                                          onPressed: () async {
                                            await FireStoreHelper
                                                .fireStoreHelper
                                                .unfollow(
                                                    followEmail: users['email'])
                                                .then(
                                                  (value) async =>
                                                      await FireStoreHelper
                                                          .fireStoreHelper
                                                          .removeFollowing(
                                                              id: users[
                                                                  'email']),
                                                );
                                            await FireStoreHelper
                                                .fireStoreHelper
                                                .removeFollower(
                                                    id: users['email']);
                                          },
                                          child: const Text(
                                            "Unfollow",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Colors.deepPurple,
                                            ),
                                          ),
                                          onPressed: () async {
                                            await FireStoreHelper
                                                .fireStoreHelper
                                                .addFollowing(
                                                    userModal: userModal)
                                                .then(
                                                  (value) async =>
                                                      await FireStoreHelper
                                                          .fireStoreHelper
                                                          .updateFollowing(
                                                    username: users['username'],
                                                    image: users['image'],
                                                    id: users['email'],
                                                  ),
                                                );

                                            await FireStoreHelper
                                                .fireStoreHelper
                                                .addFollower(
                                                  userModal: userModal,
                                                  id: users['email'],
                                                )
                                                .then((value) async =>
                                                    await FireStoreHelper
                                                        .fireStoreHelper
                                                        .updateFollowers(
                                                            username: username,
                                                            image:
                                                                userModal.image,
                                                            docEmail:
                                                                users['email'],
                                                            email: userModal
                                                                .email));
                                          },
                                          child: const Text(
                                            "Follow",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
