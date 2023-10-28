import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller/app/modules/main/main_store.dart';
import 'package:delivery_seller/app/modules/product/widgets/question.dart';
import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../profile_store.dart';

class Questions extends StatefulWidget {
  const Questions({Key? key}) : super(key: key);

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  final ProfileStore store = Modular.get();

  final MainStore mainStore = Modular.get();

  final User? _userAuth = FirebaseAuth.instance.currentUser;

  final ScrollController scrollController = ScrollController();

  int limit = 10;

  double lastExtent = 0;

  @override
  void initState() {
    store.clearNewQuestions();
    scrollController.addListener(() {
      if (scrollController.offset >
              (scrollController.position.maxScrollExtent - 200) &&
          lastExtent < scrollController.position.maxScrollExtent) {
        setState(() {
          limit += 10;
          lastExtent = scrollController.position.maxScrollExtent;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  bool answered = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!store.getCanBack()) {
          return false;
        }
        await FirebaseFirestore.instance
            .collection("sellers")
            .doc(_userAuth!.uid)
            .update({"new_questions": 0});
        store.setProfileEditFromDoc();
        return true;
      },
      child: Listener(
        onPointerDown: (_) => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: getStream(),
                  builder: (context, snapshot) {
                    print('snapshot.hasData: ${snapshot.hasData}');
                    if (!snapshot.hasData) return Container();
                    // if (!snapshot.hasData) return LoadCircularOverlay();
                    if (snapshot.data!.docs.isEmpty) {
                      return Container(
                        height: maxHeight(context),
                        width: maxWidth(context),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.question_answer_outlined,
                              size: wXD(200, context),
                              color: darkBlue,
                            ),
                            Text("Sem perguntas para serem exibidas"),
                          ],
                        ),
                      );
                    }
                    print(
                        'snapshot.data!.docs.length: ${snapshot.data!.docs.length}');
                    return SingleChildScrollView(
                      controller: scrollController,
                      padding:
                          EdgeInsets.symmetric(vertical: wXD(104, context)),
                      child: Column(
                        children: snapshot.data!.docs
                            .map((questionDoc) => QuestionToAnswer(
                                  adsId: questionDoc['ads_id'],
                                  answer: questionDoc['answer'],
                                  answeredAt: questionDoc['answered_at'],
                                  createdAt: questionDoc['created_at'],
                                  onTap: (txt) {
                                    print("answer: $txt");
                                    store.answerQuestion(
                                        questionDoc.id, txt, context);
                                  },
                                  question: questionDoc['question'],
                                  username: questionDoc['author_name'],
                                ))
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
              QuestionsAppBar(
                onTap: (bool value) {
                  if (value != answered) {
                    setState(() {
                      limit = 10;
                      lastExtent = 0;
                      answered = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    print('answered: $answered');

    if (answered) {
      return FirebaseFirestore.instance
          .collection("sellers")
          .doc(_userAuth!.uid)
          .collection("questions")
          .where("answered", isEqualTo: true)
          .orderBy("created_at", descending: true)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection("sellers")
          .doc(_userAuth!.uid)
          .collection("questions")
          .where("answered", isEqualTo: false)
          .orderBy("created_at", descending: true)
          .snapshots();
    }
  }
}

class QuestionsAppBar extends StatelessWidget {
  final User? _userAuth = FirebaseAuth.instance.currentUser;
  final Function(bool value) onTap;
  QuestionsAppBar({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final MainStore mainStore = Modular.get();
  final ProfileStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).viewPadding.top + wXD(70, context),
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top,
              left: wXD(30, context),
              right: wXD(30, context)),
          width: maxWidth(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
            color: white,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                offset: Offset(0, 3),
                color: Color(0x30000000),
              ),
            ],
          ),
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Perguntas',
                style: textFamily(
                  fontSize: 20,
                  color: darkBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: wXD(10, context)),
              DefaultTabController(
                length: 2,
                child: TabBar(
                  onTap: (val) {
                    print("concluded: $val");
                    onTap(val == 1);
                    // store.setAnswered(val == 1);
                    // print("concluded: ${store.concluded}");
                  },
                  indicatorColor: primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.symmetric(vertical: 8),
                  labelColor: primary,
                  labelStyle: textFamily(fontWeight: FontWeight.bold),
                  unselectedLabelColor: darkGrey,
                  indicatorWeight: 3,
                  tabs: [
                    Text('Pendentes'),
                    Text('Respondidas'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: wXD(30, context),
          top: MediaQuery.of(context).viewPadding.top,
          child: GestureDetector(
            onTap: () async {
              await FirebaseFirestore.instance
                  .collection("sellers")
                  .doc(_userAuth!.uid)
                  .update({"new_questions": 0});
              store.setProfileEditFromDoc();
              Modular.to.pop();
            },
            child:
                Icon(Icons.arrow_back, color: darkGrey, size: wXD(25, context)),
          ),
        )
      ],
    );
  }
}
