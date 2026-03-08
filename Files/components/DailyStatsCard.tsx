// الموقع: app/(tabs)/home/components/DailyStatsCard.tsx

import { useAppContext } from '@/context/AppContext';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { isToday, parseISO } from 'date-fns';
import React, { useMemo } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { Card, MD3Theme, ProgressBar, useTheme } from 'react-native-paper';

// --- ✅ الخطوة 1: تحويل الأنماط إلى دالة ذكية تقبل الثيم ---
const getStyles = (theme: MD3Theme) => StyleSheet.create({
  card: {
    marginHorizontal: 16,
    marginTop: 20,
    backgroundColor: theme.colors.surfaceVariant, // <-- استخدام لون السطح من الثيم
    borderRadius: 16,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  title: {
    fontFamily: 'Cairo-Bold',
    fontSize: 18,
    color: theme.colors.onSurface, // <-- لون النص الرئيسي
  },
  statsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginBottom: 16,
  },
  statItem: {
    alignItems: 'center',
  },
  statLabel: {
    fontFamily: 'Cairo-Regular',
    fontSize: 14,
    color: theme.colors.onSurfaceVariant, // <-- لون النص الثانوي
  },
  statValue: {
    fontFamily: 'Cairo-Bold',
    fontSize: 20,
    color: theme.colors.onSurface, // <-- لون النص الرئيسي
  },
  progressContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
  progressBar: {
    height: 8,
    borderRadius: 4,
    flex: 1,
  },
  progressText: {
    fontFamily: 'Cairo-Bold',
    fontSize: 14,
    color: theme.colors.onSurface, // <-- لون النص الرئيسي
  },
});


export default function DailyStatsCard() {
  const theme = useTheme();
  const styles = getStyles(theme); // <-- ✅ الخطوة 2: توليد الأنماط باستخدام الثيم الحالي
  const { medicines, doseHistory, missedDoses } = useAppContext();

  const stats = useMemo(() => {
    let totalToday = 0;
    medicines.forEach(med => {
      const startDate = parseISO(med.start_date);
      const endDate = med.end_date ? parseISO(med.end_date) : null;
      const today = new Date();
      if (today < startDate || (endDate && today > endDate)) {
        return;
      }
      const doseTimes = JSON.parse(med.dose_times || '[]');
      totalToday += doseTimes.length;
    });
    const takenToday = doseHistory.filter(
      (dose) => dose.status === 'taken' && dose.taken_at && isToday(parseISO(dose.taken_at))
    ).length;
    const missedToday = missedDoses.filter(
      (dose) => isToday(dose.scheduledTime)
    ).length;
    return { 
      taken: takenToday, 
      total: totalToday, 
      missed: missedToday,
    };
  }, [medicines, doseHistory, missedDoses]);

  const { taken, total, missed } = stats;
  const remaining = total - taken;
  const progress = total > 0 ? taken / total : 0;

  return (
    <Card style={styles.card}>
      <Card.Content>
        <View style={styles.header}>
          <Text style={styles.title}>إحصائيات اليوم</Text>
          {/* ✅ الخطوة 3: استخدام لون من الثيم مباشرة في خاصية المكون */}
          <MaterialCommunityIcons name="calendar-check" size={24} color={theme.colors.primary} />
        </View>

        <View style={styles.statsContainer}>
          <View style={styles.statItem}>
            <Text style={styles.statLabel}>مكتمل</Text>
            <Text style={styles.statValue}>{`${taken}/${total}`}</Text>
          </View>
          <View style={styles.statItem}>
            <Text style={styles.statLabel}>متبقي</Text>
            <Text style={styles.statValue}>{remaining < 0 ? 0 : remaining}</Text>
          </View>
          <View style={styles.statItem}>
            <Text style={styles.statLabel}>فاتت</Text>
            {/* هذا الجزء كان يستخدم الثيم بالفعل، وهو صحيح */}
            <Text style={[styles.statValue, { color: theme.colors.error }]}>{missed}</Text>
          </View>
        </View>

        <View style={styles.progressContainer}>
          {/* ✅ الخطوة 4: استخدام لون من الثيم مباشرة في خاصية المكون */}
          <ProgressBar progress={progress} color={theme.colors.primary} style={styles.progressBar} />
          <Text style={styles.progressText}>{`${Math.round(progress * 100)}%`}</Text>
        </View>
      </Card.Content>
    </Card>
  );
}
