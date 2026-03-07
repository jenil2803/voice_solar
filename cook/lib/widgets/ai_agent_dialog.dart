import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../services/agent_service.dart';

class AIAgentDialog extends StatefulWidget {
  const AIAgentDialog({super.key});

  @override
  State<AIAgentDialog> createState() => _AIAgentDialogState();
}

class _AIAgentDialogState extends State<AIAgentDialog> {
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  
  bool _isLoading = false;
  bool _isListening = false;
  
  String _responseMessage = "How can I help you navigate today?";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _listen() async {
    if (!_isListening) {
      // First, ensure microphone permission is granted
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        setState(() => _responseMessage = "Microphone permission denied.");
        return;
      }

      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            setState(() => _isListening = false);
            // Auto-send when they stop speaking:
            if (_controller.text.isNotEmpty && !_isLoading) {
              _sendCommand(_controller.text);
            }
          }
        },
        onError: (val) {
          setState(() {
            _isListening = false;
            _responseMessage = "Error listening: ${val.errorMsg}";
          });
        },
      );
      
      if (available) {
        setState(() {
          _isListening = true;
          _responseMessage = "Listening...";
        });
        
        _speech.listen(
          onResult: (val) => setState(() {
            _controller.text = val.recognizedWords;
          }),
          cancelOnError: true,
        );
      } else {
        setState(() {
          _isListening = false;
          _responseMessage = "Speech recognition unavailable.";
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _sendCommand(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _responseMessage = "Thinking...";
    });

    try {
      final data = await AgentService.sendCommand(text);
      final action = data['action'] as String? ?? 'unknown';
      final message = data['message'] as String? ?? 'Done.';

      setState(() => _responseMessage = message);

      if (action == 'navigate' && data['route'] != null) {
        // For deep routes (/inverters/:id) the backend already resolved
        // params.id to a real MongoDB _id and replaced :id in the route.
        // We just navigate directly.
        final route = data['route'] as String;
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            Navigator.of(context).pop();
            context.go(route);
          }
        });
      }
      // For 'query' and 'action' we already set _responseMessage above,
      // so the user sees the result inline without any navigation.

    } catch (e) {
      setState(() {
        _responseMessage = "Network error. Make sure the backend is running.";
      });
    } finally {
      setState(() => _isLoading = false);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.sparkles, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              const Text(
                'AI Assistant',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.bot, color: Color(0xFF64748B), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _responseMessage,
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    hintText: 'e.g. "How much energy today?" or "Show inverter 3"',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  onSubmitted: _sendCommand,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _isLoading ? null : _listen,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _isListening ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _isListening ? LucideIcons.micOff : LucideIcons.mic,
                    color: _isListening ? Colors.red : const Color(0xFF64748B),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _isLoading
                    ? null
                    : () => _sendCommand(_controller.text),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _isLoading ? Colors.blue.withOpacity(0.5) : Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      if (!_isLoading)
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          LucideIcons.send,
                          color: Colors.white,
                          size: 24,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
