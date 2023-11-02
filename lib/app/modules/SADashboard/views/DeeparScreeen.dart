import 'dart:convert';

import 'package:champcash/Data/Effects.dart';
import 'package:champcash/shared/extras.dart';
import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeepArScreen extends StatelessWidget {
  const DeepArScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return GetX(
        init: DeepArScreenController(c: context),
        builder: (arController) {
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [

                arController.deepArController.value.isInitialized
                    ? Transform.scale(
                        scale: (1 /
                            arController.deepArController.value.aspectRatio /
                            deviceRatio),
                        child: DeepArPreview(
                          arController.deepArController.value,
                          onViewCreated: () {},
                        ),
                      )
                    : Center(
                      child: Text(
                        arController.onValue.value == "" ?"Loading":"Loading Preview",
                          style: textStyleW500(fontSize: 20),
                        ),
                    )
              ],
            ),
          );
        });
  }
}

class DeepArScreenController extends GetxController {
  BuildContext c;
  late Rx<DeepArController> deepArController=DeepArController().obs;
  final isFaceMask = false.obs,
      isFilter = false.obs,
      effectIndex = 0.obs,
      filterIndex = 0.obs,
      maskIndex = 0.obs,
      onValue = "".obs;
  final RxList<String> effectsList = <String>[].obs;
  final RxList<String> maskList = <String>[].obs;
  final RxList<String> filterList = <String>[].obs;
  final String _assetEffectsPath = 'assets/effects/';
  String androidLicenseKey =
      "97364c0c7835262f12ebe7a1a1ed47d136ef476e92f5c6de51b24d9403f64be31728cab8f401d2fe";

  DeepArScreenController({required this.c});

  @override
  void onInit() {
    super.onInit();
    onValue.value = "0";
    try {
      deepArController.value
          .initialize(
              androidLicenseKey: androidLicenseKey,
              iosLicenseKey: "---iOS key---",
              resolution: Resolution.high)
          .then((value) {
        initEffects(c);
      });
    } catch (dd) {
      print("deepArEDrror$dd");
    }
  }

  void initEffects(BuildContext context) {
    getEffectFromAssets(context).then((value) {
      effectsList.clear();
      maskList.clear();
      filterList.clear();
      effectsList.addAll(value);
      maskList.add(_assetEffectsPath + flowerFaceEfect);
      maskList.add(_assetEffectsPath + vikingHelmetEfect);

      filterList.add(_assetEffectsPath + burningEfect);
      filterList.add(_assetEffectsPath + hopeEfect);

      effectsList.removeWhere((element) => maskList.contains(element));
      effectsList.removeWhere((element) => filterList.contains(element));
    });
    effectsList.add('${_assetEffectsPath}burning_effect.deepar');
    effectsList.add('${_assetEffectsPath}flower_face.deepar');
    effectsList.add('${_assetEffectsPath}Hope.deepar');
    effectsList.add('${_assetEffectsPath}viking_helmet.deepar');
  }

  Future<List<String>> getEffectFromAssets(BuildContext context) async {
    final manifest =
        await DefaultAssetBundle.of(context).loadString("AssetManifest.json");
    final Map<String, dynamic> manifestMap = json.decode(manifest);
    final filePath = manifestMap.keys
        .where((element) => element.startsWith(_assetEffectsPath))
        .toList();
    return filePath;
  }

  String getNextEffect() {
    effectIndex.value < effectsList.length
        ? effectIndex.value++
        : effectIndex.value = 0;
    return effectsList[effectIndex.value];
  }

  String getPrevEffect() {
    effectIndex.value > 0
        ? effectIndex.value--
        : effectIndex.value = effectsList.length;
    return effectsList[effectIndex.value];
  }

  String getNextMask() {
    maskIndex.value < maskList.length ? maskIndex.value++ : maskIndex.value = 0;
    return maskList[maskIndex.value];
  }

  /// Get previous mask
  String getPrevMask() {
    maskIndex.value > 0 ? maskIndex.value-- : maskIndex.value = maskList.length;
    return maskList[maskIndex.value];
  }

  /// Get next filter
  String getNextFilter() {
    filterIndex.value < filterList.length
        ? filterIndex.value++
        : filterIndex.value = 0;
    return filterList[filterIndex.value];
  }

  /// Get previous filter
  String getPrevFilter() {
    filterIndex.value > 0
        ? filterIndex.value--
        : filterIndex.value = filterList.length;
    return filterList[filterIndex.value];
  }
}
