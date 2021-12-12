import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrgenerator/library/global_colors.dart' as global_colors;
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:qrgenerator/components/inputcompo.dart';
import 'package:qrgenerator/components/bodycompo.dart';
import '../../library/ad_helper.dart';

class HomeComponent extends StatefulWidget {
  const HomeComponent({Key? key}) : super(key: key);

  @override
  _QrGenerateAppState createState() => _QrGenerateAppState();
}

class _QrGenerateAppState extends State<HomeComponent> {
  String? inputTextToGenerate;
  Uint8List? pngBytes;

  bool? gapState;
  InputCompo textField = InputCompo();
  BodyCompo qrBody = BodyCompo();
  double? imageSIze;
  Color? qrColor = global_colors.blackColor;
  Color? backgroundQrColor = global_colors.whiteColor;
  Color? qrColorToDownload = global_colors.blackColor;
  Color? backgroundQrColorToDownload = global_colors.whiteColor;

  SolidController? bottomSheetController;


  late RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;
  bool _isUserRewarded = false;
  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                _isRewardedAdReady = false;
              });
              _loadRewardedAd();
              if(_isUserRewarded) {
                _capturePng(
                    textToGenerate: inputTextToGenerate,
                    imageSize: imageSIze!,
                    backgroundColor: backgroundQrColor,
                    qrColor: qrColorToDownload,
                    qrGap: gapState
                );
                qrBody.showSnackBar(
                    context: context,
                    message: "The image is saved in the Gallery"
                );
                setState(() {
                  _isUserRewarded = false;
                });
              } else {
                setState(() {
                  _isUserRewarded = false;
                });
                qrBody.showSnackBar(
                    context: context,
                    message: "You See the full video ads to download the QR Code",
                    backgroundColor: global_colors.alertColor
                );
              }
            },
          );

          setState(() {
            _isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: (err) {
          setState(() {
            _isRewardedAdReady = false;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    inputTextToGenerate = "";
    gapState = false;
    imageSIze = 500.0;
    bottomSheetController = SolidController();
    _initGoogleMobileAds();
    _loadRewardedAd();
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: global_colors.appBackgroundColor,
      body: Center(
        child: ListView(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            textField.builder(
                onTap: () {
                  bottomSheetController!.hide();
                },
                onChanged: (text) {
                  setState(() {
                    inputTextToGenerate = text;
                  });
                }
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            qrBody.switchQR(
                status: gapState!,
                onToggle: (state) {
                  setState(() {
                    gapState = state;
                  });
                }
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            qrBody.qrBuild(inputTextToGenerate!,gapState!),
          ],
        ),
      ),
      bottomSheet: BodyCompo().downloadLayout(
          context: context,
          defaultQrColor: qrColor!,
          defaultBackgroundQrColor: backgroundQrColor!,
          controller: bottomSheetController!,
          pressedDownload: (newQrColor, newBackgroundColor) {
            setState(() {
              backgroundQrColorToDownload = newBackgroundColor;
              qrColorToDownload = newQrColor;
            });
            if (inputTextToGenerate == "") {
              qrBody.showSnackBar(
                  context: context,
                  message: "You must at least tap one character to generate",
                  backgroundColor: global_colors.alertColor
              );
            } else {
              if (_isRewardedAdReady) {
                _rewardedAd?.show(
                    onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
                      setState(() {
                        _isUserRewarded = true;
                      });
                    });
              } else {
                setState(() {
                  _isUserRewarded = false;
                });
                qrBody.showSnackBar(
                    context: context,
                    message: "Please enable the internet connection to support us by showing video Ads",
                    backgroundColor: global_colors.alertColor
                );
                _loadRewardedAd();
              }

            }

          },
          selectedSize: (size) {
            imageSIze = size;
          }
      ),
    );
  }

  Future<void> _capturePng({
    required String? textToGenerate,
    Color? qrColor = Colors.black,
    Color? backgroundColor = Colors.white,
    double? imageSize = 100,
    bool? qrGap = false,
  }) async {
    try {
      var permStatus = await Permission.storage.status;
      if (!permStatus.isGranted) {
        await Permission.storage.request();
      }

      if(!permStatus.isDenied) {
        final image = await QrPainter(
            color: qrColor!,
            emptyColor: backgroundColor!,
            data: textToGenerate!,
            version: QrVersions.auto,
            gapless: !qrGap!
        ).toImageData(imageSize!);

        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.png').create();
        await imagePath.writeAsBytes(image!.buffer.asUint8List());

        await ImageGallerySaver.saveFile(imagePath.path);
      }

    } catch (e) {
      rethrow;
    }
  }
}