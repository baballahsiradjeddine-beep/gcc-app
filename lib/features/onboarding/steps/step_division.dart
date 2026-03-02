import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/features/onboarding/onboarding_notifier.dart';
import 'package:tayssir/features/onboarding/widgets/onboarding_button.dart';
import 'package:tayssir/features/onboarding/widgets/tito_speaker.dart';
import 'package:tayssir/providers/divisions/division_model.dart';
import 'package:tayssir/providers/divisions/divisions.dart';

class StepDivisionPage extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  const StepDivisionPage({super.key, required this.onNext});

  @override
  ConsumerState<StepDivisionPage> createState() => _StepDivisionPageState();
}

class _StepDivisionPageState extends ConsumerState<StepDivisionPage> {
  DivisionModel? _selected;

  Future<void> _handleNext() async {
    if (_selected == null) return;
    await ref
        .read(onboardingProvider.notifier)
        .setDivision(_selected!.id, _selected!.name);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(onboardingProvider).name ?? 'صديقي';
    final divisionsAsync = ref.watch(divisionsProvider);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          children: [
            60.verticalSpace,

            // ── Tito ──
            TitoSpeaker(
              message: 'رائع يا $name! 🎉\nفي أي شعبة أنت؟\nحتى أختار لك المواد المناسبة',
            ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0, curve: Curves.easeOutBack),

            28.verticalSpace,

            // ── Division List ──
            Expanded(
              child: divisionsAsync.when(
                data: (divisions) => ListView.builder(
                  itemCount: divisions.length,
                  itemBuilder: (_, i) {
                    final div = divisions[i];
                    final isSelected = _selected?.id == div.id;
                    return _DivisionTile(
                      division: div,
                      isSelected: isSelected,
                      index: i,
                      onTap: () => setState(() => _selected = div),
                    );
                  },
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00B4D8)),
                ),
                error: (e, _) => Center(
                  child: Text('خطأ في تحميل الشعب',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
                ),
              ),
            ),

            20.verticalSpace,

            // ── CTA ──
            OnboardingButton(
              label: 'متابعة →',
              enabled: _selected != null,
              onPressed: _handleNext,
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),

            32.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class _DivisionTile extends StatelessWidget {
  final DivisionModel division;
  final bool isSelected;
  final int index;
  final VoidCallback onTap;

  const _DivisionTile({
    required this.division,
    required this.isSelected,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          color: isSelected
              ? const Color(0xFF00B4D8).withOpacity(0.15)
              : const Color(0xFF1E293B),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00B4D8)
                : const Color(0xFF334155),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00B4D8).withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Check or empty circle
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isSelected
                  ? const Icon(Icons.check_circle_rounded,
                      color: Color(0xFF00B4D8), size: 26)
                  : Icon(Icons.circle_outlined,
                      color: const Color(0xFF475569), size: 26),
            ),
            // Division name
            Text(
              division.name,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                fontFamily: 'SomarSans',
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (index * 60).ms).slideX(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
    );
  }
}
