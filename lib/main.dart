import 'package:flutter/material.dart';

void main() {
  runApp(const TactileDeckApp());
}

class TactileDeckApp extends StatefulWidget {
  const TactileDeckApp({super.key});

  @override
  State<TactileDeckApp> createState() => _TactileDeckAppState();
}

class _TactileDeckAppState extends State<TactileDeckApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DJ Soundboard',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: ControlDeckScreen(
        isDark: isDarkMode,
        onToggleTheme: () => setState(() => isDarkMode = !isDarkMode),
      ),
    );
  }
}

class ControlDeckScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ControlDeckScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<ControlDeckScreen> createState() => _ControlDeckScreenState();
}

class _ControlDeckScreenState extends State<ControlDeckScreen> {
  int totalDrops = 0;
  double bpm = 120.0;
  String lastSound = "READY";
  bool partyMode = false;

  void _triggerSound(String soundName) {
    setState(() {
      totalDrops++;
      lastSound = "$soundName PLAYED";
      partyMode = totalDrops >= 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenBg = partyMode
        ? (widget.isDark
            ? const Color(0xFF301934)
            : const Color(0xFFFFE4F3))
        : (widget.isDark
            ? const Color(0xFF1E1F29)
            : const Color(0xFFE0E5EC));

    final cardBg =
        widget.isDark ? const Color(0xFF282A36) : Colors.white;

    return Scaffold(
      backgroundColor: screenBg,
      appBar: AppBar(
        title: const Text(
          "DJ SOUNDBOARD",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              widget.isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        child: Column(
          children: [
            const SoundboardHeader(),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      widget.isDark ? 0.3 : 0.08,
                    ),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MetricBadge(
                    title: "TOTAL DROPS",
                    value: "$totalDrops",
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  MetricBadge(
                    title: "BPM",
                    value: "${bpm.toInt()}",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "STATUS: $lastSound",
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
                color: widget.isDark
                    ? Colors.tealAccent
                    : Colors.teal.shade700,
              ),
            ),

            if (partyMode) ...[
              const SizedBox(height: 12),
              const Text(
                "PARTY MODE 🔥",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
            ],

            const SizedBox(height: 28),

            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                TactileButton(
                  icon: Icons.album,
                  label: "KICK",
                  accentColor: Colors.orangeAccent,
                  isDark: widget.isDark,
                  onPressed: () => _triggerSound("BASS KICK"),
                ),
                TactileButton(
                  icon: Icons.graphic_eq,
                  label: "BASS",
                  accentColor: Colors.blueAccent,
                  isDark: widget.isDark,
                  onPressed: () => _triggerSound("BASS DROP"),
                ),
                TactileButton(
                  icon: Icons.music_note,
                  label: "SYNTH",
                  accentColor: Colors.purpleAccent,
                  isDark: widget.isDark,
                  onPressed: () => _triggerSound("SYNTH"),
                ),
                TactileButton(
                  icon: Icons.loop,
                  label: "LOOP",
                  accentColor: Colors.greenAccent,
                  isDark: widget.isDark,
                  onPressed: () => _triggerSound("LOOP"),
                ),
              ],
            ),

            const SizedBox(height: 36),

            Text(
              "Tempo: ${bpm.toInt()} BPM",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),

            Slider(
              value: bpm,
              min: 60,
              max: 180,
              activeColor: Colors.purpleAccent,
              inactiveColor: Colors.grey.withOpacity(0.3),
              onChanged: (newVal) =>
                  setState(() => bpm = newVal),
            ),
          ],
        ),
      ),
    );
  }
}

class SoundboardHeader extends StatelessWidget {
  const SoundboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(
          Icons.headphones,
          size: 45,
          color: Colors.purpleAccent,
        ),
        SizedBox(height: 8),
        Text(
          "LIVE MIX CONTROL",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Tap sounds and control the tempo",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class MetricBadge extends StatelessWidget {
  final String title;
  final String value;

  const MetricBadge({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.purpleAccent,
          ),
        ),
      ],
    );
  }
}

class TactileButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final bool isDark;
  final VoidCallback onPressed;

  const TactileButton({
    super.key,
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.isDark,
    required this.onPressed,
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isDark
        ? const Color(0xFF222430)
        : const Color(0xFFE0E5EC);

    final darkShadow =
        widget.isDark ? Colors.black87 : const Color(0xFFA3B1C6);

    final lightShadow =
        widget.isDark ? const Color(0xFF2F3244) : Colors.white;

    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),

      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onPressed();
      },

      onTapCancel: () => setState(() => isPressed = false),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: darkShadow.withOpacity(0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: lightShadow.withOpacity(0.5),
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: darkShadow.withOpacity(0.7),
                    offset: const Offset(8, 8),
                    blurRadius: 16,
                  ),
                  BoxShadow(
                    color: lightShadow.withOpacity(0.9),
                    offset: const Offset(-8, -8),
                    blurRadius: 16,
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: isPressed ? 40 : 46,
              color: isPressed
                  ? widget.accentColor
                  : (widget.isDark
                      ? Colors.white70
                      : Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.1,
                color: isPressed
                    ? widget.accentColor
                    : (widget.isDark
                        ? Colors.white54
                        : Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}