import { useAppContext } from '@/context/AppContext';
import { useFocusEffect } from 'expo-router';
import React, { useCallback, useState } from 'react';
import { RefreshControl, ScrollView, StatusBar, StyleSheet, TouchableOpacity } from 'react-native';
import { MD3Theme, useTheme } from 'react-native-paper';

import DailyStatsCard from '@/components/DailyStatsCard';
import HeaderSection from '@/components/HeaderSection';
import MedicineCards from '@/components/MedicineCards';
import NextDoseCard from '@/components/NextDoseCarousel';
import QuickActions from '@/components/QuickActions';
import SmartAlerts from '@/components/SmartAlerts';
import Timeline from '@/components/Timeline';

const getStyles = (theme: MD3Theme) => StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: theme.colors.background,
  },
  touchTopArea: {
    position: 'absolute',
    top: 0,
    height: 40,
    width: '100%',
    zIndex: 100,
  }
});

export default function HomeScreen() {
  const theme = useTheme();
  const styles = getStyles(theme);
  
  const { startupLoading, refreshData } = useAppContext();
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [statusBarHidden, setStatusBarHidden] = useState(false);

  useFocusEffect(
    useCallback(() => {
      refreshData();
    }, [refreshData])
  );

  const onRefresh = useCallback(async () => {
    setIsRefreshing(true);
    await refreshData();
    setIsRefreshing(false);
  }, [refreshData]);

  const handleScroll = (event: any) => {
    const y = event.nativeEvent.contentOffset.y;
    if (y > 50 && !statusBarHidden) {
      setStatusBarHidden(true);
      StatusBar.setHidden(true, 'slide');
    }
  };

  const showStatusBar = () => {
    if (statusBarHidden) {
      setStatusBarHidden(false);
      StatusBar.setHidden(false, 'slide');
    }
  };

  if (startupLoading && !isRefreshing) {
    return null; // أو ممكن تحط لودر
  }

  return (
    <>
      {statusBarHidden && (
        <TouchableOpacity style={styles.touchTopArea} onPress={showStatusBar} />
      )}
      <ScrollView
        style={styles.container}
        onScroll={handleScroll}
        scrollEventThrottle={16}
        refreshControl={
          <RefreshControl
            refreshing={isRefreshing}
            onRefresh={onRefresh}
            tintColor={theme.colors.primary}
            colors={[theme.colors.primary]}
          />
        }
      >
        <HeaderSection />
        <DailyStatsCard />
        <NextDoseCard />
        <Timeline />
        <MedicineCards />
        <QuickActions />
        <SmartAlerts />
      </ScrollView>
    </>
  );
}