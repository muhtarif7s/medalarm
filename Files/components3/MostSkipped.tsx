// الموقع: components3/MostSkipped.tsx

import { useAppContext } from '@/context/AppContext';
import { useTranslation } from '@/context/TranslationContext';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import React, { useMemo } from 'react';
import { StyleSheet, Text, View } from 'react-native';

// --- ✅ الخطوة 1: بناء مكون "شريط" ذكي واحترافي ---
// هذا المكون مسؤول عن رسم شريط واحد فقط للدواء
const SkippedMedicineBar = ({ name, count, color, icon, maxCount }: any) => {
  // حساب عرض الشريط كنسبة مئوية من أكبر عدد مرات تخطي
  const barWidth = maxCount > 0 ? (count / maxCount) * 100 : 0;

  return (
    <View style={styles.barContainer}>
      <View style={[styles.iconContainer, { backgroundColor: `${color}30` }]}>
        <MaterialCommunityIcons name={icon || 'pill'} size={20} color={color} />
      </View>
      <View style={styles.barBackground}>
        <View style={[styles.barForeground, { width: `${barWidth}%`, backgroundColor: color }]}>
          <Text style={styles.barText}>{name}</Text>
        </View>
      </View>
      <Text style={styles.countText}>{count}</Text>
    </View>
  );
};

export default function MostSkipped() {
  const { t } = useTranslation();
  const { medicines } = useAppContext();

  // --- ✅ الخطوة 2: منطق محسّن لتحديد أكثر الأدوية تفويتاً ---
  const mostSkipped = useMemo(() => {
    // فلترة وترتيب الأدوية
    const sorted = medicines
      .filter(med => med.skip_count > 0)
      .sort((a, b) => b.skip_count - a.skip_count)
      .slice(0, 3); // نأخذ أكثر 3 فقط

    // العثور على أعلى قيمة لتكون مرجعًا لعرض الشريط
    const maxCount = sorted.length > 0 ? sorted[0].skip_count : 0;
    
    return { sorted, maxCount };
  }, [medicines]);

  if (mostSkipped.sorted.length === 0) {
    return <Text style={styles.emptyText}>{t('statistics.noSkipped')}</Text>;
  }

  return (
    <View style={styles.container}>
      {mostSkipped.sorted.map((med) => (
        <SkippedMedicineBar
          key={med.id}
          name={med.name}
          count={med.skip_count}
          color={med.color || '#EF5350'}
          icon={med.icon_name}
          maxCount={mostSkipped.maxCount}
        />
      ))}
    </View>
  );
}

// --- ✅ الخطوة 3: أنماط جديدة بالكامل لدعم تصميم الرسم البياني ---
const styles = StyleSheet.create({
  container: {
    paddingVertical: 10,
    gap: 16, // مسافة بين كل شريط
  },
  emptyText: { 
    textAlign: 'center', 
    fontFamily: 'Cairo-Regular', 
    padding: 20,
    opacity: 0.7,
    color: '#8b8b8bff',
  },
  barContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
  iconContainer: {
    width: 36,
    height: 36,
    borderRadius: 18,
    alignItems: 'center',
    justifyContent: 'center',
  },
  barBackground: {
    flex: 1,
    height: 28,
    backgroundColor: '#3c4a5e', // لون خلفية الشريط
    borderRadius: 8,
    justifyContent: 'center',
  },
  barForeground: {
    height: '100%',
    borderRadius: 8,
    justifyContent: 'center',
    minWidth: 50, // حد أدنى للعرض لضمان ظهور النص
    paddingStart: 12,

  },
  barText: {
    fontFamily: 'Cairo-Bold',
    color: 'white',
    fontSize: 12,
  },
  countText: {
    fontFamily: 'Cairo-Bold',
    fontSize: 16,
    width: 30, // تحديد عرض ثابت لترتيب الأرقام
    textAlign: 'center',
    color: '#ff6246ff', // لون ثابت للنص
  },
});
