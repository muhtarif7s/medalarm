// الموقع: app/(tabs)/add-medicine/components/InventorySection.tsx

import { useTranslation } from '@/context/TranslationContext';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { Platform, StyleSheet, View } from 'react-native';
import { Surface, Text, TextInput, useTheme, type MD3Theme } from 'react-native-paper';

interface Props {
  totalQuantity: string;
  onTotalQuantityChange: (value: string) => void;
  refillReminderAt: string;
  onRefillReminderAtChange: (value: string) => void;
}

// --- ✅ 1. الأنماط الآن أبسط وتعتمد بالكامل على الخصائص التلقائية ---
const createStyles = (theme: MD3Theme) => StyleSheet.create({
  sectionContainer: {
    padding: 18,
    borderRadius: 20,
    marginBottom: 24,
    backgroundColor: theme.colors.elevation.level2,
    ...Platform.select({
      android: { elevation: 2 },
      ios: { shadowOpacity: 0.08, shadowRadius: 10, shadowOffset: { width: 0, height: 4 }, shadowColor: theme.colors.shadow },
    }),
  },
  header: {
    flexDirection: 'row-reverse', // ✅ صحيح: اتجاه من اليمين لليسار
    alignItems: 'center',
    gap: 14,
    marginBottom: 8,
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
  helperText: {
    color: theme.colors.onSurfaceVariant,
    fontSize: 14,
    marginBottom: 20,
    paddingHorizontal: 5,
    textAlign: 'auto',
    fontFamily: 'Cairo-Regular',
  },
  input: {
    marginBottom: 16, // تم نقل الهامش إلى هنا
    textAlign: 'auto',
  },
});


export default function InventorySection({
  totalQuantity, onTotalQuantityChange, refillReminderAt, onRefillReminderAtChange
}: Props) {
  const theme = useTheme();
  const { t } = useTranslation();
  const styles = createStyles(theme);

  return (
    <Surface style={styles.sectionContainer} elevation={4}>
      <View style={styles.header}>
        <View style={styles.iconCircle}>
          <MaterialCommunityIcons name="archive-arrow-down-outline" size={28} color={theme.colors.onPrimary} />
        </View>
        <Text variant="titleLarge" style={styles.subheading}>
          {t('addMedicine.inventoryHeader')}
        </Text>
      </View>

      <Text style={styles.helperText}>
        {t('addMedicine.inventoryHelperText')}
      </Text>

      {/* --- ✅ 2. تبسيط الكود بالكامل والاعتماد على المكون الذكي --- */}
      <TextInput
        label={t('addMedicine.totalQuantity')}
        value={totalQuantity}
        onChangeText={onTotalQuantityChange}
        keyboardType="numeric"
        mode="outlined"
        style={styles.input}
        left={<TextInput.Icon icon="pound-box-outline" />}
      />

      <TextInput
        label={t('addMedicine.refillReminder')}
        value={refillReminderAt}
        onChangeText={onRefillReminderAtChange}
        keyboardType="numeric"
        mode="outlined"
        style={styles.input}
        left={<TextInput.Icon icon="bell-ring-outline" />}
      />
    </Surface>
  );
}
