import 'package:flutter/material.dart';

class LightProfile {
  final String id;
  final String name;
  final String title;
  final String perk;
  final String assetPath;
  final Color primaryColor;
  final Color glowColor;

  const LightProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.perk,
    required this.assetPath,
    required this.primaryColor,
    required this.glowColor,
  });
}

class HeavyProfile {
  final String id;
  final String name;
  final String title;
  final String perk;
  final String assetPath;
  final Color primaryColor;
  final Color glowColor;

  const HeavyProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.perk,
    required this.assetPath,
    required this.primaryColor,
    required this.glowColor,
  });
}

class BackgroundThemeOption {
  final String id;
  final String name;
  final String subtitle;
  final String assetPath;
  final Color skyTint;
  final Color accentColor;
  final Color platformTopColor;
  final Color platformBodyColor;

  const BackgroundThemeOption({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.assetPath,
    required this.skyTint,
    required this.accentColor,
    required this.platformTopColor,
    required this.platformBodyColor,
  });
}

enum TetherPattern { plasma, steel, magChain, runic }

class TetherStyleOption {
  final String id;
  final String name;
  final String subtitle;
  final Color primaryColor;
  final Color pulseColor;
  final TetherPattern pattern;

  const TetherStyleOption({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.primaryColor,
    required this.pulseColor,
    required this.pattern,
  });
}

class PilotBadgeOption {
  final String id;
  final String name;
  final String callsign;
  final IconData icon;
  final Color badgeColor;

  const PilotBadgeOption({
    required this.id,
    required this.name,
    required this.callsign,
    required this.icon,
    required this.badgeColor,
  });
}

class CustomizationCatalog {
  static const List<LightProfile> lightProfiles = [
    LightProfile(
      id: 'aero_wisp',
      name: 'Aero-Wisp',
      title: 'Ceiling Grapple Ace',
      perk: 'Magnetic Vault Hook',
      assetPath: 'assets/images/profiles/light_aero_wisp.png',
      primaryColor: Color(0xFF38BDF8),
      glowColor: Color(0xFF22D3EE),
    ),
    LightProfile(
      id: 'volt_sprite',
      name: 'Volt-Sprite',
      title: 'Emerald Pivot Scout',
      perk: 'Gyro Ceiling Clamp',
      assetPath: 'assets/images/profiles/light_volt_sprite.png',
      primaryColor: Color(0xFF34D399),
      glowColor: Color(0xFF6EE7B7),
    ),
    LightProfile(
      id: 'solar_falcon',
      name: 'Solar-Falcon',
      title: 'Kinetic Pivot Wing',
      perk: 'Solar Swing Whip',
      assetPath: 'assets/images/profiles/light_solar_falcon.png',
      primaryColor: Color(0xFFFBBF24),
      glowColor: Color(0xFFFB7185),
    ),
    LightProfile(
      id: 'nebula_lynx',
      name: 'Nebula-Lynx',
      title: 'Apex Grapple Dasher',
      perk: 'Zero-Drag Swivel',
      assetPath: 'assets/images/profiles/light_nebula_lynx.png',
      primaryColor: Color(0xFFE879F9),
      glowColor: Color(0xFFC084FC),
    ),
  ];

  static const List<HeavyProfile> heavyProfiles = [
    HeavyProfile(
      id: 'titan_core',
      name: 'Titan-Core',
      title: 'Fiery Wrecking Sphere',
      perk: 'Kinetic Impact Shell',
      assetPath: 'assets/images/profiles/heavy_titan_core.png',
      primaryColor: Color(0xFFFB923C),
      glowColor: Color(0xFFFBBF24),
    ),
    HeavyProfile(
      id: 'bastion_mk4',
      name: 'Bastion-MK4',
      title: 'Cobalt Battering Orb',
      perk: 'Steel Siege Hull',
      assetPath: 'assets/images/profiles/heavy_bastion_mk4.png',
      primaryColor: Color(0xFF60A5FA),
      glowColor: Color(0xFF93C5FD),
    ),
    HeavyProfile(
      id: 'magma_atlas',
      name: 'Magma-Atlas',
      title: 'Molten Demolition Core',
      perk: 'Meteor Smash Aura',
      assetPath: 'assets/images/profiles/heavy_magma_atlas.png',
      primaryColor: Color(0xFFF43F5E),
      glowColor: Color(0xFFF97316),
    ),
    HeavyProfile(
      id: 'jade_bulwark',
      name: 'Jade-Bulwark',
      title: 'Monolith Breaker',
      perk: 'Runic Momentum Boost',
      assetPath: 'assets/images/profiles/heavy_jade_bulwark.png',
      primaryColor: Color(0xFF34D399),
      glowColor: Color(0xFFFBBF24),
    ),
  ];

  static const List<BackgroundThemeOption> backgrounds = [
    BackgroundThemeOption(
      id: 'crystal_vault',
      name: 'Crystal Vault',
      subtitle: 'Amethyst Ruin Cavern',
      assetPath: 'assets/images/backgrounds/bg_1.png',
      skyTint: Color(0xFF3B0764),
      accentColor: Color(0xFFC084FC),
      platformTopColor: Color(0xFF9333EA),
      platformBodyColor: Color(0xFF1E1B4B),
    ),
    BackgroundThemeOption(
      id: 'obsidian_siege',
      name: 'Obsidian Siege',
      subtitle: 'Ember Fortress Rampart',
      assetPath: 'assets/images/backgrounds/bg_2.png',
      skyTint: Color(0xFF450A0A),
      accentColor: Color(0xFFFB923C),
      platformTopColor: Color(0xFFEA580C),
      platformBodyColor: Color(0xFF271717),
    ),
    BackgroundThemeOption(
      id: 'clockwork_hall',
      name: 'Clockwork Hall',
      subtitle: 'Brass Gear Cathedral',
      assetPath: 'assets/images/backgrounds/bg_3.png',
      skyTint: Color(0xFF422006),
      accentColor: Color(0xFFFBBF24),
      platformTopColor: Color(0xFFD97706),
      platformBodyColor: Color(0xFF292524),
    ),
    BackgroundThemeOption(
      id: 'asteroid_quarry',
      name: 'Asteroid Quarry',
      subtitle: 'Cosmic Nebula Mine',
      assetPath: 'assets/images/backgrounds/bg_4.png',
      skyTint: Color(0xFF0F172A),
      accentColor: Color(0xFF38BDF8),
      platformTopColor: Color(0xFF0284C7),
      platformBodyColor: Color(0xFF0F172A),
    ),
  ];

  static const List<TetherStyleOption> tetherStyles = [
    TetherStyleOption(
      id: 'kinetic_plasma',
      name: 'Kinetic Plasma',
      subtitle: 'Supercharged Whip Beam',
      primaryColor: Color(0xFF34D399),
      pulseColor: Color(0xFFFFFFFF),
      pattern: TetherPattern.plasma,
    ),
    TetherStyleOption(
      id: 'wrecking_chain',
      name: 'Siege Chain',
      subtitle: 'Heavy Steel Links',
      primaryColor: Color(0xFF94A3B8),
      pulseColor: Color(0xFFFB923C),
      pattern: TetherPattern.steel,
    ),
    TetherStyleOption(
      id: 'mag_pendulum',
      name: 'Mag-Pendulum',
      subtitle: 'Orbital Sling Nodes',
      primaryColor: Color(0xFFC084FC),
      pulseColor: Color(0xFF38BDF8),
      pattern: TetherPattern.magChain,
    ),
    TetherStyleOption(
      id: 'runic_sling',
      name: 'Runic Sling',
      subtitle: 'Sunfire Hammer Cord',
      primaryColor: Color(0xFFFBBF24),
      pulseColor: Color(0xFFFB7185),
      pattern: TetherPattern.runic,
    ),
  ];

  static const List<PilotBadgeOption> pilotBadges = [
    PilotBadgeOption(
      id: 'wrecking_crest',
      name: 'Demolition Crest',
      callsign: 'SMASH-1',
      icon: Icons.hardware_rounded,
      badgeColor: Color(0xFFFB923C),
    ),
    PilotBadgeOption(
      id: 'pendulum_bolt',
      name: 'Kinetic Arc',
      callsign: 'SWING-X',
      icon: Icons.bolt_rounded,
      badgeColor: Color(0xFFC084FC),
    ),
    PilotBadgeOption(
      id: 'crystal_breaker',
      name: 'Crystal Breaker',
      callsign: 'CRUSH-9',
      icon: Icons.diamond_rounded,
      badgeColor: Color(0xFF38BDF8),
    ),
    PilotBadgeOption(
      id: 'ceiling_hook',
      name: 'Pivot Anchor',
      callsign: 'HOOK-7',
      icon: Icons.anchor_rounded,
      badgeColor: Color(0xFF34D399),
    ),
  ];
}
