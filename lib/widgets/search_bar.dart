import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final String hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool enabled;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Search tasks...',
    this.initialValue,
    this.onChanged,
    this.onClear,
    this.enabled = true,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    setState(() {
      _hasFocus = hasFocus;
    });

    if (hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onClear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _hasFocus
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: _controller,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        onTap: () => _onFocusChange(true),
        onTapOutside: (_) => _onFocusChange(false),
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(
            Icons.search,
            color: _hasFocus
                ? theme.colorScheme.primary
                : theme.textTheme.bodyMedium?.color,
          ),
          suffixIcon: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return _controller.text.isNotEmpty
                  ? FadeTransition(
                      opacity: _fadeAnimation,
                      child: IconButton(
                        onPressed: _onClear,
                        icon: const Icon(Icons.clear),
                        tooltip: 'Clear search',
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: _hasFocus ? theme.colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
          filled: true,
          fillColor: _hasFocus
              ? theme.colorScheme.primary.withOpacity(0.05)
              : theme.colorScheme.surface,
        ),
      ),
    );
  }
}
