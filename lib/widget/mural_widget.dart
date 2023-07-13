import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:muralhunt/providers/map_provider.dart';
import 'package:muralhunt/providers/mural_provider.dart';
import 'package:muralhunt/screens/captured_screen.dart';
import 'package:muralhunt/utils/mural.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MuralWidget extends StatelessWidget {
  const MuralWidget({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    Mural mural = context.watch<MuralProvider>().getById(id);
    context.read<MapProvider>().setCapturable(mural);

    return SizedBox(
      height: 300,
      child: Column(
        children: [
          ActionButton(
            mural: mural,
            isCapturable: context.watch<MapProvider>().isCapturable,
            context: context,
          ),
          DetailsCard(
            mural: mural,
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.mural,
    required this.isCapturable,
    required this.context,
  });

  final Mural mural;
  final bool isCapturable;
  final BuildContext context;

  void onCapture(Mural mural) {
    mural.setCapture().then((Mural mural) {
      if (mural.isCaptured == false ||
          mural.capturedDate.toIso8601String().substring(0, 19) !=
              DateTime.now().toIso8601String().substring(0, 19)) {
        Navigator.of(context).pop();
      } else {
        context.read<MuralProvider>().updateById(mural);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CapturedScreen(id: mural.id)),
        );
      }
    });
  }

  void onDirection(Mural mural) {
    mural.redirectToMap();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          decoration: BoxDecoration(
            border: isCapturable
                ? Border.all(
                    color: const Color(0xFFEE0100),
                    width: 1.0,
                  )
                : null,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              overlayColor: isCapturable
                  ? MaterialStateProperty.all<Color>(
                      const Color(0xFFEE0100).withOpacity(0.1),
                    )
                  : null,
              borderRadius: BorderRadius.circular(30),
              onTap: isCapturable
                  ? () => onCapture(mural)
                  : () => onDirection(mural),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: SvgPicture.asset(
                        isCapturable
                            ? 'lib/assets/camera_red.svg'
                            : 'lib/assets/direction_grey.svg',
                        width: isCapturable ? 18 : 22,
                        height: isCapturable ? 18 : 22,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        isCapturable
                            ? mural.isCaptured
                                ? Platform.localeName.substring(0, 2) == 'fr'
                                    ? 'Recapturer'
                                    : 'Recapture'
                                : Platform.localeName.substring(0, 2) == 'fr'
                                    ? 'Capturer'
                                    : 'Capture'
                            : Platform.localeName.substring(0, 2) == 'fr'
                                ? 'Itinéraire'
                                : 'Directions',
                        style: TextStyle(
                          fontSize: 16,
                          color: isCapturable
                              ? const Color(0xFFEE0100)
                              : const Color(0xFFA1A2A1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DetailsCard extends StatelessWidget {
  const DetailsCard({
    super.key,
    required this.mural,
  });

  final Mural mural;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: mural.isCaptured
                ? FileImage(mural.capturedPhoto)
                : NetworkImage(mural.image) as ImageProvider,
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.9), Colors.transparent],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
                child: Text(
                  mural.artiste,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Text(
                  mural.isCaptured
                      ? Platform.localeName.substring(0, 2) == 'fr'
                          ? 'Capturée le ${DateFormat.yMMMMd(Platform.localeName).format(mural.capturedDate)}'
                          : 'Captured on ${DateFormat.yMMMMd().format(mural.capturedDate)}'
                      : Platform.localeName.substring(0, 2) == 'fr'
                          ? 'Non capturée'
                          : 'Not captured',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
