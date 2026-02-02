import 'package:drift/drift.dart';
import '../database.dart';

part 'chat_dao.g.dart';

/// Data Access Object for ChatMessages table
/// Manages conversation history with AI
@DriftAccessor(tables: [ChatMessages])
class ChatDao extends DatabaseAccessor<AppDatabase> with _$ChatDaoMixin {
  ChatDao(super.db);

  // ============================================================================
  // CREATE
  // ============================================================================

  /// Insert a new message
  Future<int> insertMessage(ChatMessagesCompanion message) async {
    return await into(chatMessages).insert(message);
  }

  /// Add user message
  Future<int> addUserMessage(String content, {String? contextJson}) async {
    return await into(chatMessages).insert(ChatMessagesCompanion.insert(
      content: content,
      isUser: true,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      contextJson: Value(contextJson),
    ));
  }

  /// Add AI response
  Future<int> addAiMessage(String content, {String? contextJson}) async {
    return await into(chatMessages).insert(ChatMessagesCompanion.insert(
      content: content,
      isUser: false,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      contextJson: Value(contextJson),
    ));
  }

  // ============================================================================
  // READ
  // ============================================================================

  /// Get all messages ordered by timestamp
  Future<List<ChatMessage>> getAll() async {
    return await (select(chatMessages)
      ..orderBy([(m) => OrderingTerm.asc(m.timestamp)]))
      .get();
  }

  /// Get recent messages
  Future<List<ChatMessage>> getRecent({int limit = 50}) async {
    return await (select(chatMessages)
      ..orderBy([(m) => OrderingTerm.desc(m.timestamp)])
      ..limit(limit))
      .get();
  }

  /// Get messages for display (ordered ascending)
  Future<List<ChatMessage>> getForDisplay({int limit = 100}) async {
    final messages = await getRecent(limit: limit);
    return messages.reversed.toList();
  }

  /// Get message by ID
  Future<ChatMessage?> getById(int id) async {
    return await (select(chatMessages)..where((m) => m.id.equals(id))).getSingleOrNull();
  }

  /// Get last N messages for Gemini context
  Future<String> getContextForGemini({int limit = 20}) async {
    final messages = await getRecent(limit: limit);
    final reversed = messages.reversed.toList();

    final buffer = StringBuffer();
    for (final msg in reversed) {
      final role = msg.isUser ? 'User' : 'Assistant';
      buffer.writeln('$role: ${msg.content}');
    }

    return buffer.toString();
  }

  /// Get total message count
  Future<int> getMessageCount() async {
    final all = await getAll();
    return all.length;
  }

  // ============================================================================
  // DELETE
  // ============================================================================

  /// Delete message by ID
  Future<void> deleteById(int id) async {
    await (delete(chatMessages)..where((m) => m.id.equals(id))).go();
  }

  /// Clear all messages
  Future<void> clearAll() async {
    await delete(chatMessages).go();
  }

  /// Delete old messages (keep last N)
  Future<int> deleteOld({int keepLast = 100}) async {
    final all = await (select(chatMessages)
      ..orderBy([(m) => OrderingTerm.desc(m.timestamp)]))
      .get();

    if (all.length <= keepLast) return 0;

    final toDelete = all.skip(keepLast).toList();
    int deleted = 0;

    for (final msg in toDelete) {
      await deleteById(msg.id);
      deleted++;
    }

    return deleted;
  }

  // ============================================================================
  // WATCH
  // ============================================================================

  /// Watch all messages (for chat screen)
  Stream<List<ChatMessage>> watchMessages() {
    return (select(chatMessages)
      ..orderBy([(m) => OrderingTerm.asc(m.timestamp)]))
      .watch();
  }

  /// Watch message count
  Stream<int> watchMessageCount() {
    return watchMessages().map((msgs) => msgs.length);
  }
}
