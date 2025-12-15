import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String avatar;

  const ChatScreen({
    super.key,
    required this.name,
    required this.avatar,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController msgCtrl = TextEditingController();

  // Dummy messages
  final List<Map<String, dynamic>> messages = [
    {"fromMe": false, "text": "Hey, are you available for a shoot next week?", "time": "10:21 AM"},
    {"fromMe": true, "text": "Yes, I am available. Send me the details!", "time": "10:23 AM"},
    {"fromMe": false, "text": "Perfect! Will share the brief soon.", "time": "10:25 AM"},
    {"fromMe": true, "text": "Sounds good 👍", "time": "10:26 AM"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),

      // -------------------------------------------------------------------------
      // APP BAR
      // -------------------------------------------------------------------------
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0B1A),
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.avatar),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.name, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 2),
            const Text("Online",
                style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_vert, color: Colors.white),
          )
        ],
      ),

      // -------------------------------------------------------------------------
      // BODY — MESSAGES
      // -------------------------------------------------------------------------
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _messageBubble(
                  text: msg["text"],
                  time: msg["time"],
                  fromMe: msg["fromMe"],
                );
              },
            ),
          ),

          // ---------------------------------------------------------------------
          // INPUT BAR
          // ---------------------------------------------------------------------
          _inputBar(),
        ],
      ),
    );
  }

  // ============================================================================
  // MESSAGE BUBBLE
  // ============================================================================
  Widget _messageBubble({
    required String text,
    required String time,
    required bool fromMe,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: const BoxConstraints(maxWidth: 260),
            decoration: BoxDecoration(
              gradient: fromMe
                  ? const LinearGradient(colors: [Colors.purple, Colors.pink])
                  : null,
              color: fromMe ? null : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(14),
                topRight: const Radius.circular(14),
                bottomLeft:
                fromMe ? const Radius.circular(14) : const Radius.circular(2),
                bottomRight:
                fromMe ? const Radius.circular(2) : const Radius.circular(14),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // INPUT BAR
  // ============================================================================
  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: const Border(
          top: BorderSide(color: Colors.white24),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.add, color: Colors.purpleAccent.shade100, size: 26),

          const SizedBox(width: 10),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: msgCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Message...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: () {
              if (msgCtrl.text.trim().isEmpty) return;

              setState(() {
                messages.add({
                  "fromMe": true,
                  "text": msgCtrl.text.trim(),
                  "time": "Now",
                });
              });

              msgCtrl.clear();
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient:
                const LinearGradient(colors: [Colors.pink, Colors.purple]),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
