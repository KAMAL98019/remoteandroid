import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class TVRemoteHomePage extends StatefulWidget {
  @override
  _TVRemoteHomePageState createState() => _TVRemoteHomePageState();
}

class _TVRemoteHomePageState extends State<TVRemoteHomePage> {
  String _message = "Use the remote to navigate and select buttons";
  bool _isKeyboardVisible = false;
  bool _isTVOn = false;
  int _volume = 0;
  int _channel = 1;

  @override
  void initState() {
    super.initState();

    // Listen to keyboard visibility changes
    KeyboardVisibilityController().onChange.listen((bool isVisible) {
      setState(() {
        _isKeyboardVisible = isVisible;
        _message = isVisible
            ? "Keyboard is visible!"
            : "Keyboard is hidden! Use the remote buttons.";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityProvider(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Google TV Remote'),
          backgroundColor: Color.fromARGB(255, 129, 167, 248),
        ),
        backgroundColor: Colors.grey[200],
        body: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.arrowUp): const ActivateIntent(),
            LogicalKeySet(LogicalKeyboardKey.arrowDown): const ActivateIntent(),
            LogicalKeySet(LogicalKeyboardKey.arrowLeft): const ActivateIntent(),
            LogicalKeySet(LogicalKeyboardKey.arrowRight): const ActivateIntent(),
            LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              ActivateIntent: CallbackAction<Intent>(
                onInvoke: (intent) => _handleKeyPress(intent as ActivateIntent),
              ),
            },
            child: Focus(
              autofocus: true,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCircularButton(
                      Icons.power_settings_new, // Icon for power
                      _togglePower,
                      color: _isTVOn ? Colors.grey : Colors.red,
                      label: "Power",
                    ),
                    SizedBox(height: 20),
                    // Volume Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCircularButton(
                          Icons.volume_down, // Volume down icon
                          _decreaseVolume,
                          label: "Vol -",
                        ),
                        SizedBox(width: 20),
                        _buildCircularButton(
                          Icons.volume_up, // Volume up icon
                          _increaseVolume,
                          label: "Vol +",
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Channel Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCircularButton(
                          Icons.arrow_downward, // Channel down icon
                          _decreaseChannel,
                          label: "Ch -",
                        ),
                        SizedBox(width: 20),
                        _buildCircularButton(
                          Icons.arrow_upward, // Channel up icon
                          _increaseChannel,
                          label: "Ch +",
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Directional buttons
                    _buildCircularButton(Icons.arrow_upward, () {
                      setState(() {
                        _message = "Up button pressed!";
                      });
                    }),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCircularButton(Icons.arrow_back, () {
                          setState(() {
                            _message = "Left button pressed!";
                          });
                        }),
                        SizedBox(width: 20),
                        _buildCircularButton(Icons.check, () {
                          setState(() {
                            _message = "Select button pressed!";
                          });
                        }),
                        SizedBox(width: 20),
                        _buildCircularButton(Icons.arrow_forward, () {
                          setState(() {
                            _message = "Right button pressed!";
                          });
                        }),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildCircularButton(Icons.arrow_downward, () {
                      setState(() {
                        _message = "Down button pressed!";
                      });
                    }),
                    SizedBox(height: 40),
                    // Message Display
                    Text(
                      _message,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Handle key press events using LogicalKeySet
  void _handleKeyPress(ActivateIntent intent) {
    setState(() {
      _message = "Key event handled!";
    });
  }

  // Build a circular button
  Widget _buildCircularButton(
      IconData icon, VoidCallback onPressed, {Color color = Colors.grey, String? label}) {
    return Container(
      width: 80,
      height: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(15),
          primary: color,
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.white,
            ),
            if (label != null) // Optional label below the icon
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  // Power toggle function
  void _togglePower() {
    setState(() {
      _isTVOn = !_isTVOn;
      _message = _isTVOn ? "TV is ON" : "TV is OFF";
      if (!_isTVOn) {
        _volume = 0; // Reset volume when TV is off
      }
    });
  }

  // Volume control functions
  void _increaseVolume() {
    if (_isTVOn) {
      setState(() {
        _volume++;
        _message = "Volume: $_volume";
      });
    }
  }

  void _decreaseVolume() {
    if (_isTVOn && _volume > 0) {
      setState(() {
        _volume--;
        _message = "Volume: $_volume";
      });
    }
  }

  // Channel control functions
  void _increaseChannel() {
    if (_isTVOn) {
      setState(() {
        _channel++;
        _message = "Channel: $_channel";
      });
    }
  }

  void _decreaseChannel() {
    if (_isTVOn && _channel > 1) {
      setState(() {
        _channel--;
        _message = "Channel: $_channel";
      });
    }
  }
}
