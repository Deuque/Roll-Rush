// class BoxContainers extends StatefulWidget {
//   @override
//   _BoxContainersState createState() => _BoxContainersState();
// }
//
// class _BoxContainersState extends State<BoxContainers>
//     with SingleTickerProviderStateMixin {
//   List<Widget> children = [];
//   AnimationController controller;
//   Animation offsetAnimation;
//   Offset offset;
//   GlobalKey _keyRed = GlobalKey();
//   GlobalKey _keyRed2 = GlobalKey();
//   Timer timer;
//   int count = 0;
//   List<int> checkingIndexes = [];
//   List<int> gottenIndexes = [];
//   StreamController boxesController = new StreamController();
//   Color mcolor = Colors.green;
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     boxesController.close();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     controller =
//     new AnimationController(vsync: this, duration: Duration(seconds: 3));
//
//     Timer.periodic(Duration(milliseconds: 1000), (Timer t) {
//       children.add(new MyHomePage(
//         key: Key(children.length.toString()),
//         checkOffset: checkOffset,
//         index: children.length,
//         gotten: gottenIndexes.contains(children.length),
//       ));
//       boxesController.sink.add(children);
//     });
//   }
//
//   checkOffset(Offset x, int index, Color color) {
//     if (x == null || offset == null || checkingIndexes.contains(index)) return;
//     final position1 = x;
//     final position2 = offset;
//     double s1 = 40;
//     double s2 = 40;
//
//     final collide = (position1.dx < position2.dx + s2 &&
//         position1.dx + s1 > position2.dx &&
//         position1.dy < position2.dy + s2-5 &&
//         position1.dy + s1 > position2.dy);
//     checkingIndexes.add(index);
//     setState(() {});
//     if (collide) {
//       // print(color.toString());
//       mcolor = color;
//       gottenIndexes.add(index);
//       setState(() {});
//       count++;
//     } else {
//       checkingIndexes.removeWhere((element) => element == index);
//       setState(() {});
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     double ballTimelyOffset = 1.25;
//     return GestureDetector(
//       onTapDown: (details) {
//         offset = offset ?? _keyRed.globalPaintBounds.topLeft;
//
//         bool right;
//         if (details.globalPosition.dx > size.width / 2) {
//           right = true;
//           // double totalDistance = (size.width*.9-45 - startingOffset.dx) +
//           //     ( size.width*.9-45 - size.width*.1) + (startingOffset.dx - size.width*.1);
//           // double w1 = (size.width*.9-45 - startingOffset.dx)* 3 /totalDistance ;
//           // double w2 = ( size.width*.9-45 - size.width*.1) * 3 /totalDistance ;
//           // double w3 = (startingOffset.dx - size.width*.1)*3 /totalDistance ;
//           //
//           // offsetAnimation = TweenSequence(
//           //   [
//           //     TweenSequenceItem(
//           //         tween: Tween<Offset>(
//           //           begin: startingOffset,
//           //           end: Offset(size.width*.9-45, size.height*.6),
//           //         ),
//           //         weight: w1),
//           //     TweenSequenceItem(
//           //         tween: Tween<Offset>(
//           //           begin:Offset(size.width*.9-45, size.height*.6),
//           //           end: Offset(size.width*.1, size.height*.6),
//           //         ),
//           //         weight: w2),
//           //     TweenSequenceItem(
//           //         tween: Tween<Offset>(
//           //           begin: Offset(size.width*.1, size.height*.6),
//           //           end: startingOffset,
//           //         ),
//           //         weight: w3),
//           //   ],
//           // ).animate(controller);
//           // controller.repeat();
//
//         } else {
//           right = false;
//         }
//
//         timer?.cancel();
//         if (right) {
//           timer = Timer.periodic(Duration(milliseconds: 1), (Timer t) {
//             if (right) {
//               if (offset.dx < size.width * .9 - 45) {
//                 offset = Offset(offset.dx + ballTimelyOffset, offset.dy);
//               } else {
//                 right = false;
//                 offset = Offset(offset.dx - ballTimelyOffset, offset.dy);
//               }
//             } else {
//               if (offset.dx > size.width * .1) {
//                 offset = Offset(offset.dx - ballTimelyOffset, offset.dy);
//               } else {
//                 right = true;
//                 offset = Offset(offset.dx + ballTimelyOffset, offset.dy);
//               }
//             }
//             setState(() {});
//           });
//         } else {
//           timer = Timer.periodic(Duration(milliseconds: 1), (Timer t) {
//             if (!right) {
//               if (offset.dx > size.width * .1) {
//                 offset = Offset(offset.dx - ballTimelyOffset, offset.dy);
//               } else {
//                 right = true;
//                 offset = Offset(offset.dx + ballTimelyOffset, offset.dy);
//               }
//             } else {
//               if (offset.dx < size.width * .9 - 45) {
//                 offset = Offset(offset.dx + ballTimelyOffset, offset.dy);
//               } else {
//                 right = false;
//                 offset = Offset(offset.dx - ballTimelyOffset, offset.dy);
//               }
//             }
//             setState(() {});
//           });
//         }
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
//             StreamBuilder(
//               stream: boxesController.stream,
//               builder: (_, snap) {
//                 List<Widget> newlist = [];
//                 if (snap.hasData) {
//                   // print((snap.data as List)
//                   //     .where((element) =>
//                   //         gottenIndexes.contains(snap.data.indexOf(element)))
//                   //     .map((e) => snap.data.indexOf(e))
//                   //     .toList()
//                   //     .asMap());
//                   newlist =  (snap.data as List)
//                       .where((element) =>
//                   !gottenIndexes.contains(snap.data.indexOf(element))).toList();
//                 }
//                 return Stack(
//                   //key: Key('childre ${snap.data?.length??-1}'),
//
//                   children: newlist,
//                 );
//               },
//             ),
//             Container(
//               padding: EdgeInsets.only(
//                   top: size.height * .6,
//                   left: size.width * .10,
//                   right: size.width * .10),
//               child: Container(
//                 key: _keyRed2,
//                 width: double.infinity,
//                 height: 45,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.withOpacity(.2),
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//               ),
//             ),
//             Transform.translate(
//               offset:
//               offset ?? Offset(size.width / 2 - (45 / 2), size.height * .6),
//               child: Container(
//                 key: _keyRed,
//                 height: 45,
//                 width: 45,
//                 decoration:
//                 BoxDecoration(shape: BoxShape.circle, color: mcolor),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
