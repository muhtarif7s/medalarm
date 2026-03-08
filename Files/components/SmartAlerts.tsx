// الموقع: DoctorDaily/components/SmartAlerts/index.tsx
import React from 'react';
import { Text, View } from 'react-native';
import { useTheme } from 'react-native-paper';
import { AlertItem } from '../components/SmartAlerts/components/AlertItem';
import { getStyles } from './SmartAlerts/components/styles';

export default function SmartAlerts() {
  const theme = useTheme();
  const styles = getStyles(theme);

  return (
    <View style={styles.container}>
      {/* العنوان مع كلمة "قريبًا" في مستطيل صغير */}
      <View style={styles.titleRow}>
        {/* <Text style={styles.title}>الإجراءات السريعة</Text> */}
        <View style={styles.soonBox}>
          <Text style={styles.soonText}>قريبًا</Text>
        </View>
      </View>

      <AlertItem
        icon="alert-circle-outline"
        color={theme.colors.tertiary}
        text="أوشك مخزون دواء Vitamin C على الانتهاء."
      />
      <AlertItem
        icon="lightbulb-on-outline"
        color={theme.colors.primary}
        text="نصيحة: لا تنس شرب الكثير من الماء مع الدواء."
      />
      <AlertItem
        icon="calendar-check-outline"
        color={theme.colors.onSurface}
        text="موعد متابعة مع د. محمد عبد الله الساعة 3:00."
      />
    </View>
  );
}
