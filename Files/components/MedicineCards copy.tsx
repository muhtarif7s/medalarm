// الموقع: components2/MedicineCards.tsx

import { useAppContext } from '@/context/AppContext';
import type { Medicine } from '@/types/medicine';
import { differenceInCalendarDays, format, parseISO } from 'date-fns';
import { ar } from 'date-fns/locale';
import React from 'react';
import { ActivityIndicator, Image, StyleSheet, Text, View } from 'react-native';
import { useTheme } from 'react-native-paper';
import MedicineListItem from './MedicineListItem';

// ✅ الآن getMedicineIcon ترجّع صورة للكارت
const getMedicineIcon = (med: Medicine) => {
  return (
    <Image
      source={require('../assets/images/pill-yellow.png')}
      style={{ width: 50, height: 50, borderRadius: 8 }}
      resizeMode="cover"
    />
  );
};

export default function MedicineCards() {
  const { medicines, startupLoading } = useAppContext();
  const theme = useTheme();

  if (startupLoading) {
    return <ActivityIndicator style={{ marginTop: 40 }} color={theme.colors.primary} />;
  }

  return (
    <View style={styles.container}>
      <Text style={[styles.title, { color: theme.colors.onBackground }]}>أدويتي</Text>

      {medicines.length === 0 ? (
        <Text style={[styles.emptyText, { color: theme.colors.onSurfaceVariant }]}>
          لم تقم بإضافة أي أدوية بعد.
        </Text>
      ) : (
        medicines.map((med) => {
          const doseTimes: string[] = JSON.parse(med.dose_times || '[]');
          const pillsLeft = med.remaining_quantity ?? 0;
          const pillsTotal = med.total_quantity ?? 0;

          let dateInfo: string | null = null;
          let daysLeftText: string | null = null;

          if (med.start_date) {
            const startDate = parseISO(med.start_date);
            if (med.end_date) {
              const endDate = parseISO(med.end_date);
              dateInfo = `من ${format(startDate, 'd/M')} إلى ${format(endDate, 'd/M')}`;
              const daysLeft = differenceInCalendarDays(endDate, new Date());
              if (daysLeft >= 0) {
                if (daysLeft === 0) daysLeftText = 'اليوم هو آخر يوم';
                else if (daysLeft === 1) daysLeftText = 'باقي يوم واحد';
                else if (daysLeft === 2) daysLeftText = 'باقي يومان';
                else daysLeftText = `باقي ${daysLeft} يومًا`;
              } else {
                daysLeftText = 'انتهت المدة';
              }
            } else {
              dateInfo = `بدأ في ${format(startDate, 'd MMM', { locale: ar })}`;
            }
          }

          return (
            <MedicineListItem
              key={med.id}
              name={med.name}
              dosage={`${med.dosage_amount} ${med.dosage_unit}`}
              time={doseTimes[0] || 'غير محدد'}
              pillsLeft={pillsLeft}
              pillsTotal={pillsTotal}
              icon={getMedicineIcon(med)}
              iconColor={med.color || theme.colors.primary}
              dateInfo={dateInfo}
              daysLeftText={daysLeftText}
            />
          );
        })
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { 
    marginTop: 30, 
    marginHorizontal: 16, 
    marginBottom: 20 
  },
  title: { 
    fontFamily: 'Cairo-Bold', 
    fontSize: 18, 
    marginBottom: 12, 
    textAlign: 'right' 
  },
  emptyText: { 
    fontFamily: 'Cairo-Regular', 
    textAlign: 'center', 
    marginTop: 20, 
    fontSize: 16 
  },
});