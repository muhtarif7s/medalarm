// الموقع: components2/NextDoseCarousel/index.tsx

import { useAppContext } from '@/context/AppContext';
import * as doseActions from '@/services/doseActions';
import type { UpcomingDose } from '@/types/medicine';
import { isAfter, subMinutes } from 'date-fns';
import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { FlatList, Text, View } from 'react-native';
import { useTheme } from 'react-native-paper';
import { DoseItem } from './DoseItem'; // ✅ 1. تم تصحيح مسار الاستيراد
import { MainCountdownTimer } from './MainCountdownTimer';
import { getStyles } from './styles';

export default function NextDoseCarousel() {
  const { medicines, upcomingDoses, refreshData } = useAppContext();
  const [now, setNow] = useState(new Date());
  const flatListRef = useRef<FlatList<UpcomingDose>>(null);
  const theme = useTheme();
  const styles = getStyles(theme);

  useEffect(() => {
    const timerId = setInterval(() => setNow(new Date()), 1000);
    return () => clearInterval(timerId);
  }, []);

  const liveUpcomingDoses = useMemo(() => {
    const gracePeriodThreshold = subMinutes(now, 2);
    return upcomingDoses.filter(dose => isAfter(dose.scheduledTime, gracePeriodThreshold));
  }, [upcomingDoses, now]);

  const countdownTargetDose = useMemo(() => {
    return liveUpcomingDoses.find(dose => isAfter(dose.scheduledTime, now));
  }, [liveUpcomingDoses, now]);

  const prevDoseCount = useRef(liveUpcomingDoses.length);
  useEffect(() => {
    if (liveUpcomingDoses.length > 0 && liveUpcomingDoses.length < prevDoseCount.current) {
      flatListRef.current?.scrollToIndex({ index: 0, animated: true });
      refreshData();
    }
    prevDoseCount.current = liveUpcomingDoses.length;
  }, [liveUpcomingDoses, refreshData]);

  const handleTakeDose = useCallback((dose: UpcomingDose) => {
    doseActions.handleTakeDose(dose, refreshData);
  }, [refreshData]);

  const handleSkipDose = useCallback((dose: UpcomingDose) => {
    doseActions.handleSkipDose(dose, refreshData);
  }, [refreshData]);

  if (liveUpcomingDoses.length === 0) {
    return (
      <View style={styles.container}>
        <Text style={styles.noDoseText}>🎉 لا توجد جرعات قادمة اليوم. استمتع بيومك!</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerText}>الجرعة القادمة خلال</Text>
        <MainCountdownTimer targetTime={countdownTargetDose?.scheduledTime || liveUpcomingDoses[0].scheduledTime} now={now} />
      </View>
      <FlatList
        ref={flatListRef}
        data={liveUpcomingDoses}
        renderItem={({ item }) => {
          const medicineDetails = medicines.find(m => m.id === item.medicineId);
          return <DoseItem dose={item} medicine={medicineDetails} onTakeDose={handleTakeDose} onSkipDose={handleSkipDose} now={now} />;
        }}
        keyExtractor={(item) => item.medicineId.toString() + item.scheduledTime.toISOString()}
        horizontal
        // --- ✅ 2. تمت إضافة خاصية inverted لدعم RTL تلقائيًا ---
        inverted
        pagingEnabled
        showsHorizontalScrollIndicator={false}
        style={styles.carousel}
        contentContainerStyle={{ paddingHorizontal: 8 }}
      />
    </View>
  );
}
