import 'package:flutter/material.dart';
import 'package:flutter_netflix_responsive/config/constants.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

String durationToString(int minutes) {
  var d = Duration(minutes: minutes);
  List<String> parts = d.toString().split(':');
  return '${parts[0]}h ${parts[1].padLeft(2, '0')}m';
}

void shareTitle(String mediaType, int id) {
  Share.share(
    'Check out this awesome $mediaType:\n$tmdbShareUrl$mediaType/$id',
    subject: 'You should definitely check this!',
  );
}

void launchUrl(context, String url, {bool hasError = false}) async {
  /// [hasError] property is made for UI testing purposes
  if (hasError) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Cannot launch URL'),
      ),
    );
  } else {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot launch URL'),
        ),
      );
    }
  }
}

Future<Color> getImagePalette(ImageProvider imageProvider) async {
  try {
    final PaletteGenerator paletteGenerator =
    await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor.color;
  } catch (e) {
    return Future.error('Something went wrong while getting dominant color');
  }
}