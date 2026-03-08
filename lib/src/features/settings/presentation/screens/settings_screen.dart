import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:myapp/src/features/settings/presentation/providers/settings_provider.dart';
import 'package:myapp/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static final Uri _privacyUri =
      Uri.parse('https://docs.google.com/document/d/1YeL3311p-jUV2j_2m_4J_v3i__B1J_Fj/');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();

    // Set text direction based on language
    final isRtl = (localeProvider.locale ?? AppLocalizations.supportedLocales.first).languageCode == 'ar';

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.settings),
        ),
        body: ListView(
          children: [
            _section(context, l10n.language),
            const _LanguageSetting(),
            const Divider(),
            _section(context, l10n.appearance),
            const _ThemeSetting(),
            const Divider(),
            _section(context, l10n.about),
            _AboutSection(uri: _privacyUri),
          ],
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _LanguageSetting extends StatelessWidget {
  const _LanguageSetting();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.language),
      trailing: DropdownButton<Locale>(
        value: localeProvider.locale ?? AppLocalizations.supportedLocales.first,
        underline: const SizedBox(),
        onChanged: (locale) {
          if (locale != null) {
            localeProvider.setLocale(locale);
          }
        },
        items: AppLocalizations.supportedLocales.map((locale) {
          return DropdownMenuItem(
            value: locale,
            child: Text(localeProvider.getLangName(locale.languageCode)),
          );
        }).toList(),
      ),
    );
  }
}

class _ThemeSetting extends StatelessWidget {
  const _ThemeSetting();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<SettingsProvider>();

    return ListTile(
      leading: const Icon(Icons.color_lens),
      title: Text(l10n.themeMode),
      trailing: DropdownButton<ThemeMode>(
        value: provider.themeMode,
        underline: const SizedBox(),
        onChanged: (mode) {
          if (mode != null) {
            context.read<SettingsProvider>().setThemeMode(mode);
          }
        },
        items: [
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text(l10n.light),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text(l10n.dark),
          ),
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text(l10n.system),
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  final Uri uri;

  const _AboutSection({required this.uri});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.info),
          title: Text(l10n.appVersion),
          subtitle: FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text(l10n.loading);
              }
              return Text(snapshot.data!.version);
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: Text(l10n.privacyPolicy),
          onTap: () => _open(context, uri),
        ),
      ],
    );
  }

  Future<void> _open(BuildContext context, Uri uri) async {
    final l10n = AppLocalizations.of(context)!;

    if (!await launchUrl(uri)) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.couldNotLaunchUrl)),
      );
    }
  }
}
