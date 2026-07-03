class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });

  String get formattedTime {
    return "\${timestamp.hour.toString().padLeft(2, '0')}:\${timestamp.minute.toString().padLeft(2, '0')}";
  }
}
