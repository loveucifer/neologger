import 'package:flutter/material.dart';
import 'package:neologger/constants.dart';

class NeologgerButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final IconData? icon;
  final bool outlined;

  const NeologgerButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.icon,
    this.outlined = false,
  });

  @override
  State<NeologgerButton> createState() => _NeologgerButtonState();
}

class _NeologgerButtonState extends State<NeologgerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: widget.outlined
                ? Colors.transparent
                : AppColors.textPrimary,
            borderRadius: BorderRadius.circular(8),
            border: widget.outlined
                ? Border.all(color: AppColors.textPrimary)
                : null,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: widget.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.background),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 18, color: widget.outlined ? AppColors.textPrimary : AppColors.background),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        fontWeight: AppFonts.semiBold,
                        color: widget.outlined ? AppColors.textPrimary : AppColors.background,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}