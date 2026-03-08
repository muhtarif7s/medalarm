// الموقع: app/(tabs)/settings/components/LanguageSelector.tsx (النسخة المُبسَّطة)

import { useTranslation } from '@/context/TranslationContext';
import React from 'react';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useTheme } from 'react-native-paper';

export default function LanguageSelector() {
  const { colors } = useTheme();
  const { t, language, setLanguage } = useTranslation();

  // دالة ذكية لتحديد الخط واللون بناءً على اللغة المختارة
  const getTextStyle = (lang: 'ar' | 'en') => ({
    fontFamily: lang === 'ar' ? 'Cairo-Bold' : 'System', // خط النظام للغة الإنجليزية
    fontSize: 16,
    color: language === lang ? 'white' : colors.onSurface,
  });

  return (
    // لم نعد بحاجة للـ Header هنا، فقط حاوية الأزرار
    <View style={styles.langContainer}>
      <TouchableOpacity
        style={[styles.langButton, { borderColor: colors.outline }, language === 'ar' && { backgroundColor: colors.primary, borderColor: colors.primary }]}
        onPress={() => setLanguage('ar')}
      >
        <Text style={getTextStyle('ar')}>{t('settings.arabic')}</Text>
      </TouchableOpacity>
      <TouchableOpacity
        style={[styles.langButton, { borderColor: colors.outline }, language === 'en' && { backgroundColor: colors.primary, borderColor: colors.primary }]}
        onPress={() => setLanguage('en')}
      >
        <Text style={getTextStyle('en')}>{t('settings.english')}</Text>
      </TouchableOpacity>
    </View>
  );
}

// الأنماط أصبحت أبسط
const styles = StyleSheet.create({
  langContainer: {
    flexDirection: 'row',
    marginHorizontal: 16,
    marginBottom: 24, // مسافة بعد القسم
    gap: 16,
  },
  langButton: {
    flex: 1,
    paddingVertical: 12,
    borderRadius: 12,
    alignItems: 'center',
    borderWidth: 1.5,
  },
});
