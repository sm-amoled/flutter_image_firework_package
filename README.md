Welcome to Image Firework, a fascinating firework animation package.

# Motivation
In various frameworks including JS, people have already created quite impressive fireworks animations. So, I wanted to apply a cute and fun animation effect where I can explode emojis in my project as well. However, it seems that there are no packages in Flutter that are shared to explode images or emojis like fireworks. 🥲

So, I decided to create one myself!

Since there were no existing resources shared in Flutter, I watched an  [After Effect Tutorials](https://www.youtube.com/watch?v=tGeYQlrbdGk&t=4s) on YouTube to research how to animate in a way that gives me the desired effect. I then implemented this animation effect as part of a school assignment, so I didn’t fully focus on performance optimization. Therefore, there’s still plenty of room for performance upgrades. If there’s anyone skilled in optimizing animations, I would greatly appreciate your help with a PR 🥰 It’s always open and welcoming!


# Usage
To use this plugin, add ìmage_firework as a dependency in your pubspec.yalm file.

## Examples
Here are one example that shows you how to use the Firework Animation Manager and Widget.

### 1. Need your asset image list
Create your asset name list type of `List<String>`. For the example, I use static list for assets. At my own project, I made asset name list at asset managing class as static list. How to create and manage this list is up to you.

```dart
static List<String> animatingImageUriList = [
  'assets/image_1.png',
  'assets/image_2.png',
  'assets/image_3.png',
  'assets/image_4.png',
  'assets/image_5.png',
];
```
### 2. Create image count list
Create image clunt list as `List<int>`. The length of list should be less then your `imageUrlList`. 

```dart
List<int> animatingImageCountList = [0, 0, 0, 0, 0];
```

The usage of this list is to give animation manager how the firework animation should consists of. The total number of image particle in one firework shot is pre-defined. and the portions of each asset are defined by this array.

For example, if I let the count list as below and the total number of particle is 30, then the firework shot will consists of 10 of second image particles, and 20 of third image particles.
```dart
List<int> animatingImageCountList = [0, 1, 2, 0, 0];
```

And another example, if I let the count list as below, then the fireworks shot consists of six images with all the same.
```dart
List<int> animatingImageCountList = [1, 1, 1, 1, 1];
```

### 3. Initiate ImageFireworkManager
Initiate imageFireworkManager with image url list that you defined at 1.
```dart
ImageFireWorkManager imageFireWorkManager =
      ImageFireWorkManager(animatingImageUriList: animatingImageUriList);
```

### 4. Put the Stack Widgeth with firework widgets
At the bottom of view stack (or at the position you want), put the Stack widget with `imageFireWorkManager.fireworkWidgets.values.toList()` as the children. This list contains all image particles of each shot you make. 

For not bothering user's action, I recommend you to put the Stack widget inside of Ignore Pointer.
```dart
return Scaffold(
  ...
  body: Stack(
    children: [
      IgnorePointer(
        child: Stack(
          children: imageFireWorkManager.fireworkWidgets.values.toList(),
        ),
      ),
      SafeArea(
        ...
      ),
    ],
  ),
);
```

### 5. Call addFireworkWidget function
To shot the firework and see the animation, what you have to do is calling àddFireworkWidget` function with the Offset value(means where the firework bomb starts to explode), and image count list(means how the firework shot consists of).
```dart
imageFireWorkManager.addFireworkWidget(
  offset: Offset(X, Y),
  animatingImageCountList: animatingImageCountList,
);
```

You can call the àddFireworkWidget` function at the end of another animation like "particle goes up from the bottom of the screen", and the firework can be more realistic or funny.

# Example Animation
I create one example code like this. You can check the code at the 'example' tab. 

You can make combination of image(emoji) at the bottom of the view. And when you tap the upper area, then the adding firework function called, and animation will be appear at the point you tapped.

![](https://github.com/sm-amoled/flutter_image_firework_package/blob/main/assets/image_firework_gif.gif?raw=tru)


