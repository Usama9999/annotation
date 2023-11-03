import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('images').get(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return PageView.builder(
                controller: pageController,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: snap.data!.docs.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        snap.data!.docs[index]['question'],
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        height: 300,
                        child: Row(
                          children: [
                            Expanded(
                                child: Image.network(
                                    snap.data!.docs[index]['leftUrl'])),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: Image.network(
                                    snap.data!.docs[index]['rightUrl'])),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              EasyLoading.show();
                              await FirebaseFirestore.instance
                                  .collection('response')
                                  .add({
                                "userId":
                                    FirebaseAuth.instance.currentUser!.uid,
                                "choosed": "Left",
                                "resource": snap.data!.docs[index].id
                              }).then((value) {
                                EasyLoading.showToast('Response submitted',
                                    toastPosition:
                                        EasyLoadingToastPosition.bottom);
                                pageController.nextPage(
                                    duration: Duration(microseconds: 200),
                                    curve: Curves.ease);
                              });
                              EasyLoading.dismiss();
                            },
                            child: const Text("Left"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              EasyLoading.show();
                              await FirebaseFirestore.instance
                                  .collection('response')
                                  .add({
                                "userId":
                                    FirebaseAuth.instance.currentUser!.uid,
                                "choosed": "Right",
                                "resouce": snap.data!.docs[index].id,
                              }).then((value) {
                                EasyLoading.showToast('Response submitted',
                                    toastPosition:
                                        EasyLoadingToastPosition.bottom);
                                pageController.nextPage(
                                    duration: const Duration(microseconds: 200),
                                    curve: Curves.ease);
                              });
                              EasyLoading.dismiss();
                            },
                            child: const Text("Right"),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  );
                });
          }),
    );
  }
}
