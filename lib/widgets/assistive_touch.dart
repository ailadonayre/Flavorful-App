import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_theme.dart';
import 'sdg_popup.dart';

/// AssistiveTouch-like floating button that can be dragged vertically
/// along the right edge of the screen. Persists position using SharedPreferences.
class AssistiveTouch extends StatefulWidget {
  const AssistiveTouch({Key? key}) : super(key: key);

  @override
  State<AssistiveTouch> createState() => _AssistiveTouchState();
}

class _AssistiveTouchState extends State<AssistiveTouch> {
  static const String _positionKey = 'assistive_touch_offset';
  static const double _buttonSize = 60.0;
  static const double _rightOffset = 16.0;

  double _verticalPosition = 0.5; // Fraction of screen height (0.0 to 1.0)
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _loadPosition();
  }

  /// Load saved vertical position from SharedPreferences
  Future<void> _loadPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPosition = prefs.getDouble(_positionKey);
    if (savedPosition != null && mounted) {
      setState(() {
        _verticalPosition = savedPosition;
      });
    }
  }

  /// Save vertical position to SharedPreferences
  Future<void> _savePosition(double position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_positionKey, position);
  }

  /// Show the SDG popup when button is tapped
  void _showSDGPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const SDGPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final availableHeight = screenHeight - safeAreaTop - safeAreaBottom - _buttonSize;

    // Calculate actual top position based on fraction
    final topPosition = safeAreaTop + (_verticalPosition * availableHeight);

    return Positioned(
      right: _rightOffset,
      top: topPosition,
      child: GestureDetector(
        onTap: _showSDGPopup,
        onPanStart: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            // Calculate new position as fraction
            final newTop = topPosition + details.delta.dy;
            final clampedTop = newTop.clamp(safeAreaTop, screenHeight - safeAreaBottom - _buttonSize);
            _verticalPosition = (clampedTop - safeAreaTop) / availableHeight;
          });
        },
        onPanEnd: (_) {
          setState(() {
            _isPressed = false;
          });
          _savePosition(_verticalPosition);
        },
        child: AnimatedScale(
          scale: _isPressed ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Semantics(
            label: 'SDG Information Button',
            hint: 'Double tap to view SDG information',
            button: true,
            child: Container(
              width: _buttonSize,
              height: _buttonSize,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6), // Off-white / very light grey
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  'assets/img/sdg_logo.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if asset is missing
                    return const Text(
                      'SDG',
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}