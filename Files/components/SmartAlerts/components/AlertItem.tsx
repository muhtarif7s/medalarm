// الموقع: DoctorDaily/components/SmartAlerts/components/AlertItem.tsx
import { MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { Text, View } from 'react-native';
import { useTheme } from 'react-native-paper';
import { getStyles } from './styles';

interface AlertItemProps {
  icon: React.ComponentProps<typeof MaterialCommunityIcons>['name'];
  color: string;
  text: string;
}

export const AlertItem: React.FC<AlertItemProps> = ({ icon, color, text }) => {
  // هذا المكون الآن يعتمد على نفسه بالكامل
  const theme = useTheme();
  const styles = getStyles(theme);

  return (
    <View style={styles.alertItem}>
      <MaterialCommunityIcons name={icon} size={24} color={color} />
      <Text style={styles.alertText}>{text}</Text>
    </View>
  );
};
