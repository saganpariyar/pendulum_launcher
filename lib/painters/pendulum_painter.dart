import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../engine/pendulum_engine.dart';
import '../models/customization.dart';
import '../services/storage_service.dart';

class PendulumCameraTransform {
  final double scale;
  final Offset translation;
  const PendulumCameraTransform(this.scale, this.translation);

  Offset screenToWorld(Offset screen) => (screen - translation) / scale;
}

PendulumCameraTransform computePendulumCamera(PendulumEngine engine, Size viewport) {
  final spanX = (engine.lightPos.dx - engine.heavyPos.dx).abs() + 460.0;
  final spanY = (engine.lightPos.dy - engine.heavyPos.dy).abs() + 360.0;
  final fitX = viewport.width / math.max(spanX, 640.0);
  final fitY = viewport.height / math.max(spanY, 460.0);
  final scale = math.min(fitX, fitY).clamp(0.42, 1.35);

  final worldW = engine.level.worldSize.width;
  final worldH = engine.level.worldSize.height;
  double cx = engine.camCenter.dx;
  double cy = engine.camCenter.dy;

  final halfW = (viewport.width * 0.5) / scale;
  final halfH = (viewport.height * 0.5) / scale;
  cx = worldW > halfW * 2 ? cx.clamp(halfW, worldW - halfW) : worldW * 0.5;
  cy = worldH > halfH * 2 ? cy.clamp(halfH - 20, worldH - halfH + 20) : worldH * 0.5;

  return PendulumCameraTransform(
    scale,
    Offset(viewport.width * 0.5 - cx * scale, viewport.height * 0.5 - cy * scale),
  );
}

class PendulumPainter extends CustomPainter {
  final PendulumEngine engine;
  PendulumPainter(this.engine) : super(repaint: engine);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = CustomizationCatalog.backgrounds[StorageService.backgroundIndex];
    final lightSkin = CustomizationCatalog.lightProfiles[StorageService.lightProfileIndex];
    final heavySkin = CustomizationCatalog.heavyProfiles[StorageService.heavyProfileIndex];
    final tetherSkin = CustomizationCatalog.tetherStyles[StorageService.tetherStyleIndex];
    final cam = computePendulumCamera(engine, size);

    // Floating ember motes
    final p = Paint()..color = bg.accentColor.withValues(alpha: 0.25);
    for (int i = 0; i < 16; i++) {
      final x = (i * 89.3 + engine.animTime * 18) % size.width;
      final y = size.height - ((engine.animTime * 28 + i * 79) % size.height);
      canvas.drawCircle(Offset(x, y), 1.6 + (i % 3), p);
    }

    canvas.save();
    if (engine.shakeIntensity > 0.1) {
      canvas.translate(
        math.sin(engine.animTime * 65) * engine.shakeIntensity,
        math.cos(engine.animTime * 57) * engine.shakeIntensity,
      );
    }
    canvas.translate(cam.translation.dx, cam.translation.dy);
    canvas.scale(cam.scale);

    // 1. Solid blocks & hazards
    for (final b in engine.level.blocks) {
      if (b.isHazard) {
        canvas.drawRRect(RRect.fromRectAndRadius(b.rect, const Radius.circular(6)), Paint()..color = const Color(0xFF450A0A));
        final sp = Paint()..color = const Color(0xFFFB7185);
        for (double x = b.rect.left + 8; x < b.rect.right - 12; x += 24) {
          final path = Path()..moveTo(x, b.rect.top)..lineTo(x + 9, b.rect.top - 14)..lineTo(x + 18, b.rect.top)..close();
          canvas.drawPath(path, sp);
        }
      } else {
        final rr = RRect.fromRectAndRadius(b.rect, const Radius.circular(8));
        canvas.drawRRect(rr, Paint()..color = bg.platformBodyColor);
        canvas.drawLine(Offset(b.rect.left + 4, b.rect.top + 2), Offset(b.rect.right - 4, b.rect.top + 2), Paint()..color = bg.accentColor.withValues(alpha: 0.7)..strokeWidth = 3);
      }
    }

    // 2. Destructible Barriers with crack lines based on remaining HP
    for (final bar in engine.level.barriers) {
      if (bar.isDestroyed) continue;
      final rr = RRect.fromRectAndRadius(bar.rect, const Radius.circular(8));
      canvas.drawRRect(rr, Paint()..color = bar.color.withValues(alpha: 0.35));
      canvas.drawRRect(rr, Paint()..color = bar.color..style = PaintingStyle.stroke..strokeWidth = 3.5);
      // HP segments
      for (int i = 0; i < bar.hp; i++) {
        final cy = bar.rect.top + 24 + i * 26;
        canvas.drawCircle(Offset(bar.rect.center.dx, cy), 6, Paint()..color = Colors.white);
      }
      if (bar.hp < bar.maxHp) {
        final crack = Paint()..color = Colors.white..strokeWidth = 2.2;
        canvas.drawLine(bar.rect.topLeft + const Offset(6, 20), bar.rect.center, crack);
        canvas.drawLine(bar.rect.center, bar.rect.bottomRight - const Offset(8, 25), crack);
      }
    }

    // 3. Ceiling Anchor Hooks
    for (final hook in engine.level.ceilingAnchors) {
      canvas.drawCircle(hook.position, 26, Paint()..color = lightSkin.glowColor.withValues(alpha: 0.18));
      canvas.drawCircle(hook.position, 14, Paint()..color = lightSkin.glowColor..style = PaintingStyle.stroke..strokeWidth = 3);
      canvas.drawLine(Offset(hook.position.dx, 60), hook.position, Paint()..color = const Color(0xFF94A3B8)..strokeWidth = 4);
      canvas.drawCircle(hook.position, 5, Paint()..color = Colors.white);
    }

    // 4. Goal Zone
    final gc = engine.level.goalZone.center;
    final gr = engine.level.goalZone.width * 0.42 * (1 + 0.08 * math.sin(engine.animTime * 5));
    canvas.drawCircle(gc, gr + 8, Paint()..color = const Color(0xFF34D399).withValues(alpha: 0.25));
    canvas.drawCircle(gc, gr, Paint()..color = const Color(0xFF34D399)..style = PaintingStyle.stroke..strokeWidth = 4);

    // 5. Energy Cores
    for (final core in engine.cores) {
      if (!core.collected) {
        final bob = math.sin(engine.animTime * 4 + core.position.dx * 0.03) * 4;
        final pos = core.position + Offset(0, bob);
        canvas.drawCircle(pos, 15, Paint()..color = const Color(0xFFFBBF24).withValues(alpha: 0.25));
        canvas.drawCircle(pos, 8, Paint()..color = const Color(0xFFFBBF24));
      }
    }

    // 6. Pendulum Tether
    final smashReady = engine.isHeavyAtSmashSpeed && engine.lightAnchored;
    final lineColor = smashReady ? const Color(0xFFFB923C) : tetherSkin.primaryColor;
    canvas.drawLine(engine.lightPos, engine.heavyPos, Paint()..color = lineColor.withValues(alpha: 0.35)..strokeWidth = smashReady ? 10 : 7..strokeCap = StrokeCap.round);
    canvas.drawLine(engine.lightPos, engine.heavyPos, Paint()..color = lineColor..strokeWidth = 3.5..strokeCap = StrokeCap.round);

    // 7. Wrecking Ball & Ceiling Grapple Light
    _drawHeavyBall(canvas, engine.heavyPos, heavySkin, smashReady, engine.activeChar == ActiveCharacter.heavy && !engine.twoPlayerMode);
    _drawLight(canvas, engine.lightPos, lightSkin, engine.lightFacing, engine.lightAnchored, engine.activeChar == ActiveCharacter.light && !engine.twoPlayerMode);

    for (final pt in engine.particles) {
      final a = (pt.life / pt.maxLife).clamp(0.0, 1.0);
      canvas.drawCircle(pt.pos, pt.radius * a, Paint()..color = pt.color.withValues(alpha: a));
    }

    canvas.restore();
  }

  void _drawLight(Canvas canvas, Offset pos, LightProfile skin, double facing, bool anchored, bool selected) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    if (selected) {
      canvas.drawCircle(Offset.zero, 23, Paint()..color = skin.glowColor.withValues(alpha: 0.35)..style = PaintingStyle.stroke..strokeWidth = 2);
    }
    if (anchored) {
      final p = Paint()..color = skin.glowColor..strokeWidth = 3;
      canvas.drawLine(const Offset(-14, -12), Offset.zero, p);
      canvas.drawLine(const Offset(14, -12), Offset.zero, p);
    }
    canvas.drawCircle(Offset.zero, PendulumEngine.lightRadius, Paint()..color = const Color(0xFF0F172A));
    canvas.drawCircle(Offset.zero, PendulumEngine.lightRadius, Paint()..color = skin.primaryColor..style = PaintingStyle.stroke..strokeWidth = 3);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(facing * 4, -2), width: 13, height: 7), const Radius.circular(3)), Paint()..color = skin.glowColor);
    canvas.restore();
  }

  void _drawHeavyBall(Canvas canvas, Offset pos, HeavyProfile skin, bool smashHot, bool selected) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    if (smashHot) {
      canvas.drawCircle(Offset.zero, 36 + math.sin(engine.animTime * 20) * 3, Paint()..color = const Color(0xFFFB923C).withValues(alpha: 0.38));
    }
    if (selected) {
      canvas.drawCircle(Offset.zero, 31, Paint()..color = skin.glowColor.withValues(alpha: 0.35)..style = PaintingStyle.stroke..strokeWidth = 2);
    }
    canvas.drawCircle(Offset.zero, PendulumEngine.heavyRadius, Paint()..color = const Color(0xFF1E293B));
    canvas.drawCircle(Offset.zero, PendulumEngine.heavyRadius, Paint()..color = smashHot ? const Color(0xFFFBBF24) : skin.primaryColor..style = PaintingStyle.stroke..strokeWidth = 4.5);
    canvas.drawCircle(Offset.zero, 10, Paint()..color = smashHot ? const Color(0xFFF97316) : skin.glowColor);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant PendulumPainter oldDelegate) => true;
}
