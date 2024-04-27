import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/timer.dart';
import 'package:flutter/material.dart';
import 'package:flyingbird/components/background.dart';
import 'package:flyingbird/components/bird.dart';
import 'package:flyingbird/components/ground.dart';
import 'package:flyingbird/components/pipe_group.dart';
import 'package:flyingbird/game/config.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bluebird;
  Timer interval = Timer(Config.pipesInterval, repeat: true);
  bool isCollided = false;

  @override
  Future<void> onLoad() async {
    addAll([
      Background(),
      Ground(),
      bluebird = Bird(),
    ]);

    interval.onTick = () => add(PipeGroup());
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);
  }

  @override
  void onTap() {
    super.onTap();
    bluebird.fly();
  }

  void restartGame() {
    bluebird.reset();
    overlays.remove('gameOver');

    // clear the existing pipes
    children.whereType<PipeGroup>().forEach((pipeGroup) => remove(pipeGroup));

    // start adding new pipes from the beginning
    interval = Timer(Config.pipesInterval, repeat: true);
    interval.onTick = () => add(PipeGroup());

    resumeEngine();
  }

  void goToMainMenu() {
    bluebird.reset();
    // clear the existing pipes
    children.whereType<PipeGroup>().forEach((pipeGroup) => remove(pipeGroup));
    // start adding new pipes from the beginning
    interval = Timer(Config.pipesInterval, repeat: true);
    interval.onTick = () => add(PipeGroup());

    overlays.remove('gameOver');
    overlays.add('mainMenu');
    pauseEngine();
  }
}
