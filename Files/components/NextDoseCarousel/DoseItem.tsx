import type { Medicine, UpcomingDose } from '@/types/medicine';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { Text, TouchableOpacity, View, useWindowDimensions } from 'react-native';
import { IconButton, Surface, useTheme } from 'react-native-paper';
import { GracePeriodTimer } from './GracePeriodTimer';
import { getStyles } from './styles';

interface DoseItemProps {
  dose: UpcomingDose;
  medicine: Medicine | undefined;
  onTakeDose: (dose: UpcomingDose) => void;
  onSkipDose: (dose: UpcomingDose) => void;
  now: Date;
}

export const DoseItem = ({ dose, medicine, onTakeDose, onSkipDose, now }: DoseItemProps) => {
  const theme = useTheme();
  const styles = getStyles(theme);

  const { width } = useWindowDimensions();
  const CARD_WIDTH = width - 48;
  const diffInSeconds = (dose.scheduledTime.getTime() - now.getTime()) / 1000;
  const isUpcoming = diffInSeconds > 0;
  const isGracePeriod = diffInSeconds <= 0 && diffInSeconds > -120;
  const canSkip = medicine && medicine.skip_count < 3;

  return (
    <Surface style={[styles.doseItemContainer, { width: CARD_WIDTH }]}>
      {canSkip && (
        <IconButton
          icon="debug-step-over"
          size={24}
          onPress={() => onSkipDose(dose)}
          style={styles.skipButton}
          iconColor={theme.colors.surface} // لون أبيض ليكون واضحًا
        />
      )}

      {/* --- ✅ الهيكل الموحد والبسيط الذي يعمل في كل اللغات --- */}
      <View style={styles.medicineInfo}>
        {/* الأيقونة دائمًا هنا */}
        <View style={[styles.pillIconContainer, { backgroundColor: dose.color }]}>
          <MaterialCommunityIcons name="pill" color="white" size={30} />
        </View>

        {/* التفاصيل دائمًا هنا */}
        <View style={styles.medicineDetails}>
          <Text style={styles.medicineName}>{dose.medicineName}</Text>
          <Text style={styles.doseInfo}>{dose.dosage}</Text>
        </View>
      </View>
      
      {isGracePeriod && <GracePeriodTimer scheduledTime={dose.scheduledTime} now={now} />}
      <TouchableOpacity style={[styles.mainButton, !isUpcoming ? styles.buttonActive : styles.buttonInactive]} onPress={() => onTakeDose(dose)} disabled={isUpcoming}>
        <Text style={styles.buttonText}>{!isUpcoming ? `خذ جرعة ${dose.scheduledTime.toLocaleTimeString('ar-EG', { hour: 'numeric', minute: '2-digit' })}` : `موعد الجرعة ${dose.scheduledTime.toLocaleTimeString('ar-EG', { hour: 'numeric', minute: '2-digit' })}`}</Text>
      </TouchableOpacity>
    </Surface>
  );
}

