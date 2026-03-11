import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  final String id;
  final String userId;
  final String content;
  final String? prompt;
  final String mood;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? updatedAt;

  JournalEntry({
    required this.id,
    required this.userId,
    required this.content,
    this.prompt,
    this.mood = 'content',
    this.tags = const [],
    required this.createdAt,
    this.updatedAt,
  });

  factory JournalEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JournalEntry(
      id: doc.id,
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      prompt: data['prompt'],
      mood: data['mood'] ?? 'content',
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'prompt': prompt,
      'mood': mood,
      'tags': tags,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}

class MoodOption {
  final String key;
  final String emoji;
  final String label;

  const MoodOption({required this.key, required this.emoji, required this.label});

  static const List<MoodOption> options = [
    MoodOption(key: 'grateful', emoji: '🤲', label: 'Grateful'),
    MoodOption(key: 'peaceful', emoji: '☮️', label: 'Peaceful'),
    MoodOption(key: 'content', emoji: '😊', label: 'Content'),
    MoodOption(key: 'reflective', emoji: '🤔', label: 'Reflective'),
    MoodOption(key: 'struggling', emoji: '💙', label: 'Struggling'),
    MoodOption(key: 'hopeful', emoji: '🌱', label: 'Hopeful'),
  ];
}
