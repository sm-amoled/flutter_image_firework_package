library image_firework;

import 'dart:math';
import 'package:flutter/material.dart';

/// # EN
/// You can shoot beautiful image fireworks with ImageFireWork!
///
/// ## Variable List
/// - imageAmount: Minimum number of images - default is 30
/// - imageLifetimeDurationSec: Total time (lifetime) the images float on the screen - default is 5 seconds
/// - imageShootDurationSec: Time it takes for the images to burst and spread initially - default is 2 seconds
/// - imageShootingXScale: Degree of spread along the X-axis when the images initially burst - default is 3
/// - imageShootingYScale: Degree of spread along the Y-axis when the images initially burst - default is 5
/// - imageFloatingXScale: Degree of movement along the X-axis after the images have spread - default is 20
/// - imageFloatingYScale: Degree of movement along the Y-axis after the images have spread - negative values make the images fall down - default is 1
/// - imageSizeDeltaScale: Degree of size fluctuation of the images after spreading - default is 0.3
/// - imageTransparentThreshold: Threshold for the images disappearing before the animation ends - higher values keep more images visible until the end, maximum is 1 - default is 0.9
/// - imageSize: Size of the particle images - default is 40
///
/// ## Usage
/// 1. Declare `ImageFireWork imageFireWork = ImageFireWork(imageAsset: asset);` within your widget.
/// 2. Place `Stack(children: imageFireWork.fireworkWidgets.values.toList())` in the desired location within the builder.
/// 3. Use `imageFireWork.addFireworkWidget(offset, animatingimageCountList)` to create image effects at the offset position (offset is based on top-left).
///
/// # KR
/// ImageFireWork 를 통해 예쁜 이미지 폭죽을 쏠 수 있습니다!
///
/// ## 변수 리스트
/// - imageAmount: 총 이미지 개수의 최소값 - default는 30
/// - imageLifetimeDurationSec: 이미지가 화면을 날아다니는 전체 시간 (생명시간) - default는 5
/// - imageShootDurationSec: 이미지가 처음에 터지면서 퍼지는 시간 - default는 2
/// - imageShootingXScale: 이미지가 처음에 퍼질 때 X축 방향으로 퍼지는 정도 - default는 3
/// - imageShootingYScale: 이미지가 처음에 퍼질 때 Y축 방향으로 퍼지는 정도 - default는 5
/// - imageFloatingXScale: 이미지가 퍼진 후 떠다닐 때 X축으로 움직이는 정도 - default는 20
/// - imageShootingYScale: 이미지가 퍼진 후 떠다닐 때 Y축으로 움직이는 정도 - 음수를 넣으면 이미지가 아래로 떨어짐 - default는 1
/// - imageSizeDeltaScale: 이미지가 퍼진 후 커졌다 작아졌다 하는 정도 - default는 0.3
/// - imageTransparentThreshold: 이미지가 퍼진 후 애니메이션 수명이 다하기 전에 사라지는 임계 조건값 -
///   값이 커지면 끝까지 유지되는 이미지의 수가 많아짐, 최대 1 - default는 0.9
/// - imageSize: 파티클 이미지의 크기 - default는 40
///
/// ## 사용 방법
/// 1. `ImageFireWork imageFireWork = ImageFireWork(imageAsset: asset));` 을 위잿 내에 선언
/// 2. `Stack(children: imageFireWork.fireworkWidgets.values.toList())` 을 builder 내 필요한 위치에 배치
/// 3. `imageFireWork.addFireworkWidget(offset, animatingimageCountList)` 으로 offset 위치에 이미지 이펙트를 생성 (top-left 기준 offset)
///
///
class ImageFireWorkManager {
  /// initializer of Image Firework Manager
  ImageFireWorkManager({
    required this.animatingImageUriList,
    this.imageAmount = 30,
    this.imageLifetimeDurationSec = 5,
    this.imageShootDurationSec = 2,
    this.imageShootingXScale = 3,
    this.imageShootingYScale = 5,
    this.imageFloatingXScale = 20,
    this.imageFloatingYScale = 1,
    this.imageSizeDeltaScale = 0.3,
    this.imageTransparentThreshold = 0.9,
    this.imageSize = 40,
  });

  // properties
  /// - imageAmount: Minimum number of images - default is 30
  final int imageAmount;

  /// - animatingImageUriList: List of asset images' path in String
  final List<String> animatingImageUriList;

  /// - imageLifetimeDurationSec: Total time (lifetime) the images float on the screen - default is 5 seconds
  final int imageLifetimeDurationSec;

  /// - imageShootDurationSec: Time it takes for the images to burst and spread initially - default is 2 seconds
  final int imageShootDurationSec;

  /// - imageShootingXScale: Degree of spread along the X-axis when the images initially burst - default is 3
  final double imageShootingXScale;

  /// - imageShootingYScale: Degree of spread along the Y-axis when the images initially burst - default is 5
  final double imageShootingYScale;

  /// - imageFloatingXScale: Degree of movement along the X-axis after the images have spread - default is 20
  final double imageFloatingXScale;

  /// - imageFloatingYScale: Degree of movement along the Y-axis after the images have spread - negative values make the images fall down - default is 1
  final double imageFloatingYScale;

  /// - imageSizeDeltaScale: Degree of size fluctuation of the images after spreading - default is 0.3
  final double imageSizeDeltaScale;

  /// - imageTransparentThreshold: Threshold for the images disappearing before the animation ends - higher values keep more images visible until the end, maximum is 1 - default is 0.9
  final double imageTransparentThreshold;

  /// - imageSize: Size of the particle images - default is 40
  final double imageSize;

  /// Container for FireworkWidgets. each element is a particle set of one shot.
  late Map<Key, FireworkWidget> fireworkWidgets = {};

  /// add animating widgets to fireworkWidgets in manager.
  ///
  /// - offset : the position exploding animation starts (offset is based on top-left).
  /// - animatingImageCountList : int value to indicate the ratio of each image of ImageFireworkManager's animaingImageUriList.
  /// The length of animatingImageCountList should be less or equal then animatingImageUriList of manager.
  /// For Example, when countList's value is [0, 1, 1], then second and thrid image particle will be shown in same amount at the animation.
  /// Or, when countList's value is [2, 1, 0], then first image particle's amount is twice then second image particle.
  void addFireworkWidget({
    required Offset offset,
    required List<int> animatingImageCountList,
  }) {
    final fireworkWidgetKey = UniqueKey();
    fireworkWidgets.addEntries(
      <Key, FireworkWidget>{
        fireworkWidgetKey: FireworkWidget(
          key: fireworkWidgetKey,
          notifyWidgetIsDisposed: (UniqueKey widgetKey) {
            fireworkWidgets.remove(widgetKey);
          },
          animatingImageUriList: animatingImageUriList,
          offset: offset,
          animatingImageCountList: animatingImageCountList,
          imageAmount: imageAmount,
          imageLifetimeDurationSec: imageLifetimeDurationSec,
          imageShootDurationSec: imageShootDurationSec,
          imageShootingXScale: imageShootingXScale,
          imageShootingYScale: imageShootingYScale,
          imageFloatingXScale: imageFloatingXScale,
          imageFloatingYScale: imageFloatingYScale,
          imageSizeDeltaScale: imageSizeDeltaScale,
          imageTransparentThreshold: imageTransparentThreshold,
          imageSize: imageSize,
        ),
      }.entries,
    );
  }

  /// remowve every firework widget
  void disposeWidget() {
    fireworkWidgets.forEach((key, value) {
      value.notifyWidgetIsDisposed();
    });
  }
}

/// FireworkWidget is Container Widget of image particle set.
///
/// It orchestrates image particles in given random condition.
class FireworkWidget extends StatefulWidget {
  /// initializer of Firework Widget
  const FireworkWidget({
    super.key,
    required this.notifyWidgetIsDisposed,
    required this.offset,
    required this.animatingImageCountList,
    required this.imageAmount,
    required this.imageLifetimeDurationSec,
    required this.imageShootDurationSec,
    required this.imageShootingXScale,
    required this.imageShootingYScale,
    required this.imageFloatingXScale,
    required this.imageFloatingYScale,
    required this.imageSizeDeltaScale,
    required this.imageTransparentThreshold,
    required this.imageSize,
    required this.animatingImageUriList,
  });

  /// Method to notify the end of animation to firework manager.
  /// And then, the manager can remove this object from managing widget list(map).
  final Function notifyWidgetIsDisposed;

  /// The ingredient ratio of firework effect
  final List<int> animatingImageCountList;

  /// The source images.
  final List<String> animatingImageUriList;

  /// Position where the pop animation starts.
  final Offset offset;

  /// The min number of image particles.
  final int imageAmount;

  ///Total time (lifetime) the images float on the screen
  final int imageLifetimeDurationSec;

  ///Time it takes for the images to burst and spread initially
  final int imageShootDurationSec;

  /// Degree of spread along the X-axis when the images initially burst
  final double imageShootingXScale;

  /// Degree of spread along the Y-axis when the images initially burst
  final double imageShootingYScale;

  /// Degree of movement along the X-axis after the images have spread
  final double imageFloatingXScale;

  /// Degree of movement along the Y-axis after the images have spread
  final double imageFloatingYScale;

  /// Degree of size fluctuation of the images after spreading
  final double imageSizeDeltaScale;

  /// Threshold for the images disappearing before the animation ends - higher values keep more images visible until the end, maximum is 1
  final double imageTransparentThreshold;

  /// Size of the particle images
  final double imageSize;

  @override
  State<FireworkWidget> createState() => _FireworkWidgetState();
}

/// State of FireworkWidget
class _FireworkWidgetState extends State<FireworkWidget>
    with TickerProviderStateMixin {
  // A list that holds the individual widgets for the fireworks animation.
  // 불꽃놀이에서 움직이는 각각의 위젯들을 담아두는 리스트
  late List<ImageWidget> imageWidgetList;
  late List<(String, int)> imageCountList;

  // Declare three AnimationControllers for the three types of movements.
  // 3가지 움직임을 위해, 3가지 AnimationController를 선언
  AnimationController? imageAnimationShootController,
      imageAnimationFloatController,
      imageAnimationLifeTimeController;

  // Declare the double values (Animations) that move according to the values of the AnimationControllers.
  // AnimationController의 값에 대해 움직이는 double 값(Animation)들을 선언
  late final Animation<double> imageShootAnimation,
      imageFloatYAnimation,
      imageFloatXAnimation,
      imageLifeTimeAnimation;

  // Variables that determine the duration of the animations.
  // 애니메이션 지속 시간을 결정하는 변수
  late final Duration _imageLifetimeDuration =
      Duration(seconds: widget.imageLifetimeDurationSec);
  late final Duration _imageShootDuration =
      Duration(seconds: widget.imageShootDurationSec);

  // The minimum number of images that appear at once for the effect.
  // 이펙트로 한 번에 나오는 최소 이미지의 개수
  late int imageAmount = widget.imageAmount;

  @override
  void initState() {
    super.initState();
    setAnimationController();

    imageCountList = setImageList(from: widget.animatingImageCountList);

    startAnimation();
  }

  @override
  void dispose() {
    imageAnimationShootController?.dispose();
    imageAnimationFloatController?.dispose();
    imageAnimationLifeTimeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: SizedBox(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: setImages(),
        ),
      ),
    );
  }

  /// From the given animatingImageCountList, use the list's value as ratio of particles
  /// and, re-calculate it based on imageAmount of manager. (the initial setting value).
  List<(String, int)> setImageList({required List<int> from}) {
    final totalNumber = from.reduce((value, element) => value + element);
    final minUnitNumber = 1 + imageAmount ~/ totalNumber;

    final result = from.mapWithIndex((index, value) {
      return (widget.animatingImageUriList[index], value * minUnitNumber);
    }).toList();

    return result;
  }

  /// Create image particles based on imageCountList's value.
  /// Setting for animations are given by this FireworkWidget.
  List<ImageWidget> setImages() {
    List<ImageWidget> images = [];
    imageCountList.asMap().forEach((index, obj) {
      images.addAll(
        List<ImageWidget>.generate(
          obj.$2,
          (_) => ImageWidget(
            offset: widget.offset,
            imageAsset: AssetImage(obj.$1),
            imageFloatXAnimation: imageFloatXAnimation,
            imageFloatYAnimation: imageFloatYAnimation,
            imageShootAnimation: imageShootAnimation,
            imageLifeTimeAnimation: imageLifeTimeAnimation,
            imageShootingXScale: widget.imageShootingXScale,
            imageShootingYScale: widget.imageShootingYScale,
            imageFloatingXScale: widget.imageFloatingXScale,
            imageFloatingYScale: widget.imageFloatingYScale,
            imageSizeDeltaScale: widget.imageSizeDeltaScale,
            imageTransparentThreshold: widget.imageTransparentThreshold,
            imageSize: widget.imageSize,
          ),
        ),
      );
    });
    return images;
  }
}

extension _FireworkWidgetStateAnimations on _FireworkWidgetState {
  /// Initialize the Animation-related values for the images being fired like fireworks.
  /// 이미지가 폭죽처럼 발사되는 Animation 관련 값 초기화
  void setAnimationController() {
    imageAnimationShootController = AnimationController(
      vsync: this,
      duration: _imageShootDuration,
    );
    imageShootAnimation = Tween(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(
        parent: imageAnimationShootController!,
        curve: Curves.easeOutCubic,
      ),
    );
    imageShootAnimation.addListener(() {
      // ignore: invalid_use_of_protected_member
      setState(() {});
    });

    // Initialize the Animation-related values for the images flying into the sky.
    // Since the horizontal and vertical movements are separate, the animations are divided into X and Y.
    // 이미지가 하늘로 날아가는 Animation 관련 값 초기화
    // 가로 움직임과 세로 움직임이 별개이기 때문에, Animation을 X와 Y로 분리하였음
    imageAnimationFloatController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _imageLifetimeDuration.inSeconds),
    );
    imageFloatXAnimation = Tween(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
        parent: imageAnimationFloatController!,
        curve: Curves.linear,
      ),
    );
    imageFloatYAnimation = Tween(begin: -50.0, end: 2000.0).animate(
      CurvedAnimation(
        parent: imageAnimationFloatController!,
        curve: Curves.easeIn,
      ),
    );
    imageFloatXAnimation.addListener(() {
      // ignore: invalid_use_of_protected_member
      setState(() {});
    });
    imageFloatYAnimation.addListener(() {
      // ignore: invalid_use_of_protected_member
      setState(() {});
    });

    // Initialize the Animation-related values for the duration of the firework widget itself.
    // This includes animations for adjusting the image size.
    // 불꽃놀이 위젯 자체의 지속시간과 관련된 Animation 관련 값 초기화
    // 여기에서 이미지 크기를 조정할 수 있는 애니메이션을 제공한다.
    imageAnimationLifeTimeController =
        AnimationController(vsync: this, duration: _imageLifetimeDuration);
    imageLifeTimeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: imageAnimationLifeTimeController!,
        curve: Curves.linear,
      ),
    );
    imageLifeTimeAnimation.addListener(() {
      // ignore: invalid_use_of_protected_member
      setState(() {});
    });
    imageLifeTimeAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        imageAnimationShootController?.dispose();
        imageAnimationFloatController?.dispose();
        imageAnimationLifeTimeController?.dispose();

        imageAnimationShootController = null;
        imageAnimationFloatController = null;
        imageAnimationLifeTimeController = null;

        widget.notifyWidgetIsDisposed(widget.key);
      }
    });
  }

  /// Call to start animation when setting is done!
  void startAnimation() {
    imageAnimationShootController?.forward(from: 0.0);
    imageAnimationFloatController?.forward(from: 0.0);
    imageAnimationLifeTimeController?.forward(from: 0.0);
  }
}

/// This widget is each image particle of animation.
class ImageWidget extends StatefulWidget {
  /// initalizer for Image Particle
  const ImageWidget({
    super.key,
    required this.imageShootAnimation,
    required this.imageFloatYAnimation,
    required this.imageFloatXAnimation,
    required this.imageLifeTimeAnimation,
    required this.imageAsset,
    required this.offset,
    required this.imageShootingXScale,
    required this.imageShootingYScale,
    required this.imageFloatingXScale,
    required this.imageFloatingYScale,
    required this.imageSizeDeltaScale,
    required this.imageTransparentThreshold,
    required this.imageSize,
  });

  /// Target Asset Image of Particle
  final AssetImage imageAsset;

  /// Animation values for each particles
  final Animation<double> imageShootAnimation,
      imageFloatYAnimation,
      imageFloatXAnimation,
      imageLifeTimeAnimation;

  /// The position of particle
  final Offset offset;

  /// The condition for each particle's animating
  final double imageShootingXScale,
      imageShootingYScale,
      imageFloatingXScale,
      imageFloatingYScale,
      imageSizeDeltaScale,
      imageTransparentThreshold,
      imageSize;

  @override
  State<ImageWidget> createState() => ImageWidgetState();
}

/// State for Image Particle's animating

class ImageWidgetState extends State<ImageWidget> {
  /// Variables for Image Particle's animation state.
  late final double randomScaleX,
      randomScaleY,
      distinctiveRandomSeed,
      imageShootingXScale,
      imageShootingYScale,
      imageFloatingXScale,
      imageFloatingYScale,
      imageSizeDeltaScale,
      imageTransparentThreshold,
      imageSize;

  @override
  void initState() {
    super.initState();

    imageShootingXScale = widget.imageShootingXScale;
    imageShootingYScale = widget.imageShootingYScale;
    imageFloatingXScale = widget.imageFloatingXScale;
    imageFloatingYScale = widget.imageFloatingYScale;
    imageSizeDeltaScale = widget.imageSizeDeltaScale;
    imageTransparentThreshold = widget.imageTransparentThreshold;
    imageSize = widget.imageSize;

    randomScaleX = Random().nextDouble() * 2 - 1;
    randomScaleY = Random().nextDouble() * 2 - 1;
    distinctiveRandomSeed = Random().nextDouble();
  }

  @override
  Widget build(BuildContext context) {
    var imageAnimationShootX =
        widget.imageShootAnimation.value * imageShootingXScale * randomScaleX;
    var imageAnimationShootY =
        widget.imageShootAnimation.value * imageShootingYScale * randomScaleY;

    var imageAnimationFloatX =
        sin(widget.imageFloatXAnimation.value + distinctiveRandomSeed) *
            imageFloatingXScale;
    var imageAnimationFloatY = widget.imageFloatYAnimation.value < 0
        ? 0
        : widget.imageFloatYAnimation.value * -1 * imageFloatingYScale;

    var imageAnimationPositionX =
        widget.offset.dx + imageAnimationShootX + imageAnimationFloatX;
    var imageAnimationPositionY =
        widget.offset.dy + imageAnimationShootY + imageAnimationFloatY;

    var imageScale = sin(
              (widget.imageLifeTimeAnimation.value + distinctiveRandomSeed) *
                  10,
            ) *
            imageSizeDeltaScale +
        1;
    bool isImageTransparent =
        (widget.imageLifeTimeAnimation.value + distinctiveRandomSeed) / 2 >
            imageTransparentThreshold;

    return Positioned(
      left: imageAnimationPositionX - imageSize / 2,
      top: imageAnimationPositionY - imageSize / 2,
      child: Opacity(
        opacity: isImageTransparent ? 0.0 : 1.0,
        child: Image(
          image: widget.imageAsset,
          width: imageSize * imageScale,
          height: imageSize * imageScale,
        ),
      ),
    );
  }
}

/// Method for iterating List as map with index
/// fpdart package contains this method, but to eliminate dependency,
/// I add this extension below.
extension IterableExtensions<E> on List<E> {
  /// Method for iterating List as map with index
  List<T> mapWithIndex<T>(T Function(int index, E element) f) {
    List<T> result = [];
    for (int i = 0; i < length; i++) {
      result.add(f(i, this[i]));
    }
    return result;
  }
}
