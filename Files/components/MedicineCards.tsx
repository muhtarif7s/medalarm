// الموقع: components2/MedicineCards.tsx

import { useAppContext } from '@/context/AppContext';
import type { Medicine } from '@/types/medicine';
import { differenceInCalendarDays, format, parseISO } from 'date-fns';
import { ar } from 'date-fns/locale';
import { Link } from 'expo-router';
import React from 'react';
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native';
import { MD3Theme, useTheme } from 'react-native-paper';
import MedicineListItem from './MedicineListItem';

const getStyles = (theme: MD3Theme) => StyleSheet.create({
  container: {
    marginTop: 30,
    marginHorizontal: 16,
    marginBottom: 20,
  },
  headerContainer: {
    flexDirection: 'row-reverse',
    justifyContent: 'space-between',
    alignItems: 'center', // يضمن المحاذاة العمودية الصحيحة للعنوان والزر
    marginBottom: 12,
  },
  title: {
    fontFamily: 'Cairo-Bold',
    fontSize: 18,
    color: theme.colors.onSurface,
    textAlign: 'auto',
    marginStart: 13, // يضمن المسافة بين العنوان وحافة الشاشة
  },
  seeAllButtonText: {
    fontFamily: 'Cairo-SemiBold',
    fontSize: 14,
    marginEnd: 13,
    color: theme.colors.primary,
  },
  emptyText: {
    fontFamily: 'Cairo-Regular',
    color: theme.colors.onSurfaceVariant,
    textAlign: 'center', // هنا 'center' أفضل من 'auto'
    marginTop: 20,
    fontSize: 16,
  },
});

// في ملف: components2/MedicineCards.tsx

// افترض أن كل دواء له خاصية اسمها form (مثل: 'pill', 'syrup')
const getMedicineIcon = (med: Medicine) => {
    switch (med.form) { // 'form' هو اسم الخاصية التي تحدد شكل الدواء
        case 'pill-red':
            return require('@/assets/images/pill-red.png');
        case 'pill-yellow':
            return require('@/assets/images/pill-yellow.png');
        case 'pill-blue':
            return require('@/assets/images/pill-blue.png');
        default:
            // أيقونة افتراضية في حال لم يتم تحديد الشكل
            return require('@/assets/images/pill-yellow.png');
    }
};


export default function MedicineCards() {
  // --- ✅ الإصلاح الأول: استخدام اسم المتغير الصحيح من المخزن ---
  const { medicines, startupLoading } = useAppContext();
  const theme = useTheme();
  const styles = getStyles(theme);

  if (startupLoading) {
    return <ActivityIndicator style={{ marginTop: 40 }} color={theme.colors.primary} />;
  }
  
  return (
    <View style={styles.container}>
      <View style={styles.headerContainer}>
                {/* --- ✅ الإصلاح الثاني: استخدام رابط التنقل الصحيح --- */}
        <Link href="/settings/_components/index7" asChild>
          <Text style={styles.seeAllButtonText}>عرض الكل</Text>
        </Link>
        <Text style={styles.title}>أدويتي</Text>
      </View>

      {medicines.length === 0 ? (
        <Text style={styles.emptyText}>لم تقم بإضافة أي أدوية بعد.</Text>
      ) : (
        // عرض أول 3 أدوية فقط في الشاشة الرئيسية
        medicines.slice(0, 3).map((med) => {
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
