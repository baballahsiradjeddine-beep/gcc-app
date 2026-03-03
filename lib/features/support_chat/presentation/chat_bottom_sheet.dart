import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/common/data/configs.dart';
import '../logic/chat_notifier.dart';

class ChatBottomSheet extends HookConsumerWidget {
  const ChatBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatNotifierProvider);
    final textController = useTextEditingController();
    final scrollController = useScrollController();

    // Scroll to bottom when messages change
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: 300.ms,
            curve: Curves.easeOut,
          );
        }
      });
      return null;
    }, [chatState.messages.length]);

    return Container(
      height: 0.85.sh,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(35.r)),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          // Header
          _ChatHeader(),

          // Messages List
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.all(20.w),
              children: [
                ...chatState.messages.map((m) => _MessageBubble(message: m)).toList(),
                if (chatState.isLoading) _TitoTypingIndicator(),
                if (chatState.messages.length <= 1 && !chatState.isLoading)
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: _QuickSuggestions(
                      showCentered: true,
                      onSelect: (q) => ref.read(chatNotifierProvider.notifier).sendMessage(q),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom Suggestions (only when there is a conversation)
          if (chatState.messages.length > 1)
            _QuickSuggestions(
              onSelect: (q) => ref.read(chatNotifierProvider.notifier).sendMessage(q),
            ),

          // Input Area
          _ChatInput(controller: textController, isLoading: chatState.isLoading),
          16.verticalSpace,
        ],
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white24),
            onPressed: () => Navigator.pop(context),
          ),
          Row(
            children: [
              Text(
                'تيتو الذكي 🐬',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SomarSans',
                ),
              ),
              12.horizontalSpace,
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(width: 48), // Spacer for balance
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h, top: 4.h),
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF1E293B) : const Color(0xFF00B4D8).withOpacity(0.1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
            bottomLeft: isUser ? Radius.zero : Radius.circular(20.r),
            bottomRight: isUser ? Radius.circular(20.r) : Radius.zero,
          ),
          border: Border.all(
            color: isUser ? Colors.white.withOpacity(0.05) : const Color(0xFF00B4D8).withOpacity(0.2),
          ),
        ),
        child: Text(
          message.text,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: 'SomarSans',
            height: 1.4,
          ),
        ),
      ).animate().fadeIn(duration: 400.ms, curve: Curves.easeOut).moveY(begin: 10, end: 0),
    );
  }
}

class _TitoTypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(12.w),
        margin: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('يُفكر تيتو... 🐬', style: TextStyle(color: Colors.white24, fontSize: 12.sp, fontFamily: 'SomarSans')),
            10.horizontalSpace,
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00B4D8)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInput extends ConsumerWidget {
  final TextEditingController controller;
  final bool isLoading;

  const _ChatInput({required this.controller, required this.isLoading});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          IconButton(
            onPressed: isLoading ? null : () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                ref.read(chatNotifierProvider.notifier).sendMessage(text);
                controller.clear();
              }
            },
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFEC4899),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              onSubmitted: isLoading ? null : (val) {
                if (val.trim().isNotEmpty) {
                  ref.read(chatNotifierProvider.notifier).sendMessage(val.trim());
                  controller.clear();
                }
              },
              style: const TextStyle(color: Colors.white, fontFamily: 'SomarSans'),
              decoration: InputDecoration(
                hintText: 'اسأل تيتو أي شيء...',
                hintStyle: TextStyle(color: Colors.white24, fontSize: 14.sp, fontFamily: 'SomarSans'),
                fillColor: const Color(0xFF1E293B),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.r), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickSuggestions extends ConsumerWidget {
  final Function(String) onSelect;
  final bool showCentered;
  const _QuickSuggestions({required this.onSelect, this.showCentered = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configs = ref.watch(configsProvider).valueOrNull;
    final List<String> questions = (configs?.titoQaList != null && configs!.titoQaList.isNotEmpty)
        ? configs.titoQaList
        : [
            "كم سعر الاشتراك؟",
            "ما هي المواد المتاحة؟",
            "ما هو هدف التطبيق؟",
            "كيف أتواصل معكم؟"
          ];
    
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: questions.map((q) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
        child: InkWell(
          onTap: () => onSelect(q),
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            width: showCentered ? 0.8.sw : double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF00B4D8).withOpacity(0.08),
              border: Border.all(color: const Color(0xFF00B4D8).withOpacity(0.2)),
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: Text(
              q,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF00B4D8),
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'SomarSans',
              ),
            ),
          ),
        ),
      )).toList(),
    );

    if (showCentered) {
      return Center(
        child: content.animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: content,
    );
  }
}
