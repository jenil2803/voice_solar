import 'dart:convert';
import 'package:http/http.dart' as http;

const String _baseUrl = 'http://127.0.0.1:8000';

/// Service for the AI agent endpoint and entity detail fetching.
class AgentService {
  // ── Agent Command ──────────────────────────────────────────────────────────

  /// Send a natural-language command to the agent.
  /// Returns the parsed JSON response from the backend.
  static Future<Map<String, dynamic>> sendCommand(String text) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/agent/command/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Agent request failed: ${response.statusCode}');
  }

  // ── Entity Detail Fetchers ─────────────────────────────────────────────────

  /// Fetch a single inverter by its MongoDB _id.
  static Future<Map<String, dynamic>> fetchInverterById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/inverter/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Inverter not found: ${response.statusCode}');
  }

  /// Fetch a single plant by its MongoDB _id.
  static Future<Map<String, dynamic>> fetchPlantById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/plant/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Plant not found: ${response.statusCode}');
  }

  /// Fetch a single sensor by its MongoDB _id.
  static Future<Map<String, dynamic>> fetchSensorById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/sensor/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Sensor not found: ${response.statusCode}');
  }
}
