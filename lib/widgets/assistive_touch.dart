import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_theme.dart';
import 'sdg_popup.dart';

class AssistiveTouch extends StatefulWidget {
  const AssistiveTouch({Key? key}) : super(key: key);

  @override
  State<AssistiveTouch> createState() => _AssistiveTouchState();
}

class _AssistiveTouchState extends State<AssistiveTouch> {
  static const String _positionXKey = 'assistive_touch_x';
  static const String _positionYKey = 'assistive_touch_y';
  static const double _buttonSize = 60.0;
  static const double _edgePadding = 2.0;

  double _xPosition = 0.85; 
  double _yPosition = 0.5;  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _loadPosition();
  }

  Future<void> _loadPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final savedX = prefs.getDouble(_positionXKey);
    final savedY = prefs.getDouble(_positionYKey);
    
    if (savedX != null && savedY != null && mounted) {
      setState(() {
        _xPosition = savedX;
        _yPosition = savedY;
      });
    }
  }

  Future<void> _savePosition() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_positionXKey, _xPosition);
    await prefs.setDouble(_positionYKey, _yPosition);
  }

  void _showSDGPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const SDGPopup(),
    );
  }

  void _snapToEdge() {
    setState(() {
      if (_xPosition < 0.5) {
        _xPosition = 0.0; 
      } else {
        _xPosition = 1.0; 
      }
    });
    _savePosition();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    final availableWidth = size.width - _buttonSize - (_edgePadding * 2);
    final availableHeight = size.height - padding.top - padding.bottom - _buttonSize - (_edgePadding * 2);

    final left = _edgePadding + (_xPosition * availableWidth);
    final top = padding.top + _edgePadding + (_yPosition * availableHeight);

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: _showSDGPopup,
        onPanStart: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            final newLeft = left + details.delta.dx;
            final newTop = top + details.delta.dy;

            final clampedLeft = newLeft.clamp(
              _edgePadding,
              size.width - _buttonSize - _edgePadding,
            );
            final clampedTop = newTop.clamp(
              padding.top + _edgePadding,
              size.height - padding.bottom - _buttonSize - _edgePadding,
            );

            _xPosition = (clampedLeft - _edgePadding) / availableWidth;
            _yPosition = (clampedTop - padding.top - _edgePadding) / availableHeight;
          });
        },
        onPanEnd: (_) {
          setState(() {
            _isPressed = false;
          });
          _snapToEdge(); 
        },
        child: AnimatedScale(
          scale: _isPressed ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: AnimatedSlide(
            offset: Offset.zero,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: Semantics(
              label: 'SDG Information Button',
              hint: 'Double tap to view SDG information',
              button: true,
              child: Container(
                width: _buttonSize,
                height: _buttonSize,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6), 
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isPressed ? 0.25 : 0.15),
                      blurRadius: _isPressed ? 12 : 8,
                      offset: Offset(0, _isPressed ? 6 : 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Image.asset(
                    'assets/img/sdg_logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          'SDG',
                          style: TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}