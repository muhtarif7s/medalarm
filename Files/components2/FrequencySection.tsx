// الموقع: app/(tabs)/add-medicine/components2/FrequencySection.tsx

import { useTranslation } from '@/context/TranslationContext';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { addDays, format, startOfWeek } from 'date-fns';
import React from 'react';
import { Platform, StyleSheet, TouchableOpacity, View } from 'react-native';
import { SegmentedButtons, Surface, Text, TextInput, useTheme, type MD3Theme } from 'react-native-paper';

// --- ✅ 1. الأنماط الآن أبسط وتدعم كل الحالات (العادية والمختارة) ---
const createStyles = (theme: MD3Theme) => StyleSheet.create({
  sectionContainer: { padding: 18, borderRadius: 18, marginBottom: 24, backgroundColor: theme.colors.elevation.level2, elevation: 4, ...Platform.select({ ios: { shadowOpacity: 0.1, shadowRadius: 8, shadowOffset: { width: 0, height: 4 }, shadowColor: theme.colors.shadow } }) },
  header: { flexDirection: 'row-reverse', alignItems: 'center', gap: 12, marginBottom: 18 },
  iconCircle: { backgroundColor: theme.colors.primary, borderRadius: 24, width: 44, height: 44, alignItems: 'center', justifyContent: 'center' },
  subheading: {
    flex: 1,
    color: theme.colors.primary,
    fontSize: 22,
    fontFamily: 'Cairo-Bold',
    textAlign: 'auto', // ✅ صحيح: محاذاة تلقائية
  }, optionsContainer: { marginTop: 20 },
  optionsLabel: { fontSize: 16, textAlign: 'auto', marginBottom: 12, color: theme.colors.onSurface, fontFamily: 'Cairo-Bold' },
  daySelector: { flexDirection: 'row-reverse', justifyContent: 'space-between', alignItems: 'center' },
  dayCircle: { width: 40, height: 40, borderRadius: 20, justifyContent: 'center', alignItems: 'center', borderWidth: 1.5, backgroundColor: 'transparent', borderColor: theme.colors.outline },
  dayCircleSelected: { backgroundColor: theme.colors.primary, borderColor: theme.colors.primary },
  dayLabel: { fontSize: 14, color: theme.colors.onSurface, fontFamily: 'Cairo-SemiBold' },
  intervalInputContainer: { flexDirection: 'row-reverse', alignItems: 'center', gap: 10 },
  intervalInput: { flex: 1, textAlign: 'auto' },
  intervalText: { fontSize: 16, color: theme.colors.onSurface, fontFamily: 'Cairo-Regular' },
});

// --- ✅ 2. المكون الداخلي أصبح أبسط بكثير ---
const DayButton = ({ label, selected, onPress, styles }: any) => (
  <TouchableOpacity onPress={onPress} activeOpacity={0.7}>
    <View style={[styles.dayCircle, selected && styles.dayCircleSelected]}>
      {selected ? (
        <MaterialCommunityIcons name="check-bold" size={22} color={styles.dayCircle.backgroundColor} /> // يستخدم لون الخلفية ليكون متناسقًا
      ) : (
        <Text style={styles.dayLabel}>{label}</Text>
      )}
    </View>
  </TouchableOpacity>
);

type FrequencyType = 'daily' | 'specific_days' | 'interval';

interface Props {
  frequencyType: FrequencyType;
  onFrequencyChange: (value: FrequencyType) => void;
  specificDays: string[];
  onDayToggle: (day: string) => void;
  intervalValue: string;
  onIntervalChange: (value: string) => void;
}

export default function FrequencySection({ frequencyType, onFrequencyChange, specificDays, onDayToggle, intervalValue, onIntervalChange }: Props) {
  const theme = useTheme();
  const { t } = useTranslation();
  const styles = createStyles(theme);

  const weekDays = React.useMemo(() => {
    const weekStart = startOfWeek(new Date(), { weekStartsOn: 6 });
    return Array.from({ length: 7 }).map((_, i) => ({
      key: format(addDays(weekStart, i), 'E'),
      label: t(`days.${format(addDays(weekStart, i), 'E')}`),
    }));
  }, [t]);

  return (
    <Surface style={styles.sectionContainer}>
      <View style={styles.header}>
        <View style={styles.iconCircle}>
          <MaterialCommunityIcons name="calendar-sync-outline" size={28} color={theme.colors.onPrimary} />
        </View>
        <Text variant="titleLarge" style={styles.subheading}>
          {t('addMedicine.frequencyHeader')}
        </Text>
      </View>

      <SegmentedButtons
        value={frequencyType}
        onValueChange={(value) => onFrequencyChange(value as FrequencyType)}
        buttons={[
          { value: 'daily', label: t('addMedicine.freqDaily') },
          { value: 'specific_days', label: t('addMedicine.freqSpecificDays') },
          { value: 'interval', label: t('addMedicine.freqInterval') }
        ]}
      />

      {frequencyType === 'specific_days' && (
        <View style={styles.optionsContainer}>
          <Text style={styles.optionsLabel}>{t('addMedicine.chooseDays')}</Text>
          <View style={styles.daySelector}>
            {weekDays.map(day => (
              <DayButton
                key={day.key}
                label={day.label}
                selected={specificDays.includes(day.key)}
                onPress={() => onDayToggle(day.key)}
                styles={styles}
              />
            ))}
          </View>
        </View>
      )}

      {frequencyType === 'interval' && (
        <View style={styles.optionsContainer}>
          <View style={styles.intervalInputContainer}>
            <Text style={styles.intervalText}>{t('addMedicine.intervalPrefix')}</Text>
            <TextInput
              mode="outlined"
              style={styles.intervalInput}
              keyboardType="numeric"
              value={intervalValue}
              onChangeText={onIntervalChange}
              dense
            />
            <Text style={styles.intervalText}>{t('addMedicine.intervalSuffix')}</Text>
          </View>
        </View>
      )}
    </Surface>
  );
}
