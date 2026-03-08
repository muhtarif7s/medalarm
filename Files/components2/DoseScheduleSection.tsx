// الموقع: app/(tabs)/add-medicine/components/DoseScheduleSection.tsx

import { useTranslation } from '@/context/TranslationContext';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { Platform, StyleSheet, View } from 'react-native';
import { Button, Chip, Surface, Text, useTheme, type MD3Theme } from 'react-native-paper';

interface Props {
  doseTimes: string[];
  onAddTime: () => void;
  onRemoveTime: (time: string) => void;
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
  chipContainer: {
    flexDirection: 'row-reverse', // ✅ صحيح: اتجاه من اليمين لليسار
    flexWrap: 'wrap',
    gap: 10,
    marginBottom: 20,
    minHeight: 40,
    alignItems: 'center',
  },
  placeholderText: {
    textAlign: 'auto', // ✅ الأهم: محاذاة النص داخل الحقل تلقائية
    width: '100%',
    color: theme.colors.onSurfaceVariant,
    fontFamily: 'Cairo-Regular',
  },
  chip: {
    height: 40,
    backgroundColor: theme.colors.primaryContainer,
  },
  chipText: {
    fontSize: 14,
    color: theme.colors.onPrimaryContainer,
    fontFamily: 'Cairo-SemiBold',
    textAlign: 'auto', // ✅ يدعم RTL/LTR تلقائيًا
  },
  button: {
    borderRadius: 12,
    paddingVertical: 4,
  },
  buttonLabel: {
    fontSize: 16,
    fontFamily: 'Cairo-Bold',
  },
});


export default function DoseScheduleSection({ doseTimes, onAddTime, onRemoveTime }: Props) {
  const theme = useTheme();
  const { t } = useTranslation();
  const styles = createStyles(theme);

  return (
    <Surface style={styles.sectionContainer}>
      <View style={styles.header}>
        <View style={styles.iconCircle}>
          {/* --- ✅ 2. استخدام لون الثيم الصحيح للأيقونة --- */}
          <MaterialCommunityIcons name="clock-time-eight-outline" size={28} color={theme.colors.onPrimary} />
        </View>
        <Text variant="titleLarge" style={styles.subheading}>
          {t('addMedicine.doseTimesHeader')}
        </Text>
      </View>

      <View style={styles.chipContainer}>
        {doseTimes.length === 0 ? (
          <Text style={styles.placeholderText}>
            {t('addMedicine.noDoseTimesPlaceholder')}
          </Text>
        ) : (
          doseTimes.map((time, index) => (
            <Chip
              key={index}
              onClose={() => onRemoveTime(time)}
              style={styles.chip}
              textStyle={styles.chipText}
              closeIcon="close-circle"
            >
              {time}
            </Chip>
          ))
        )}
      </View>

      <Button
        icon="clock-plus-outline"
        mode="contained"
        onPress={onAddTime}
        style={styles.button}
        labelStyle={styles.buttonLabel}
      >
        {t('addMedicine.addTimeButton')}
      </Button>
    </Surface>
  );
}
