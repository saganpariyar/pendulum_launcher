import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pendulum_launcher/engine/pendulum_engine.dart';
import 'package:pendulum_launcher/main.dart';
import 'package:pendulum_launcher/models/customization.dart';
import 'package:pendulum_launcher/models/levels.dart';

void main() {
  test('Customization catalog provides 4 options per selection', () {
    expect(CustomizationCatalog.lightProfiles.length, 4);
    expect(CustomizationCatalog.heavyProfiles.length, 4);
    expect(CustomizationCatalog.backgrounds.length, 4);
    expect(CustomizationCatalog.tetherStyles.length, 4);
    expect(CustomizationCatalog.pilotBadges.length, 4);
  });

  test('Pendulum Launcher grapples ceiling pivot and smashes barrier with Heavy swing', () {
    final levels = PendulumLevels.buildAll();
    expect(levels.length, 6);
    final engine = PendulumEngine(initialLevelIndex: 0);

    // Move Light near ceiling anchor hook horizontal X and grapple ceiling
    engine.lightPos = const Offset(550, 200);
    engine.toggleCeilingGrapple();
    expect(engine.lightAnchored, isTrue);

    // Swing Heavy rightward and trigger wrecking-ball smash boost
    engine.heavyPos = const Offset(520, 350);
    engine.heavyMoveInput = 1.0;
    engine.boostHeavySwing();
    for (int i = 0; i < 120; i++) {
      engine.step(0.016);
      if (engine.level.barriers.first.isDestroyed) break;
    }
    expect(engine.level.barriers.first.isDestroyed, isTrue);
  });

  testWidgets('Pendulum Launcher HomeScreen renders title, customization, and levels', (tester) async {
    await tester.pumpWidget(const PendulumLauncherApp());
    await tester.pumpAndSettle();

    expect(find.text('PENDULUM LAUNCHER'), findsOneWidget);
    expect(find.text('First Demolition'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNWidgets(4));
  });
}
