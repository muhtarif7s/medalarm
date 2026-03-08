// الموقع: app/(tabs)/home/components/QuickActions.tsx

import { MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { StyleSheet, Text, TouchableOpacity, View, ViewStyle } from 'react-native';
import { MD3Theme, useTheme } from 'react-native-paper';

// --- ✅ الخطوة 1: تحويل الأنماط إلى دالة ذكية تدعم الثيم واتجاه اللغة ---
const getStyles = (theme: MD3Theme) => StyleSheet.create({
  container: {
    marginTop: 30,
    marginHorizontal: 16,
  },
  title: {
    fontFamily: 'Cairo-Bold',
    fontSize: 18,
    color: theme.colors.onSurface, // <-- استخدام لون النص الرئيسي
    marginBottom: 12,
    textAlign: 'auto', // <-- يدعم RTL/LTR تلقائيًا
  },
  buttonsRow: {
    flexDirection: 'row-reverse', // <-- يضمن الترتيب من اليمين لليسار في RTL
    justifyContent: 'space-between',
  },
  button: {
    backgroundColor: theme.colors.surfaceVariant, // <-- استخدام لون السطح
    borderRadius: 16,
    padding: 16,
    alignItems: 'center',
    width: '23%',
  },
  buttonText: {
    fontFamily: 'Cairo-Bold',
    color: theme.colors.onSurfaceVariant, // <-- استخدام لون النص الثانوي
    fontSize: 10,
    marginTop: 8,
  },
});

// --- ✅ الخطوة 2: تبسيط المكون الفرعي ليصبح "غبيًا" ومطيعًا ---
import { TextStyle } from 'react-native';

const ActionButton = ({ icon, label, color, styles }: { 
  icon: React.ComponentProps<typeof MaterialCommunityIcons>['name'], 
  label: string,
  color: string,
  styles: { button: ViewStyle, buttonText: TextStyle } // <-- يصحح نوع الأنماط
}) => (
  <TouchableOpacity style={styles.button}>
    <MaterialCommunityIcons name={icon} size={30} color={color} />
    <Text style={styles.buttonText}>{label}</Text>
  </TouchableOpacity>
);


// --- ✅ الخطوة 3: المكون الأب أصبح هو "مركز التحكم" ---
export default function QuickActions() {
  const theme = useTheme(); // <-- 1. يحصل على الثيم
  const styles = getStyles(theme); // <-- 2. يولد الأنماط

  return (
    <View style={styles.container}>
      <Text style={styles.title}>الإجراءات السريعة</Text>
      <View style={styles.buttonsRow}>
        {/* --- 3. يوزع الألوان والأنماط على المكونات الفرعية --- */}
        <ActionButton icon="bell-outline" label="التنبيهات" color={theme.colors.primary} styles={styles} />
        <ActionButton icon="package-variant-closed" label="المخزون" color={theme.colors.primary} styles={styles} />
        <ActionButton icon="lock-outline" label="تأمين" color={theme.colors.primary} styles={styles} />
        <ActionButton icon="file-chart-outline" label="تقارير" color={theme.colors.primary} styles={styles} />
      </View>
    </View>
  );
}
