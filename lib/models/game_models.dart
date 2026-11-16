import 'package:flutter/material.dart';

class SolidBlock {
  final Rect rect;
  final bool isHazard;
  const SolidBlock(this.rect, {this.isHazard = false});
}

class CeilingAnchorPoint {
  final Offset position;
  final String label;
  const CeilingAnchorPoint(this.position, {this.label = 'CEILING HOOK'});
}

class DestructibleBarrier {
  final Rect rect;
  final int maxHp;
  int hp;
  final double requiredSpeed;
  final Color color;
  final String materialName;

  DestructibleBarrier({
    required this.rect,
    this.maxHp = 1,
    this.requiredSpeed = 240.0,
    this.color = const Color(0xFFC084FC),
    this.materialName = 'Crystal Barrier',
  }) : hp = maxHp;

  bool get isDestroyed => hp <= 0;
}

class EnergyCore {
  final Offset position;
  bool collected;
  EnergyCore(this.position, {this.collected = false});
}

class Particle {
  Offset pos;
  Offset vel;
  Color color;
  double radius;
  double life;
  double maxLife;

  Particle({
    required this.pos,
    required this.vel,
    required this.color,
    required this.radius,
    required this.maxLife,
  }) : life = maxLife;
}

class PendulumLevelDefinition {
  final int levelNumber;
  final String title;
  final String subtitle;
  final String hint;
  final Size worldSize;
  final Offset lightSpawn;
  final Offset heavySpawn;
  final Rect goalZone;
  final double parSeconds;
  final List<SolidBlock> blocks;
  final List<CeilingAnchorPoint> ceilingAnchors;
  final List<DestructibleBarrier> barriers;
  final List<Offset> corePositions;

  const PendulumLevelDefinition({
    required this.levelNumber,
    required this.title,
    required this.subtitle,
    required this.hint,
    required this.worldSize,
    required this.lightSpawn,
    required this.heavySpawn,
    required this.goalZone,
    required this.parSeconds,
    required this.blocks,
    required this.ceilingAnchors,
    required this.barriers,
    required this.corePositions,
  });
}
