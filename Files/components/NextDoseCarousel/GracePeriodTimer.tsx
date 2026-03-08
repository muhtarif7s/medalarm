import { pad } from '@/utils/time';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { Text, View } from 'react-native';
import { useTheme } from 'react-native-paper'; // <-- استيراد
import { getStyles } from './styles'; // <-- استيراد الدالة

export const GracePeriodTimer = ({ scheduledTime, now }: { scheduledTime: Date; now: Date }) => {
  const diffInSeconds = (now.getTime() - scheduledTime.getTime()) / 1000;
  const secondsLeft = Math.max(0, 120 - diffInSeconds);
  const minutes = Math.floor(secondsLeft / 60);
  const seconds = Math.floor(secondsLeft % 60);
  const theme = useTheme(); // <-- الحصول على الثيم
  const styles = getStyles(theme); // <-- توليد الأنماط
  
  return (
    <View style={styles.gracePeriodContainer}>
      <MaterialCommunityIcons name="timer-sand" color="#FFAB91" size={16} />
      <Text style={styles.gracePeriodText}>{`ينتهي خلال ${pad(minutes)}:${pad(seconds)}`}</Text>
    </View>
  );
};
