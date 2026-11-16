import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/customization.dart';
import '../models/game_models.dart';
import '../models/levels.dart';
import '../services/storage_service.dart';

enum ActiveCharacter { light, heavy }

class PendulumEngine extends ChangeNotifier {
  static const double gravity = 880.0;
  static const double lightRadius = 15.0;
  static const double heavyRadius = 24.0;

  late List<PendulumLevelDefinition> _levels;
  late PendulumLevelDefinition level;
  int currentLevelIndex = 0;

  Offset lightPos = Offset.zero;
  Offset lightVel = Offset.zero;
  bool lightGrounded = false;
  bool lightAnchored = false;
  double lightFacing = 1.0;

  Offset heavyPos = Offset.zero;
  Offset heavyVel = Offset.zero;
  bool heavyGrounded = false;
  double heavyFacing = 1.0;

  double ropeLength = 310.0;
  double currentTension = 0.0;
  double hitstopTimer = 0.0;

  ActiveCharacter activeChar = ActiveCharacter.light;
  bool twoPlayerMode = StorageService.twoPlayerMode;

  double lightMoveInput = 0.0;
  double heavyMoveInput = 0.0;
  bool heavyShorten = false;
  bool heavyLengthen = false;

  Offset? dragAimStart;
  Offset? dragAimCurrent;

  List<EnergyCore> cores = [];
  List<Particle> particles = [];
  double elapsedSeconds = 0.0;
  double animTime = 0.0;
  double shakeIntensity = 0.0;
  String statusBanner = '';
  double bannerTimer = 4.0;

  bool isLevelComplete = false;
  bool isFailed = false;
  String failReason = '';
  int earnedStars = 0;

  Offset camCenter = const Offset(500, 320);

  PendulumEngine({int initialLevelIndex = 0}) {
    _levels = PendulumLevels.buildAll();
    loadLevel(initialLevelIndex);
  }

  void loadLevel(int index) {
    _levels = PendulumLevels.buildAll();
    currentLevelIndex = index.clamp(0, _levels.length - 1);
    level = _levels[currentLevelIndex];

    lightPos = level.lightSpawn;
    lightVel = Offset.zero;
    lightGrounded = true;
    lightAnchored = false;
    lightFacing = 1.0;

    heavyPos = level.heavySpawn;
    heavyVel = Offset.zero;
    heavyGrounded = true;
    heavyFacing = 1.0;

    ropeLength = 310.0;
    currentTension = 0.0;
    hitstopTimer = 0.0;
    activeChar = ActiveCharacter.light;

    lightMoveInput = 0.0;
    heavyMoveInput = 0.0;
    heavyShorten = false;
    heavyLengthen = false;
    dragAimStart = null;
    dragAimCurrent = null;

    cores = level.corePositions.map((p) => EnergyCore(p)).toList();
    particles = [];
    elapsedSeconds = 0.0;
    shakeIntensity = 0.0;
    statusBanner = level.hint;
    bannerTimer = 5.0;

    isLevelComplete = false;
    isFailed = false;
    failReason = '';
    earnedStars = 0;

    camCenter = Offset(
      (lightPos.dx + heavyPos.dx) * 0.5 + 120,
      (lightPos.dy + heavyPos.dy) * 0.5 - 40,
    );
    notifyListeners();
  }

  void resetLevel() => loadLevel(currentLevelIndex);

  void toggleControlMode() {
    twoPlayerMode = !twoPlayerMode;
    StorageService.twoPlayerMode = twoPlayerMode;
    StorageService.save();
    notifyListeners();
  }

  void swapActiveCharacter() {
    activeChar = activeChar == ActiveCharacter.light
        ? ActiveCharacter.heavy
        : ActiveCharacter.light;
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  void jumpLight() {
    if (isLevelComplete || isFailed) return;
    if (lightAnchored) {
      lightAnchored = false;
      _showBanner('Detached from Ceiling Pivot');
    }
    if (lightGrounded) {
      lightVel = Offset(lightVel.dx, -520.0);
      lightGrounded = false;
      _spawnBurst(lightPos + const Offset(0, 14), lightColor, 10);
      HapticFeedback.lightImpact();
    }
    notifyListeners();
  }

  /// Grapples Light directly to the nearest overhead Ceiling Anchor Point in range!
  void toggleCeilingGrapple() {
    if (isLevelComplete || isFailed) return;
    if (lightAnchored) {
      lightAnchored = false;
      _showBanner('Ceiling Anchor released');
      HapticFeedback.selectionClick();
      notifyListeners();
      return;
    }

    CeilingAnchorPoint? bestAnchor;
    double bestDist = 470.0;
    for (final anchor in level.ceilingAnchors) {
      final d = (anchor.position - lightPos).distance;
      if (d < bestDist) {
        bestDist = d;
        bestAnchor = anchor;
      }
    }

    if (bestAnchor != null) {
      lightPos = bestAnchor.position;
      lightVel = Offset.zero;
      lightAnchored = true;
      ropeLength = (heavyPos - lightPos).distance.clamp(220.0, 380.0);
      _spawnBurst(lightPos, const Color(0xFF34D399), 20);
      shakeIntensity = 4.5;
      _showBanner('Grappled ${bestAnchor.label}! Swing Heavy & hit BOOST to smash!');
      if (!twoPlayerMode) activeChar = ActiveCharacter.heavy;
      HapticFeedback.mediumImpact();
    } else {
      _showBanner('Move closer beneath a Ceiling Hook to Grapple!');
    }
    notifyListeners();
  }

  /// Kinetic wrecking-ball whip impulse along the swing arc!
  void boostHeavySwing() {
    if (isLevelComplete || isFailed) return;
    if (!lightAnchored) {
      if (heavyGrounded) {
        heavyVel = Offset(heavyVel.dx, -230.0);
        heavyGrounded = false;
      }
      _showBanner('Anchor Light to a Ceiling Hook first for pendulum smash!');
      notifyListeners();
      return;
    }

    final diff = heavyPos - lightPos;
    final dist = math.max(1.0, diff.distance);
    // Perpendicular tangent direction in current swing direction (or facing direction)
    final rx = diff.dx / dist;
    final ry = diff.dy / dist;
    final tx = -ry;
    final ty = rx;
    final dirSign = heavyMoveInput.abs() > 0.05
        ? heavyMoveInput.sign
        : (heavyVel.dx.abs() > 15 ? heavyVel.dx.sign : heavyFacing);
    final tangentDot = tx * dirSign;
    final flip = tangentDot >= 0 ? 1.0 : -1.0;

    heavyVel = Offset(
      heavyVel.dx + tx * flip * 340.0,
      heavyVel.dy + ty * flip * 340.0,
    );
    heavyFacing = dirSign;
    _spawnBurst(heavyPos, const Color(0xFFFB923C), 16);
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  void launchLightFromDrag(Offset worldStart, Offset worldEnd) {
    if (isLevelComplete || isFailed) return;
    final d = worldStart - worldEnd;
    if (d.distance < 12) return;
    if (lightAnchored) lightAnchored = false;
    final dir = d / d.distance;
    final power = (d.distance * 4.8).clamp(280.0, 600.0);
    lightVel = Offset(dir.dx * power, dir.dy * power);
    lightGrounded = false;
    _spawnBurst(lightPos, lightColor, 12);
    notifyListeners();
  }

  bool get isHeavyAtSmashSpeed => heavyVel.distance >= 225.0;

  Color get lightColor =>
      CustomizationCatalog.lightProfiles[StorageService.lightProfileIndex].primaryColor;

  void _showBanner(String text) {
    statusBanner = text;
    bannerTimer = 3.2;
  }

  void step(double dt) {
    final clampedDt = dt.clamp(0.0, 0.033);
    animTime += clampedDt;
    if (bannerTimer > 0) bannerTimer = math.max(0.0, bannerTimer - clampedDt);
    if (shakeIntensity > 0) shakeIntensity = math.max(0.0, shakeIntensity - clampedDt * 18.0);
    _updateParticles(clampedDt);

    if (isLevelComplete || isFailed) {
      notifyListeners();
      return;
    }

    if (hitstopTimer > 0) {
      hitstopTimer = math.max(0.0, hitstopTimer - clampedDt);
      notifyListeners();
      return;
    }

    elapsedSeconds += clampedDt;

    // 1. Update Light Player
    if (!lightAnchored) {
      final targetVx = lightMoveInput * 265.0;
      if (lightMoveInput.abs() > 0.05) lightFacing = lightMoveInput.sign;
      final accel = lightGrounded ? 15.0 : 8.5;
      lightVel = Offset(
        lightVel.dx + (targetVx - lightVel.dx) * math.min(1.0, accel * clampedDt),
        lightVel.dy + gravity * clampedDt,
      );
      lightPos += lightVel * clampedDt;
      lightGrounded = _resolveStaticCollisions(isLight: true);
    } else {
      lightVel = Offset.zero;
    }

    // 2. Update Heavy Wrecking Ball
    if (heavyMoveInput.abs() > 0.05) heavyFacing = heavyMoveInput.sign;

    if (lightAnchored) {
      // Pendulum force + tangential swing pump
      final diff = heavyPos - lightPos;
      final dist = math.max(1.0, diff.distance);
      final rx = diff.dx / dist;
      final ry = diff.dy / dist;
      final tx = -ry;
      final ty = rx;
      // Align tangent horizontally with input direction
      final align = tx >= 0 ? 1.0 : -1.0;

      heavyVel = Offset(
        heavyVel.dx + (tx * align * heavyMoveInput * 430.0) * clampedDt,
        heavyVel.dy + (gravity + ty * align * heavyMoveInput * 430.0) * clampedDt,
      );
      // Slight air drag
      heavyVel *= (1.0 - 0.12 * clampedDt);

      if (heavyShorten) ropeLength = math.max(130.0, ropeLength - 185.0 * clampedDt);
      if (heavyLengthen) ropeLength = math.min(410.0, ropeLength + 185.0 * clampedDt);
    } else {
      final targetVx = heavyMoveInput * 170.0;
      heavyVel = Offset(
        heavyVel.dx + (targetVx - heavyVel.dx) * math.min(1.0, 11.0 * clampedDt),
        heavyVel.dy + gravity * clampedDt,
      );
    }

    heavyPos += heavyVel * clampedDt;

    // 3. Apply Pendulum Rope Constraint BEFORE barrier collision so wrecking arc stays crisp
    final diff = heavyPos - lightPos;
    final dist = diff.distance;
    if (lightAnchored) {
      currentTension = (dist / math.max(1.0, ropeLength)).clamp(0.0, 1.0);
      if (dist > ropeLength && dist > 0.001) {
        final dir = diff / dist;
        heavyPos = lightPos + dir * ropeLength;
        final radial = heavyVel.dx * dir.dx + heavyVel.dy * dir.dy;
        if (radial > 0) heavyVel -= dir * radial;
      }
      if (isHeavyAtSmashSpeed && (animTime * 40).floor() % 2 == 0) {
        _spawnParticle(heavyPos, const Color(0xFFFB923C), 4.0, 0.28);
      }
    } else {
      const maxFree = 520.0;
      currentTension = (dist / maxFree).clamp(0.0, 1.0);
      if (dist > maxFree && dist > 0.001) {
        final dir = diff / dist;
        lightPos += dir * ((dist - maxFree) * 0.65);
      }
    }

    // 4. Resolve Solid Blocks + Destructible Barriers
    heavyGrounded = _resolveStaticCollisions(isLight: false);
    _checkBarrierCollisions();

    // 5. Energy Cores
    for (final core in cores) {
      if (!core.collected &&
          ((core.position - lightPos).distance < lightRadius + 18 ||
              (core.position - heavyPos).distance < heavyRadius + 18)) {
        core.collected = true;
        _spawnBurst(core.position, const Color(0xFFFBBF24), 16);
        HapticFeedback.lightImpact();
      }
    }

    // 6. Abyss Fail
    if (lightPos.dy > level.worldSize.height + 70 ||
        heavyPos.dy > level.worldSize.height + 70) {
      _triggerFail('Fell below the demolition vault!');
      return;
    }

    // 7. Win Condition
    final lightInGoal = level.goalZone.inflate(22).contains(lightPos);
    final heavyInGoal = level.goalZone.inflate(26).contains(heavyPos);
    if (lightInGoal && heavyInGoal) {
      isLevelComplete = true;
      final collectedCount = cores.where((c) => c.collected).length;
      earnedStars = math.max(1, collectedCount);
      if (collectedCount == 3 && elapsedSeconds <= level.parSeconds) earnedStars = 3;
      _spawnBurst(level.goalZone.center, const Color(0xFF34D399), 34);
      shakeIntensity = 6.0;
      _persistWin();
    }

    // 8. Smooth Camera
    final midX = (lightPos.dx + heavyPos.dx) * 0.5;
    final midY = (lightPos.dy + heavyPos.dy) * 0.5;
    camCenter = Offset(
      camCenter.dx + (midX - camCenter.dx) * math.min(1.0, 5.5 * clampedDt),
      camCenter.dy + (midY - camCenter.dy) * math.min(1.0, 5.5 * clampedDt),
    );
    notifyListeners();
  }

  void _checkBarrierCollisions() {
    for (final barrier in level.barriers) {
      if (barrier.isDestroyed) continue;
      final rect = barrier.rect;

      // Light collides softly with intact barrier
      _pushOutOfRect(isLight: true, rect: rect);

      // Heavy wrecking-ball check against intact barrier
      final cx = heavyPos.dx.clamp(rect.left, rect.right);
      final cy = heavyPos.dy.clamp(rect.top, rect.bottom);
      final dx = heavyPos.dx - cx;
      final dy = heavyPos.dy - cy;
      final dSq = dx * dx + dy * dy;

      if (dSq < heavyRadius * heavyRadius) {
        final impactSpeed = heavyVel.distance;
        if (impactSpeed >= barrier.requiredSpeed) {
          barrier.hp -= 1;
          shakeIntensity = 11.0;
          hitstopTimer = 0.045;
          _spawnBurst(Offset(cx, cy), barrier.color, 28);
          HapticFeedback.heavyImpact();
          if (barrier.isDestroyed) {
            _showBanner('${barrier.materialName} SHATTERED!');
            // Slow heavy slightly after smashing through
            heavyVel *= 0.65;
          } else {
            _showBanner('${barrier.materialName} cracked! (${barrier.hp} HP left)');
            // Bounce back so player can swing another smash
            _pushOutOfRect(isLight: false, rect: rect, bounce: 0.75);
          }
        } else {
          _pushOutOfRect(isLight: false, rect: rect, bounce: 0.45);
          _showBanner('Swing wider or hit BOOST to reach Smash Speed!');
        }
      }
    }
  }

  void _pushOutOfRect({required bool isLight, required Rect rect, double bounce = 0.0}) {
    var pos = isLight ? lightPos : heavyPos;
    var vel = isLight ? lightVel : heavyVel;
    final r = isLight ? lightRadius : heavyRadius;

    final cx = pos.dx.clamp(rect.left, rect.right);
    final cy = pos.dy.clamp(rect.top, rect.bottom);
    final dx = pos.dx - cx;
    final dy = pos.dy - cy;
    final dSq = dx * dx + dy * dy;

    if (dSq < r * r) {
      final d = math.sqrt(dSq);
      if (d > 0.0001) {
        final nx = dx / d;
        final ny = dy / d;
        pos += Offset(nx * (r - d), ny * (r - d));
        final vn = vel.dx * nx + vel.dy * ny;
        if (vn < 0) vel -= Offset(nx * vn * (1.0 + bounce), ny * vn * (1.0 + bounce));
      } else {
        pos = Offset(rect.left - r, pos.dy);
        vel = Offset(-vel.dx.abs() * bounce, vel.dy);
      }
      if (isLight) {
        lightPos = pos;
        lightVel = vel;
      } else {
        heavyPos = pos;
        heavyVel = vel;
      }
    }
  }

  bool _resolveStaticCollisions({required bool isLight}) {
    var pos = isLight ? lightPos : heavyPos;
    var vel = isLight ? lightVel : heavyVel;
    final r = isLight ? lightRadius : heavyRadius;
    bool grounded = false;

    for (final block in level.blocks) {
      final rect = block.rect;
      final cx = pos.dx.clamp(rect.left, rect.right);
      final cy = pos.dy.clamp(rect.top, rect.bottom);
      final dx = pos.dx - cx;
      final dy = pos.dy - cy;
      final dSq = dx * dx + dy * dy;

      if (dSq < r * r) {
        if (block.isHazard) {
          _triggerFail(isLight ? 'Light touched spike hazard!' : 'Heavy hit spike pit! Shorten pendulum rope!');
          return false;
        }
        final d = math.sqrt(dSq);
        if (d > 0.0001) {
          final nx = dx / d;
          final ny = dy / d;
          pos += Offset(nx * (r - d), ny * (r - d));
          final vn = vel.dx * nx + vel.dy * ny;
          if (vn < 0) vel -= Offset(nx * vn, ny * vn);
          if (ny < -0.65) grounded = true;
        } else {
          pos = Offset(pos.dx, rect.top - r);
          if (vel.dy > 0) vel = Offset(vel.dx, 0);
          grounded = true;
        }
      }
    }

    pos = Offset(
      pos.dx.clamp(r, level.worldSize.width - r),
      pos.dy.clamp(r, level.worldSize.height - r),
    );
    if (isLight) {
      lightPos = pos;
      lightVel = vel;
    } else {
      heavyPos = pos;
      heavyVel = vel;
    }
    return grounded;
  }

  void _persistWin() {
    final lvl = level.levelNumber;
    final prevStars = StorageService.levelStars[lvl] ?? 0;
    if (earnedStars > prevStars) StorageService.levelStars[lvl] = earnedStars;
    final ms = (elapsedSeconds * 1000).round();
    final prevMs = StorageService.bestTimeMs[lvl];
    if (prevMs == null || ms < prevMs) StorageService.bestTimeMs[lvl] = ms;
    if (lvl >= StorageService.unlockedLevel && lvl < _levels.length) {
      StorageService.unlockedLevel = lvl + 1;
    }
    StorageService.save();
  }

  void _triggerFail(String reason) {
    isFailed = true;
    failReason = reason;
    shakeIntensity = 9.0;
    HapticFeedback.heavyImpact();
    notifyListeners();
  }

  void _spawnParticle(Offset pos, Color color, double radius, double life) {
    final rng = math.Random();
    particles.add(Particle(
      pos: pos,
      vel: Offset((rng.nextDouble() - 0.5) * 90, (rng.nextDouble() - 0.5) * 90),
      color: color,
      radius: radius,
      maxLife: life,
    ));
  }

  void _spawnBurst(Offset pos, Color color, int count) {
    final rng = math.Random();
    for (int i = 0; i < count; i++) {
      final ang = (i / count) * math.pi * 2 + rng.nextDouble() * 0.4;
      final spd = 90 + rng.nextDouble() * 190;
      particles.add(Particle(
        pos: pos,
        vel: Offset(math.cos(ang) * spd, math.sin(ang) * spd),
        color: color,
        radius: 3.0 + rng.nextDouble() * 4.0,
        maxLife: 0.45 + rng.nextDouble() * 0.35,
      ));
    }
  }

  void _updateParticles(double dt) {
    for (int i = particles.length - 1; i >= 0; i--) {
      final p = particles[i];
      p.life -= dt;
      if (p.life <= 0) {
        particles.removeAt(i);
      } else {
        p.pos += p.vel * dt;
      }
    }
  }
}
