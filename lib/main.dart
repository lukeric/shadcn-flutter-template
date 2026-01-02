import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(const DemoApp());
}

enum DemoTab { overview, forms, pickers, overlays, layouts }

enum BaseColor {
  slate('Slate'),
  gray('Gray'),
  zinc('Zinc'),
  neutral('Neutral'),
  stone('Stone');

  const BaseColor(this.label);
  final String label;
}

enum AccentColor {
  base('Match base'),
  blue('Blue'),
  green('Green'),
  orange('Orange'),
  red('Red'),
  rose('Rose'),
  violet('Violet'),
  yellow('Yellow');

  const AccentColor(this.label);
  final String label;
}

enum UiStyle {
  vega('Vega'),
  nova('Nova'),
  maia('Maia'),
  lyra('Lyra'),
  mira('Mira');

  const UiStyle(this.label);
  final String label;
}

enum NotifyOption {
  everything('Everything'),
  mentions('Mentions'),
  none('None');

  const NotifyOption(this.label);
  final String label;
}

const frameworks = {
  'flutter': 'Flutter',
  'react_native': 'React Native',
  'swiftui': 'SwiftUI',
  'kotlin': 'Kotlin Multiplatform',
  'ionic': 'Ionic',
};

const quickNotes = [
  (
    title: 'Can I theme it?',
    body: 'Yes. Change the ShadThemeData colorScheme or variant.',
  ),
  (
    title: 'Is it mobile-friendly?',
    body: 'Yes. The demos are tuned for small screens.',
  ),
  (
    title: 'Does it animate?',
    body: 'Yes. Overlays and toasts include motion by default.',
  ),
];

const invoices = [
  (
    id: 'INV-1001',
    status: 'Paid',
    amount: r'$320.00',
  ),
  (
    id: 'INV-1002',
    status: 'Pending',
    amount: r'$180.00',
  ),
  (
    id: 'INV-1003',
    status: 'Unpaid',
    amount: r'$74.50',
  ),
];

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  ThemeMode _themeMode = ThemeMode.light;
  BaseColor _baseColor = BaseColor.stone;
  UiStyle _style = UiStyle.vega;
  AccentColor _accentColor = AccentColor.base;

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  void _setBaseColor(BaseColor color) {
    setState(() => _baseColor = color);
  }

  void _setStyle(UiStyle style) {
    setState(() => _style = style);
  }

  void _setAccentColor(AccentColor color) {
    setState(() => _accentColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      debugShowCheckedModeBanner: false,
      title: 'Shadcn Mobile',
      themeMode: _themeMode,
      scrollBehavior: const _NoScrollbarScrollBehavior(),
      theme: _themeFor(Brightness.light, _baseColor, _accentColor, _style),
      darkTheme: _themeFor(Brightness.dark, _baseColor, _accentColor, _style),
      builder: (context, child) {
        final content = child ?? const SizedBox.shrink();
        return ShadToaster(
          child: ShadSonner(
            child: content,
          ),
        );
      },
      home: DemoHome(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
        baseColor: _baseColor,
        onBaseColorChanged: _setBaseColor,
        accentColor: _accentColor,
        onAccentColorChanged: _setAccentColor,
        style: _style,
        onStyleChanged: _setStyle,
      ),
    );
  }
}

class DemoHome extends StatefulWidget {
  const DemoHome({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.baseColor,
    required this.onBaseColorChanged,
    required this.accentColor,
    required this.onAccentColorChanged,
    required this.style,
    required this.onStyleChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final BaseColor baseColor;
  final ValueChanged<BaseColor> onBaseColorChanged;
  final AccentColor accentColor;
  final ValueChanged<AccentColor> onAccentColorChanged;
  final UiStyle style;
  final ValueChanged<UiStyle> onStyleChanged;

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  DemoTab _tab = DemoTab.overview;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.background,
            theme.colorScheme.muted,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _tab.index,
                children: [
                  OverviewTab(
                    themeMode: widget.themeMode,
                    onThemeModeChanged: widget.onThemeModeChanged,
                    baseColor: widget.baseColor,
                    onBaseColorChanged: widget.onBaseColorChanged,
                    accentColor: widget.accentColor,
                    onAccentColorChanged: widget.onAccentColorChanged,
                    style: widget.style,
                    onStyleChanged: widget.onStyleChanged,
                  ),
                  const FormsTab(),
                  const PickersTab(),
                  const OverlaysTab(),
                  const LayoutsTab(),
                ],
              ),
            ),
            BottomNavBar(
              value: _tab,
              onChanged: (value) => setState(() => _tab = value),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final DemoTab value;
  final ValueChanged<DemoTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.colorScheme.border),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.foreground.withAlpha(30),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: DemoTab.values
                .map(
                  (tab) => Expanded(
                    child: _BottomNavItem(
                      tab: tab,
                      isSelected: tab == value,
                      onTap: () => onChanged(tab),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final DemoTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  IconData get icon => switch (tab) {
    DemoTab.overview => LucideIcons.sparkles,
    DemoTab.forms => LucideIcons.keyboard,
    DemoTab.pickers => LucideIcons.calendarDays,
    DemoTab.overlays => LucideIcons.layers,
    DemoTab.layouts => LucideIcons.layoutPanelTop,
  };

  String get label => switch (tab) {
    DemoTab.overview => 'Overview',
    DemoTab.forms => 'Forms',
    DemoTab.pickers => 'Pickers',
    DemoTab.overlays => 'Overlays',
    DemoTab.layouts => 'Layouts',
  };

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final foreground = isSelected
        ? theme.colorScheme.primaryForeground
        : theme.colorScheme.mutedForeground;
    final labelStyle = theme.textTheme.small.copyWith(
      fontSize: 11,
      color: foreground,
      height: 1,
    );
    const buttonPadding = EdgeInsets.symmetric(vertical: 4, horizontal: 2);
    final labelWidget = FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: labelStyle,
      ),
    );

    final button = isSelected
        ? ShadButton(
            onPressed: onTap,
            expands: true,
            height: 56,
            padding: buttonPadding,
            backgroundColor: theme.colorScheme.primary,
            hoverBackgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.primaryForeground,
            hoverForegroundColor: theme.colorScheme.primaryForeground,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: foreground),
                const SizedBox(height: 2),
                SizedBox(height: 14, child: labelWidget),
              ],
            ),
          )
        : ShadButton.ghost(
            onPressed: onTap,
            expands: true,
            height: 56,
            padding: buttonPadding,
            foregroundColor: foreground,
            hoverForegroundColor: theme.colorScheme.foreground,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: foreground),
                const SizedBox(height: 2),
                SizedBox(height: 14, child: labelWidget),
              ],
            ),
          );

    return button;
  }
}

class OverviewTab extends StatelessWidget {
  const OverviewTab({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.baseColor,
    required this.onBaseColorChanged,
    required this.accentColor,
    required this.onAccentColorChanged,
    required this.style,
    required this.onStyleChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final BaseColor baseColor;
  final ValueChanged<BaseColor> onBaseColorChanged;
  final AccentColor accentColor;
  final ValueChanged<AccentColor> onAccentColorChanged;
  final UiStyle style;
  final ValueChanged<UiStyle> onStyleChanged;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isDark = themeMode == ThemeMode.dark;
    return TabScaffold(
      children: [
        ShadCard(
          leading: ShadAvatar(
            null,
            placeholder: const Text('SL'),
            size: const Size.square(44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          title: const Text('Shadcn UI Mobile Lab'),
          description: const Text(
            'Five tabs of mobile-ready components, no Material UI chrome.',
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.sun, size: 16),
                  const SizedBox(width: 6),
                  ShadSwitch(
                    value: isDark,
                    onChanged: (value) {
                      onThemeModeChanged(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  const Icon(LucideIcons.moon, size: 16),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                isDark ? 'Dark mode' : 'Light mode',
                style: theme.textTheme.small.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
            ],
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              ShadBadge(child: Text('Shadcn UI')),
              ShadBadge.secondary(child: Text('Mobile')),
              ShadBadge.outline(child: Text('5 Tabs')),
              ShadBadge.destructive(child: Text('Demo')),
            ],
          ),
        ),
        SectionCard(
          title: 'Theme controls',
          subtitle: 'Switch base color and style presets.',
          children: [
            ShadSelect<BaseColor>(
              minWidth: 260,
              initialValue: baseColor,
              placeholder: const Text('Base color'),
              options: BaseColor.values
                  .map(
                    (value) => ShadOption(
                      value: value,
                      child: Text(value.label),
                    ),
                  )
                  .toList(),
              selectedOptionBuilder: (context, value) => Text(value.label),
              onChanged: (value) {
                if (value != null) {
                  onBaseColorChanged(value);
                }
              },
            ),
            ShadSelect<AccentColor>(
              minWidth: 260,
              initialValue: accentColor,
              placeholder: const Text('Key color'),
              options: AccentColor.values
                  .map(
                    (value) => ShadOption(
                      value: value,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _accentSwatchColor(
                                value,
                                baseColor,
                                theme.brightness,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(value.label),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              selectedOptionBuilder: (context, value) => Text(value.label),
              onChanged: (value) {
                if (value != null) {
                  onAccentColorChanged(value);
                }
              },
            ),
            ShadSelect<UiStyle>(
              minWidth: 260,
              initialValue: style,
              placeholder: const Text('UI style'),
              options: UiStyle.values
                  .map(
                    (value) => ShadOption(
                      value: value,
                      child: Text(value.label),
                    ),
                  )
                  .toList(),
              selectedOptionBuilder: (context, value) => Text(value.label),
              onChanged: (value) {
                if (value != null) {
                  onStyleChanged(value);
                }
              },
            ),
          ],
        ),
        SectionCard(
          title: 'Buttons & badges',
          subtitle: 'Primary actions, subtle actions, and status chips.',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ShadButton(
                  leading: const Icon(LucideIcons.play),
                  child: const Text('Primary'),
                  onPressed: () {},
                ),
                ShadButton.secondary(
                  child: const Text('Secondary'),
                  onPressed: () {},
                ),
                ShadButton.outline(
                  child: const Text('Outline'),
                  onPressed: () {},
                ),
                ShadButton.ghost(
                  child: const Text('Ghost'),
                  onPressed: () {},
                ),
                ShadButton.destructive(
                  leading: const Icon(LucideIcons.trash),
                  child: const Text('Delete'),
                  onPressed: () {},
                ),
                ShadButton.link(
                  child: const Text('Link'),
                  onPressed: () {},
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                ShadBadge(child: Text('Live')),
                ShadBadge.secondary(child: Text('Draft')),
                ShadBadge.outline(child: Text('Outline')),
                ShadBadge.destructive(child: Text('Blocked')),
              ],
            ),
          ],
        ),
        SectionCard(
          title: 'Identity & icons',
          subtitle: 'Avatars and icon buttons for compact actions.',
          children: [
            Wrap(
              spacing: 12,
              children: [
                ShadAvatar(
                  null,
                  placeholder: const Text('AI'),
                ),
                ShadAvatar(
                  null,
                  placeholder: const Text('UX'),
                  size: const Size.square(36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                ShadAvatar(
                  null,
                  placeholder: const Text('MB'),
                  size: const Size.square(52),
                  shape: const CircleBorder(),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ShadIconButton(
                  icon: const Icon(LucideIcons.star),
                  onPressed: () {},
                ),
                ShadIconButton.secondary(
                  icon: const Icon(LucideIcons.bookmark),
                  onPressed: () {},
                ),
                ShadIconButton.outline(
                  icon: const Icon(LucideIcons.heart),
                  onPressed: () {},
                ),
                ShadIconButton.ghost(
                  icon: const Icon(LucideIcons.share2),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        SectionCard(
          title: 'Alerts',
          subtitle: 'Inline feedback cards with icon support.',
          children: const [
            ShadAlert(
              icon: Icon(LucideIcons.info),
              title: Text('Heads up'),
              description: Text(
                'Shadcn UI styling stays consistent across the app.',
              ),
            ),
            ShadAlert.destructive(
              icon: Icon(LucideIcons.triangleAlert),
              title: Text('Network error'),
              description: Text(
                'Reconnect to sync your changes.',
              ),
            ),
          ],
        ),
        SectionCard(
          title: 'Breadcrumbs & separators',
          subtitle: 'Compact navigation and structure hints.',
          children: [
            ShadBreadcrumb(
              children: [
                ShadBreadcrumbLink(
                  onPressed: () {},
                  child: const Text('Home'),
                ),
                const Text('Library'),
                const Text('Mobile'),
              ],
            ),
            const ShadSeparator.horizontal(),
            ShadBreadcrumb(
              separator: const Icon(LucideIcons.slash),
              children: [
                ShadBreadcrumbLink(
                  onPressed: () {},
                  child: const Text('Workspace'),
                ),
                const Text('Details'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class FormsTab extends StatefulWidget {
  const FormsTab({super.key});

  @override
  State<FormsTab> createState() => _FormsTabState();
}

class _FormsTabState extends State<FormsTab> {
  bool marketingOptIn = true;
  bool pushEnabled = false;
  NotifyOption notifyOption = NotifyOption.mentions;
  String? favoriteFramework;
  String searchValue = '';
  String? formStatus;
  final formKey = GlobalKey<ShadFormState>();

  Map<String, String> get filteredFrameworks => {
    for (final entry in frameworks.entries)
      if (entry.value.toLowerCase().contains(searchValue.toLowerCase()))
        entry.key: entry.value,
  };

  @override
  Widget build(BuildContext context) {
    return TabScaffold(
      children: [
        SectionCard(
          title: 'Text inputs',
          subtitle: 'Inputs, textarea, and OTP slots.',
          children: [
            const ShadInput(
              placeholder: Text('Search projects'),
              leading: Icon(LucideIcons.search),
            ),
            const ShadInput(
              placeholder: Text('you@example.com'),
              leading: Icon(LucideIcons.mail),
            ),
            const ShadTextarea(
              placeholder: Text('Write a short update...'),
              minHeight: 90,
              maxHeight: 160,
            ),
            ShadInputOTP(
              maxLength: 6,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {},
              children: const [
                ShadInputOTPGroup(
                  children: [
                    ShadInputOTPSlot(),
                    ShadInputOTPSlot(),
                    ShadInputOTPSlot(),
                  ],
                ),
                Icon(LucideIcons.dot),
                ShadInputOTPGroup(
                  children: [
                    ShadInputOTPSlot(),
                    ShadInputOTPSlot(),
                    ShadInputOTPSlot(),
                  ],
                ),
              ],
            ),
          ],
        ),
        SectionCard(
          title: 'Selection & toggles',
          subtitle: 'Checkbox, switch, radio group, and combobox.',
          children: [
            ShadCheckbox(
              value: marketingOptIn,
              onChanged: (value) => setState(() => marketingOptIn = value),
              label: const Text('Receive product updates'),
            ),
            ShadSwitch(
              value: pushEnabled,
              onChanged: (value) => setState(() => pushEnabled = value),
              label: const Text('Enable push notifications'),
            ),
            ShadRadioGroup<NotifyOption>(
              initialValue: notifyOption,
              onChanged: (value) {
                if (value == null) return;
                setState(() => notifyOption = value);
              },
              items: NotifyOption.values
                  .map(
                    (option) => ShadRadio(
                      value: option,
                      label: Text(option.label),
                    ),
                  )
                  .toList(),
            ),
            ShadSelect<String>.withSearch(
              placeholder: const Text('Pick your framework'),
              searchPlaceholder: const Text('Type to filter'),
              onSearchChanged: (value) => setState(() => searchValue = value),
              onChanged: (value) => setState(() => favoriteFramework = value),
              options: [
                if (filteredFrameworks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('No matches'),
                  ),
                ...filteredFrameworks.entries.map(
                  (entry) => ShadOption(
                    value: entry.key,
                    child: Text(entry.value),
                  ),
                ),
              ],
              selectedOptionBuilder: (context, value) {
                return Text(frameworks[value] ?? 'Select one');
              },
            ),
          ],
        ),
        SectionCard(
          title: 'Form',
          subtitle: 'A validated form using ShadForm fields.',
          children: [
            ShadForm(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _withVerticalGap(
                  [
                    ShadInputFormField(
                      id: 'name',
                      label: const Text('Name'),
                      placeholder: const Text('Jane Doe'),
                      validator: (value) => _requiredText(value),
                    ),
                    ShadTextareaFormField(
                      id: 'bio',
                      label: const Text('Bio'),
                      minHeight: 80,
                      maxHeight: 140,
                      placeholder: const Text('Tell us about your work...'),
                      validator: (value) =>
                          _requiredText(value, minLength: 10),
                    ),
                    ShadCheckboxFormField(
                      id: 'terms',
                      initialValue: false,
                      inputLabel: const Text(
                        'I accept the mobile UI guidelines',
                      ),
                      validator: (value) {
                        if (!value) {
                          return 'Accept the guidelines to continue';
                        }
                        return null;
                      },
                    ),
                    ShadButton(
                      child: const Text('Submit form'),
                      onPressed: () {
                        if (formKey.currentState?.saveAndValidate() ?? false) {
                          setState(() => formStatus = 'Submitted successfully');
                          ShadToaster.of(context).show(
                            const ShadToast(
                              title: Text('Form submitted'),
                              description: Text('Your demo data is saved.'),
                            ),
                          );
                        } else {
                          setState(() => formStatus = 'Fix validation errors');
                          ShadToaster.of(context).show(
                            const ShadToast.destructive(
                              title: Text('Validation failed'),
                            ),
                          );
                        }
                      },
                    ),
                    if (formStatus != null)
                      Text(
                        formStatus!,
                        textAlign: TextAlign.center,
                      ),
                  ],
                  12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PickersTab extends StatefulWidget {
  const PickersTab({super.key});

  @override
  State<PickersTab> createState() => _PickersTabState();
}

class _PickersTabState extends State<PickersTab> {
  DateTime? calendarSelected = DateTime.now();
  DateTime? pickedDate;
  ShadTimeOfDay? pickedTime;
  double progress = 0.45;
  late final ShadSliderController volume =
      ShadSliderController(initialValue: 40);

  @override
  void dispose() {
    volume.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return TabScaffold(
      children: [
        SectionCard(
          title: 'Calendar',
          subtitle: 'Single month calendar selection.',
          children: [
            ShadCalendar(
              selected: calendarSelected,
              onChanged: (value) => setState(() => calendarSelected = value),
              captionLayout: ShadCalendarCaptionLayout.label,
              hideNavigation: false,
            ),
          ],
        ),
        SectionCard(
          title: 'Date picker',
          subtitle: 'Popover calendar with a button trigger.',
          children: [
            ShadDatePicker(
              selected: pickedDate,
              placeholder: const Text('Choose a date'),
              onChanged: (value) => setState(() => pickedDate = value),
            ),
            if (pickedDate != null)
              Text(
                'Selected: ${pickedDate!.toLocal().toString().split(' ').first}',
                style: theme.textTheme.small,
              ),
          ],
        ),
        SectionCard(
          title: 'Time picker',
          subtitle: 'Inline time input for mobile.',
          children: [
            ShadTimePicker.period(
              onChanged: (value) => setState(() => pickedTime = value),
            ),
            if (pickedTime != null)
              Text(
                'Time: ${pickedTime!.hour.toString().padLeft(2, '0')}:${pickedTime!.minute.toString().padLeft(2, '0')}',
                style: theme.textTheme.small,
              ),
          ],
        ),
        SectionCard(
          title: 'Slider & progress',
          subtitle: 'Interactive sliders and loading states.',
          children: [
            ValueListenableBuilder<double>(
              valueListenable: volume,
              builder: (context, value, _) {
                return Text('Volume ${value.round()}%');
              },
            ),
            ShadSlider(
              controller: volume,
              max: 100,
              onChanged: (_) {},
            ),
            ShadProgress(value: progress),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShadIconButton.ghost(
                  icon: const Icon(LucideIcons.minus),
                  enabled: progress > 0.1,
                  onPressed: () {
                    setState(() => progress = (progress - 0.1).clamp(0, 1));
                  },
                ),
                ShadIconButton.ghost(
                  icon: const Icon(LucideIcons.plus),
                  enabled: progress < 1,
                  onPressed: () {
                    setState(() => progress = (progress + 0.1).clamp(0, 1));
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class OverlaysTab extends StatefulWidget {
  const OverlaysTab({super.key});

  @override
  State<OverlaysTab> createState() => _OverlaysTabState();
}

class _OverlaysTabState extends State<OverlaysTab> {
  final ShadPopoverController popoverController = ShadPopoverController();
  final FocusNode tooltipFocusNode = FocusNode();

  @override
  void dispose() {
    popoverController.dispose();
    tooltipFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return TabScaffold(
      children: [
        SectionCard(
          title: 'Dialogs & sheets',
          subtitle: 'Modal dialog and bottom sheet.',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ShadButton.outline(
                  child: const Text('Open dialog'),
                  onPressed: () {
                    showShadDialog(
                      context: context,
                      builder: (context) => ShadDialog(
                        title: const Text('Edit profile'),
                        description: const Text(
                          'Keep the interface compact on mobile.',
                        ),
                        actions: [
                          ShadButton.outline(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          ShadButton(
                            child: const Text('Save'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                        child: const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: ShadInput(
                            placeholder: Text('Display name'),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ShadButton(
                  child: const Text('Open sheet'),
                  onPressed: () {
                    showShadSheet(
                      context: context,
                      side: ShadSheetSide.bottom,
                      builder: (context) => ShadSheet(
                        title: const Text('New message'),
                        description: const Text(
                          'Compose directly from the sheet.',
                        ),
                        actions: const [
                          ShadButton(child: Text('Send')),
                        ],
                        child: const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: ShadTextarea(
                            placeholder: Text('Write a quick note...'),
                            minHeight: 120,
                            maxHeight: 160,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        SectionCard(
          title: 'Popover & tooltip',
          subtitle: 'Tap-triggered overlays.',
          children: [
            ShadPopover(
              controller: popoverController,
              popover: (context) => SizedBox(
                width: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _withVerticalGap(
                    [
                      Text('Quick settings', style: theme.textTheme.h4),
                      const ShadInput(
                        placeholder: Text('Quick filter'),
                        leading: Icon(LucideIcons.search),
                      ),
                      ShadSwitch(
                        value: true,
                        onChanged: (_) {},
                        label: const Text('Auto sync'),
                      ),
                    ],
                    8,
                  ),
                ),
              ),
              child: ShadButton.outline(
                onPressed: popoverController.toggle,
                child: const Text('Open popover'),
              ),
            ),
            ShadTooltip(
              focusNode: tooltipFocusNode,
              builder: (context) => const Text('Add to library'),
              child: ShadButton.ghost(
                focusNode: tooltipFocusNode,
                child: const Text('Tooltip target'),
              ),
            ),
          ],
        ),
        SectionCard(
          title: 'Context menu',
          subtitle: 'Long-press to open a context menu.',
          children: [
            ShadContextMenuRegion(
              constraints: const BoxConstraints(minWidth: 240),
              items: const [
                ShadContextMenuItem(child: Text('Pin to top')),
                ShadContextMenuItem(child: Text('Mute thread')),
                ShadContextMenuItem(child: Text('Mark unread')),
                ShadContextMenuItem.inset(
                  enabled: false,
                  child: Text('Archive'),
                ),
              ],
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.border),
                ),
                child: const Text('Long-press here'),
              ),
            ),
          ],
        ),
        SectionCard(
          title: 'Toast & sonner',
          subtitle: 'Inline toasts and stacked notifications.',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ShadButton.outline(
                  child: const Text('Show toast'),
                  onPressed: () {
                    ShadToaster.of(context).show(
                      const ShadToast(
                        title: Text('Saved'),
                        description: Text('Draft stored locally.'),
                      ),
                    );
                  },
                ),
                ShadButton(
                  child: const Text('Show sonner'),
                  onPressed: () {
                    final sonner = ShadSonner.of(context);
                    final id = DateTime.now().microsecondsSinceEpoch;
                    sonner.show(
                      ShadToast(
                        id: id,
                        title: const Text('Event created'),
                        description: const Text('See you on Friday.'),
                        action: ShadButton.outline(
                          child: const Text('Undo'),
                          onPressed: () => sonner.hide(id),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class LayoutsTab extends StatefulWidget {
  const LayoutsTab({super.key});

  @override
  State<LayoutsTab> createState() => _LayoutsTabState();
}

class _LayoutsTabState extends State<LayoutsTab> {
  String nestedTab = 'notes';

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return TabScaffold(
      children: [
        SectionCard(
          title: 'Accordion',
          subtitle: 'Expandable mobile-friendly sections.',
          children: [
            ShadAccordion<({String body, String title})>(
              children: quickNotes.map(
                (note) => ShadAccordionItem(
                  value: note,
                  title: Text(note.title),
                  child: Text(note.body),
                ),
              ),
            ),
          ],
        ),
        SectionCard(
          title: 'Tabs',
          subtitle: 'Nested tabs inside a section.',
          children: [
            ShadTabs<String>(
              value: nestedTab,
              onChanged: (value) => setState(() => nestedTab = value),
              scrollable: true,
              tabs: [
                ShadTab(
                  value: 'notes',
                  child: const Text('Notes'),
                  content: Text(
                    'Use tabs for switching between compact panels.',
                    style: theme.textTheme.p,
                  ),
                ),
                ShadTab(
                  value: 'reviews',
                  child: const Text('Reviews'),
                  content: Text(
                    'Pair tabs with cards for structured content.',
                    style: theme.textTheme.p,
                  ),
                ),
                ShadTab(
                  value: 'usage',
                  child: const Text('Usage'),
                  content: Text(
                    'The main navigation tabs also use ShadTabs.',
                    style: theme.textTheme.p,
                  ),
                ),
              ],
            ),
          ],
        ),
        SectionCard(
          title: 'Table',
          subtitle: 'Compact table layout for mobile data.',
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: SizedBox(
                height: 240,
                child: ShadTable.list(
                  header: const [
                    ShadTableCell.header(child: Text('Invoice')),
                    ShadTableCell.header(child: Text('Status')),
                    ShadTableCell.header(
                      alignment: Alignment.centerRight,
                      child: Text('Amount'),
                    ),
                  ],
                  children: invoices.map(
                    (invoice) => [
                      ShadTableCell(child: Text(invoice.id)),
                      ShadTableCell(child: Text(invoice.status)),
                      ShadTableCell(
                        alignment: Alignment.centerRight,
                        child: Text(invoice.amount),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TabScaffold extends StatelessWidget {
  const TabScaffold({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _withVerticalGap(children, 16),
          ),
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.footer,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      title: Text(title),
      description: subtitle == null ? null : Text(subtitle!),
      footer: footer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _withVerticalGap(children, 12),
      ),
    );
  }
}

List<Widget> _withVerticalGap(List<Widget> children, double gap) {
  final spaced = <Widget>[];
  for (var i = 0; i < children.length; i += 1) {
    if (i > 0) {
      spaced.add(SizedBox(height: gap));
    }
    spaced.add(children[i]);
  }
  return spaced;
}

String? _requiredText(String value, {int minLength = 1}) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return 'Required';
  }
  if (trimmed.length < minLength) {
    return 'Min $minLength characters';
  }
  return null;
}

class _StylePreset {
  const _StylePreset({
    required this.radius,
    required this.disableSecondaryBorder,
  });

  final BorderRadius radius;
  final bool disableSecondaryBorder;
}

_StylePreset _stylePreset(UiStyle style) {
  return switch (style) {
    UiStyle.vega => _StylePreset(
      radius: BorderRadius.circular(10),
      disableSecondaryBorder: false,
    ),
    UiStyle.nova => _StylePreset(
      radius: BorderRadius.circular(14),
      disableSecondaryBorder: true,
    ),
    UiStyle.maia => _StylePreset(
      radius: BorderRadius.circular(28),
      disableSecondaryBorder: true,
    ),
    UiStyle.lyra => _StylePreset(
      radius: BorderRadius.circular(12),
      disableSecondaryBorder: false,
    ),
    UiStyle.mira => _StylePreset(
      radius: BorderRadius.circular(8),
      disableSecondaryBorder: false,
    ),
  };
}

ShadColorScheme _schemeFor(BaseColor baseColor, Brightness brightness) {
  final light = brightness == Brightness.light;
  return switch (baseColor) {
    BaseColor.slate =>
      light ? const ShadSlateColorScheme.light() : const ShadSlateColorScheme.dark(),
    BaseColor.gray =>
      light ? const ShadGrayColorScheme.light() : const ShadGrayColorScheme.dark(),
    BaseColor.zinc =>
      light ? const ShadZincColorScheme.light() : const ShadZincColorScheme.dark(),
    BaseColor.neutral =>
      light ? const ShadNeutralColorScheme.light() : const ShadNeutralColorScheme.dark(),
    BaseColor.stone =>
      light ? const ShadStoneColorScheme.light() : const ShadStoneColorScheme.dark(),
  };
}

ShadColorScheme? _accentScheme(
  AccentColor accentColor,
  Brightness brightness,
) {
  return switch (accentColor) {
    AccentColor.base => null,
    AccentColor.blue => ShadColorScheme.fromName(
        'blue',
        brightness: brightness,
      ),
    AccentColor.green => ShadColorScheme.fromName(
        'green',
        brightness: brightness,
      ),
    AccentColor.orange => ShadColorScheme.fromName(
        'orange',
        brightness: brightness,
      ),
    AccentColor.red => ShadColorScheme.fromName(
        'red',
        brightness: brightness,
      ),
    AccentColor.rose => ShadColorScheme.fromName(
        'rose',
        brightness: brightness,
      ),
    AccentColor.violet => ShadColorScheme.fromName(
        'violet',
        brightness: brightness,
      ),
    AccentColor.yellow => ShadColorScheme.fromName(
        'yellow',
        brightness: brightness,
      ),
  };
}

Color _accentSwatchColor(
  AccentColor accentColor,
  BaseColor baseColor,
  Brightness brightness,
) {
  final baseScheme = _schemeFor(baseColor, brightness);
  final accentScheme = _accentScheme(accentColor, brightness);
  return (accentScheme ?? baseScheme).primary;
}

ShadTabsTheme _tabsThemeFor(
  ShadColorScheme scheme,
  _StylePreset preset,
) {
  final borderRadius = preset.radius;
  final decoration = ShadDecoration(
    border: ShadBorder.all(radius: borderRadius, width: 0),
    secondaryBorder: preset.disableSecondaryBorder
        ? null
        : ShadBorder.all(
            radius: borderRadius,
            width: 0,
            padding: const EdgeInsets.all(2),
          ),
    secondaryFocusedBorder: preset.disableSecondaryBorder
        ? null
        : ShadBorder.all(
            radius: borderRadius,
            width: 2,
            padding: const EdgeInsets.all(0),
            color: scheme.ring,
          ),
    disableSecondaryBorder: preset.disableSecondaryBorder,
  );
  return ShadTabsTheme(
    tabDecoration: decoration,
    tabSelectedDecoration: decoration,
  );
}

ShadInputTheme _inputThemeFor(
  ShadColorScheme scheme,
  _StylePreset preset,
) {
  final radius = preset.radius;
  return ShadInputTheme(
    decoration: ShadDecoration(
      border: ShadBorder.all(
        radius: radius,
        width: 1,
        color: scheme.border,
      ),
      focusedBorder: ShadBorder.all(
        radius: radius,
        width: 2,
        color: scheme.ring,
      ),
      secondaryBorder: preset.disableSecondaryBorder
          ? null
          : ShadBorder.all(
              radius: radius,
              width: 0,
              padding: const EdgeInsets.all(2),
            ),
      secondaryFocusedBorder: preset.disableSecondaryBorder
          ? null
          : ShadBorder.all(
              radius: radius,
              width: 2,
              padding: const EdgeInsets.all(0),
              color: scheme.ring,
            ),
      disableSecondaryBorder: preset.disableSecondaryBorder,
    ),
  );
}

ShadThemeData _themeFor(
  Brightness brightness,
  BaseColor baseColor,
  AccentColor accentColor,
  UiStyle style,
) {
  final preset = _stylePreset(style);
  final baseScheme = _schemeFor(baseColor, brightness);
  final accentScheme = _accentScheme(accentColor, brightness);
  final scheme = accentScheme == null
      ? baseScheme
      : baseScheme.copyWith(
          primary: accentScheme.primary,
          primaryForeground: accentScheme.primaryForeground,
          ring: accentScheme.ring,
          accent: accentScheme.accent,
          accentForeground: accentScheme.accentForeground,
          selection: accentScheme.selection,
        );
  return ShadThemeData(
    brightness: brightness,
    colorScheme: scheme,
    radius: preset.radius,
    disableSecondaryBorder: preset.disableSecondaryBorder,
    tabsTheme: _tabsThemeFor(scheme, preset),
    inputTheme: _inputThemeFor(scheme, preset),
    primaryDialogTheme: ShadDialogTheme(radius: preset.radius),
    alertDialogTheme: ShadDialogTheme(radius: preset.radius),
  );
}

class _NoScrollbarScrollBehavior extends ShadScrollBehavior {
  const _NoScrollbarScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
