// الموقع: app/(tabs)/add-medicine/components/DurationSection.tsx

import { useTranslation } from '@/context/TranslationContext';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { Platform, StyleSheet, TouchableOpacity, View } from 'react-native';
import { MD3Theme, Surface, Text, useTheme } from 'react-native-paper';

interface Props {
  startDate: Date;
  endDate?: Date;
  onShowPicker: (mode: 'date', target: 'start' | 'end') => void;
}

// --- ✅ 1. الأنماط الآن أبسط وتعتمد بالكامل على الخصائص التلقائية ---
const createStyles = (theme: MD3Theme) => StyleSheet.create({
  sectionContainer: {
    padding: 18,
    borderRadius: 18,
    marginBottom: 24,
    backgroundColor: theme.colors.elevation.level2,
    elevation: 4,
    ...Platform.select({
      ios: { shadowOpacity: 0.1, shadowRadius: 8, shadowOffset: { width: 0, height: 4 }, shadowColor: theme.colors.shadow },
    }),
  },
  header: {
    flexDirection: 'row-reverse', // ✅ صحيح: اتجاه من اليمين لليسار
    alignItems: 'center',
    gap: 12,
    marginBottom: 18,
  },
  iconCircle: {
    backgroundColor: theme.colors.primary,
    borderRadius: 24,
    width: 44,
    height: 44,
    alignItems: 'center',
    justifyContent: 'center',
  },
  subheading: {
    flex: 1,
    color: theme.colors.primary,
    fontSize: 22,
    fontFamily: 'Cairo-Bold',
    textAlign: 'auto', // ✅ صحيح: محاذاة تلقائية
  },
  row: {
    flexDirection: 'row-reverse', // ✅ صحيح: اتجاه من اليمين لليسار
    gap: 14,
  },
  dateInput: {
    flex: 1,
    backgroundColor: theme.colors.surface,
    borderRadius: 12,
    paddingVertical: 12,
    paddingHorizontal: 8,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: theme.colors.outline,
  },
  dateLabel: {
    color: theme.colors.onSurfaceVariant,
    fontSize: 14,
    marginBottom: 4,
    textAlign: 'auto',
    fontFamily: 'Cairo-Regular',
  },
  dateValue: {
    color: theme.colors.onSurface,
    fontSize: 16,
    textAlign: 'auto',
    fontFamily: 'Cairo-Bold',
  },
});


export default function DurationSection({ startDate, endDate, onShowPicker }: Props) {
  const theme = useTheme();
  const { t, language } = useTranslation();
  const styles = createStyles(theme);

  // هذا الجزء صحيح ومنطقي، لأن تنسيق التاريخ يعتمد بالفعل على اللغة
  const locale = language === 'ar' ? 'ar-EG' : 'en-GB';
  const dateFormatOptions: Intl.DateTimeFormatOptions = { day: '2-digit', month: 'short', year: 'numeric' };
  const formattedStartDate = startDate.toLocaleDateString(locale, dateFormatOptions);
  const formattedEndDate = endDate ? endDate.toLocaleDateString(locale, dateFormatOptions) : t('common.notSet');

  return (
    <Surface style={styles.sectionContainer}>
      <View style={styles.header}>
        <View style={styles.iconCircle}>
          {/* --- ✅ 2. استخدام لون الثيم الصحيح للأيقونة --- */}
          <MaterialCommunityIcons name="calendar-month-outline" size={28} color={theme.colors.onPrimary} />
        </View>
        <Text variant="titleLarge" style={styles.subheading}>
          {t('addMedicine.durationHeader')}
        </Text>
      </View>

      <View style={styles.row}>
        {/* --- ✅ 3. تبسيط الكود بإزالة المكون الداخلي --- */}
        <TouchableOpacity style={styles.dateInput} onPress={() => onShowPicker('date', 'start')}>
          <Text style={styles.dateLabel}>{t('addMedicine.startDate')}</Text>
          <Text style={styles.dateValue}>{formattedStartDate}</Text>
        </TouchableOpacity>
        
        <TouchableOpacity style={styles.dateInput} onPress={() => onShowPicker('date', 'end')}>
          <Text style={styles.dateLabel}>{t('addMedicine.endDateOptional')}</Text>
          <Text style={styles.dateValue}>{formattedEndDate}</Text>
        </TouchableOpacity>
      </View>
    </Surface>
  );
}
