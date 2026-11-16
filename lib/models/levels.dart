import 'package:flutter/material.dart';
import 'game_models.dart';

class PendulumLevels {
  static List<PendulumLevelDefinition> buildAll() => [
        // Level 1: First Demolition
        PendulumLevelDefinition(
          levelNumber: 1,
          title: 'First Demolition',
          subtitle: 'Ceiling Anchor & Wrecking Swing',
          hint: 'Tap GRAPPLE to lock Light onto the overhead ceiling hook, then swing Heavy (LEFT/RIGHT + BOOST) through the Stone Wall!',
          worldSize: const Size(1240, 640),
          lightSpawn: const Offset(220, 445),
          heavySpawn: const Offset(150, 437),
          goalZone: const Rect.fromLTWH(1060, 340, 96, 120),
          parSeconds: 26,
          blocks: const [
            SolidBlock(Rect.fromLTWH(20, 460, 1200, 180)),
            SolidBlock(Rect.fromLTWH(20, 0, 1200, 60)), // ceiling beam
          ],
          ceilingAnchors: const [
            CeilingAnchorPoint(Offset(600, 95), label: 'PIVOT 1'),
          ],
          barriers: [
            DestructibleBarrier(
              rect: const Rect.fromLTWH(760, 220, 44, 240),
              maxHp: 1,
              requiredSpeed: 220.0,
              color: const Color(0xFFF59E0B),
              materialName: 'Cracked Stone',
            ),
          ],
          corePositions: const [
            Offset(460, 290),
            Offset(600, 340),
            Offset(910, 380),
          ],
        ),

        // Level 2: Crystal Gate
        PendulumLevelDefinition(
          levelNumber: 2,
          title: 'Crystal Gate',
          subtitle: 'High-Arc 2-Hit Crystal Breach',
          hint: 'Grapple the high ceiling hook, swing Heavy wide & hit SMASH BOOST to shatter both layers of the Crystal Monolith!',
          worldSize: const Size(1300, 660),
          lightSpawn: const Offset(210, 325),
          heavySpawn: const Offset(130, 317),
          goalZone: const Rect.fromLTWH(1120, 360, 96, 120),
          parSeconds: 34,
          blocks: const [
            SolidBlock(Rect.fromLTWH(20, 340, 250, 320)), // elevated start ramp
            SolidBlock(Rect.fromLTWH(270, 480, 1010, 180)),
            SolidBlock(Rect.fromLTWH(20, 0, 1260, 60)),
          ],
          ceilingAnchors: const [
            CeilingAnchorPoint(Offset(640, 95), label: 'CRYSTAL PIVOT'),
          ],
          barriers: [
            DestructibleBarrier(
              rect: const Rect.fromLTWH(830, 210, 50, 270),
              maxHp: 2,
              requiredSpeed: 260.0,
              color: const Color(0xFFC084FC),
              materialName: 'Crystal Monolith',
            ),
          ],
          corePositions: const [
            Offset(430, 350),
            Offset(640, 390),
            Offset(980, 410),
          ],
        ),

        // Level 3: Twin Fortresses
        PendulumLevelDefinition(
          levelNumber: 3,
          title: 'Twin Fortresses',
          subtitle: 'Two Ceiling Pivots, Two Walls',
          hint: 'Smash Wall 1 from Ceiling Hook 1, unhook Light, grapple Ceiling Hook 2, and smash Wall 2!',
          worldSize: const Size(1480, 640),
          lightSpawn: const Offset(180, 445),
          heavySpawn: const Offset(110, 437),
          goalZone: const Rect.fromLTWH(1320, 340, 96, 120),
          parSeconds: 45,
          blocks: const [
            SolidBlock(Rect.fromLTWH(20, 460, 1440, 180)),
            SolidBlock(Rect.fromLTWH(20, 0, 1440, 60)),
          ],
          ceilingAnchors: const [
            CeilingAnchorPoint(Offset(470, 95), label: 'HOOK 1'),
            CeilingAnchorPoint(Offset(1010, 95), label: 'HOOK 2'),
          ],
          barriers: [
            DestructibleBarrier(
              rect: const Rect.fromLTWH(610, 220, 44, 240),
              maxHp: 1,
              requiredSpeed: 230.0,
              color: const Color(0xFFFB923C),
              materialName: 'Stone Gate',
            ),
            DestructibleBarrier(
              rect: const Rect.fromLTWH(1150, 200, 48, 260),
              maxHp: 2,
              requiredSpeed: 260.0,
              color: const Color(0xFF38BDF8),
              materialName: 'Cryo Barrier',
            ),
          ],
          corePositions: const [
            Offset(470, 330),
            Offset(790, 380),
            Offset(1010, 320),
          ],
        ),

        // Level 4: Armored Vault
        PendulumLevelDefinition(
          levelNumber: 4,
          title: 'Armored Vault',
          subtitle: 'Swing Above Hazard Spikes',
          hint: 'Shorten rope slightly while swinging so Heavy clears the floor spikes and blasts straight through the 3-HP Iron Vault!',
          worldSize: const Size(1360, 660),
          lightSpawn: const Offset(200, 365),
          heavySpawn: const Offset(125, 357),
          goalZone: const Rect.fromLTWH(1190, 270, 96, 120),
          parSeconds: 44,
          blocks: const [
            SolidBlock(Rect.fromLTWH(20, 380, 250, 280)),
            SolidBlock(Rect.fromLTWH(270, 520, 720, 140), isHazard: true), // hazard floor pit
            SolidBlock(Rect.fromLTWH(990, 390, 350, 270)),
            SolidBlock(Rect.fromLTWH(20, 0, 1320, 60)),
          ],
          ceilingAnchors: const [
            CeilingAnchorPoint(Offset(640, 95), label: 'VAULT HOOK'),
          ],
          barriers: [
            DestructibleBarrier(
              rect: const Rect.fromLTWH(940, 160, 50, 230),
              maxHp: 3,
              requiredSpeed: 265.0,
              color: const Color(0xFFF43F5E),
              materialName: 'Iron Bastion',
            ),
          ],
          corePositions: const [
            Offset(460, 320),
            Offset(640, 360),
            Offset(820, 310),
          ],
        ),

        // Level 5: Sky Fortress
        PendulumLevelDefinition(
          levelNumber: 5,
          title: 'Sky Fortress',
          subtitle: 'Upper Crystal & Lower Gate',
          hint: 'Break the elevated Crystal Shield first, then drop slightly to obliterate the lower fortress wall!',
          worldSize: const Size(1460, 680),
          lightSpawn: const Offset(190, 445),
          heavySpawn: const Offset(115, 437),
          goalZone: const Rect.fromLTWH(1290, 340, 96, 120),
          parSeconds: 48,
          blocks: const [
            SolidBlock(Rect.fromLTWH(20, 460, 420, 220)),
            SolidBlock(Rect.fromLTWH(440, 550, 340, 130), isHazard: true),
            SolidBlock(Rect.fromLTWH(780, 460, 660, 220)),
            SolidBlock(Rect.fromLTWH(20, 0, 1420, 60)),
          ],
          ceilingAnchors: const [
            CeilingAnchorPoint(Offset(550, 95), label: 'UPPER PIVOT'),
            CeilingAnchorPoint(Offset(960, 95), label: 'SIEGE PIVOT'),
          ],
          barriers: [
            DestructibleBarrier(
              rect: const Rect.fromLTWH(720, 140, 46, 220),
              maxHp: 2,
              requiredSpeed: 250.0,
              color: const Color(0xFFC084FC),
              materialName: 'Crystal Shield',
            ),
            DestructibleBarrier(
              rect: const Rect.fromLTWH(1120, 220, 52, 240),
              maxHp: 2,
              requiredSpeed: 265.0,
              color: const Color(0xFFFB923C),
              materialName: 'Fortress Door',
            ),
          ],
          corePositions: const [
            Offset(550, 290),
            Offset(850, 390),
            Offset(1010, 310),
          ],
        ),

        // Level 6: Citadel Core
        PendulumLevelDefinition(
          levelNumber: 6,
          title: 'Citadel Core',
          subtitle: 'Triple-Barrier Demolition Gauntlet',
          hint: 'Unleash maximum kinetic momentum across three ceiling pivots to breach the Citadel Core!',
          worldSize: const Size(1640, 680),
          lightSpawn: const Offset(180, 445),
          heavySpawn: const Offset(110, 437),
          goalZone: const Rect.fromLTWH(1480, 340, 96, 120),
          parSeconds: 60,
          blocks: const [
            SolidBlock(Rect.fromLTWH(20, 460, 520, 220)),
            SolidBlock(Rect.fromLTWH(540, 540, 300, 140), isHazard: true),
            SolidBlock(Rect.fromLTWH(840, 460, 800, 220)),
            SolidBlock(Rect.fromLTWH(20, 0, 1600, 60)),
          ],
          ceilingAnchors: const [
            CeilingAnchorPoint(Offset(410, 95), label: 'PIVOT 1'),
            CeilingAnchorPoint(Offset(860, 95), label: 'PIVOT 2'),
            CeilingAnchorPoint(Offset(1220, 95), label: 'CORE PIVOT'),
          ],
          barriers: [
            DestructibleBarrier(
              rect: const Rect.fromLTWH(520, 220, 42, 240),
              maxHp: 1,
              requiredSpeed: 230.0,
              color: const Color(0xFFFBBF24),
              materialName: 'Outer Wall',
            ),
            DestructibleBarrier(
              rect: const Rect.fromLTWH(990, 210, 48, 250),
              maxHp: 2,
              requiredSpeed: 265.0,
              color: const Color(0xFFC084FC),
              materialName: 'Crystal Bulkhead',
            ),
            DestructibleBarrier(
              rect: const Rect.fromLTWH(1340, 200, 52, 260),
              maxHp: 3,
              requiredSpeed: 280.0,
              color: const Color(0xFFF43F5E),
              materialName: 'Citadel Gate',
            ),
          ],
          corePositions: const [
            Offset(410, 330),
            Offset(860, 320),
            Offset(1220, 310),
          ],
        ),
      ];
}
