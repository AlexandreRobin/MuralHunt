import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:muralhunt/providers/mural_provider.dart';
import 'package:muralhunt/utils/mural.dart';
import 'package:provider/provider.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Mural> murals = context.watch<MuralProvider>().getGallery();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30),
              width: 3,
              height: double.infinity,
              color: Colors.red,
            ),
            ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: murals.length,
                itemBuilder: (context, index) {
                  Mural mural = murals[index];
                  bool displayDate = index == 0
                      ? true
                      : DateFormat.yMMMMd().format(mural.capturedDate) !=
                          DateFormat.yMMMMd()
                              .format(murals[index - 1].capturedDate);

                  return GalleryItem(
                    mural: murals[index],
                    displayDate: displayDate,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SvgPicture.asset(
                      'lib/assets/close_red.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GalleryItem extends StatelessWidget {
  const GalleryItem({
    super.key,
    required this.mural,
    required this.displayDate,
  });

  final Mural mural;
  final bool displayDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (displayDate)
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 32, bottom: 8, left: 16, right: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFEE0100),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  DateFormat.yMMMMd().format(mural.capturedDate),
                  style: const TextStyle(
                    color: Color(0xFFEE0100),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        Padding(
          padding:
              const EdgeInsets.only(left: 64, right: 16, top: 8, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(mural.capturedPhoto),
          ),
        ),
      ],
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
