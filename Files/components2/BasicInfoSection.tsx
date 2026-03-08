// الموقع: app/(tabs)/add-medicine/components/BasicInfoSection.tsx

import { useTranslation } from '@/context/TranslationContext';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { Platform, StyleSheet, View } from 'react-native';
import { Surface, Text, TextInput, useTheme, type MD3Theme } from 'react-native-paper';

interface Props {
  name: string;
  onNameChange: (text: string) => void;
  dosageAmount: string;
  onDosageAmountChange: (text: string) => void;
  dosageUnit: string;
  onDosageUnitChange: (text: string) => void;
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
  input: {
    flex: 1,
    marginBottom: 14,
    textAlign: 'auto', // ✅ الأهم: محاذاة النص داخل الحقل تلقائية
  },
});


export default function BasicInfoSection({
  name, onNameChange, dosageAmount, onDosageAmountChange, dosageUnit, onDosageUnitChange
}: Props) {
  const theme = useTheme();
  const { t } = useTranslation();
  const styles = createStyles(theme);

  return (
    <Surface style={styles.sectionContainer}>
      <View style={styles.header}>
        <View style={styles.iconCircle}>
          <MaterialCommunityIcons name="pill" size={28} color={theme.colors.onPrimary} />
        </View>
        <Text variant="titleLarge" style={styles.subheading}>
          {t('addMedicine.basicInfoHeader')}
        </Text>
      </View>

      {/* --- ✅ 2. تبسيط تمرير الأيقونة: 'left' كافية وستتكيف تلقائيًا --- */}
      <TextInput
        label={t('addMedicine.medicineNameLabel')}
        value={name}
        onChangeText={onNameChange}
        mode="outlined"
        style={styles.input}
        left={<TextInput.Icon icon="form-textbox" />}
      />

      <View style={styles.row}>
        <TextInput
          label={t('addMedicine.doseLabel')}
          value={dosageAmount}
          onChangeText={onDosageAmountChange}
          keyboardType="numeric"
          mode="outlined"
          style={styles.input}
          left={<TextInput.Icon icon="numeric" />}
        />
        <TextInput
          label={t('addMedicine.unitLabel')}
          value={dosageUnit}
          onChangeText={onDosageUnitChange}
          mode="outlined"
          style={styles.input}
          left={<TextInput.Icon icon="weight-gram" />}
        />
      </View>
    </Surface>
  );
}
