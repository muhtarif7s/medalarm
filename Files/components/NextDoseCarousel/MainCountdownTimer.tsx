import { pad } from '@/utils/time';
import React from 'react';
import { Text } from 'react-native';
import { getStyles } from './styles'; // <-- استيراد الدالة

import { useTheme } from 'react-native-paper'; // <-- استيراد
export const MainCountdownTimer = ({ targetTime, now }: { targetTime: Date; now: Date }) => {
  const theme = useTheme(); // <-- الحصول على الثيم
  const styles = getStyles(theme); // <-- توليد الأنماط
  if (!targetTime) return <Text style={styles.countdownText}>--:--:--</Text>;
  const diff = targetTime.getTime() - now.getTime();
  if (diff <= 0) return <Text style={styles.countdownText}>00:00:00</Text>;
  
  const hours = Math.floor(diff / 3600000);
  const minutes = Math.floor((diff % 3600000) / 60000);
  const seconds = Math.floor((diff % 60000) / 1000);
  
  return <Text style={styles.countdownText}>{`${pad(hours)}:${pad(minutes)}:${pad(seconds)}`}</Text>;
};
