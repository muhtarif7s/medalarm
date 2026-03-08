// الموقع: app/medicines/components/MedicineListItem.tsx
import { MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useTheme } from 'react-native-paper';

// بيانات وهمية مؤقتًا
interface MedicineListItemProps {
  name: string;
  dosage: string;
  color: string;
  onPress: () => void;
}

export const MedicineListItem: React.FC<MedicineListItemProps> = ({ name, dosage, color, onPress }) => {
  const theme = useTheme();

  return (
    <TouchableOpacity onPress={onPress} style={[styles.container, { backgroundColor: theme.colors.surfaceVariant }]}>
      <View style={[styles.iconContainer, { backgroundColor: color }]}>
        <MaterialCommunityIcons name="pill" size={24} color={theme.colors.onPrimary} />
      </View>
      <View style={styles.textContainer}>
        <Text style={[styles.name, { color: theme.colors.onSurface }]}>{name}</Text>
        <Text style={[styles.dosage, { color: theme.colors.onSurfaceVariant }]}>{dosage}</Text>
      </View>
      <MaterialCommunityIcons name="chevron-left" size={28} color={theme.colors.onSurfaceVariant} style={styles.chevronIcon} />
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    borderRadius: 12,
    marginBottom: 12,
  },
  iconContainer: {
    padding: 12,
    borderRadius: 8,
    marginEnd: 16,
  },
  textContainer: {
    flex: 1,
  },
  name: {
    fontFamily: 'Cairo-Bold',
    fontSize: 16,
    textAlign: 'auto',
  },
  dosage: {
    fontFamily: 'Cairo-Regular',
    fontSize: 14,
    textAlign: 'auto',
  },
  chevronIcon: {
    transform: [{ scaleX: -1 }],
  },
});
