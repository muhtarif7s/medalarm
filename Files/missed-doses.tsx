// الموقع: app/missed-doses.tsx

import { useAppContext } from '@/context/AppContext';
import * as manager from '@/services/medicineManager';
import type { UpcomingDose } from '@/types/medicine';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { format } from 'date-fns';
import { ar } from 'date-fns/locale';
import { useRouter } from 'expo-router';
import React, { useCallback } from 'react';
import { Alert, FlatList, StyleSheet, Text, View } from 'react-native';
import { Appbar, Button, Card, useTheme } from 'react-native-paper';

const MissedDoseItem = ({
  dose, 
  onTake,
  onSkip,
}: {
  dose: UpcomingDose;
  onTake: (dose: UpcomingDose) => void;
  onSkip: (dose: UpcomingDose) => void;
}) => {
  const theme = useTheme();
  return (
    <Card style={styles.card}>
      <Card.Title
        title={dose.medicineName}
        subtitle={`فات موعد جرعة ${dose.dosage} في ${format(dose.scheduledTime, "d MMM, h:mm a", { locale: ar })}`}
        titleStyle={[styles.cardTitle, { color: theme.colors.onSurface }]}
        subtitleStyle={[styles.cardSubtitle, { color: theme.colors.onSurfaceVariant }]}
        left={(props) => <MaterialCommunityIcons {...props} name="alert-circle-outline" color="#FFAB91" size={32} />}
      />
      <Card.Actions style={styles.cardActions}>
        <Button mode="text" onPress={() => onSkip(dose)} textColor={theme.colors.onSurfaceVariant}>
          تخطي
        </Button>
        <Button mode="contained" onPress={() => onTake(dose)} buttonColor='#00ACC1'>
          تم أخذها الآن
        </Button>
      </Card.Actions>
    </Card>
  );
};

// شاشة الجرعات الفائتة الكاملة
export default function MissedDosesScreen() {
  const { missedDoses, refreshData } = useAppContext();
  const router = useRouter();
  const theme = useTheme();

  // دالة معالجة أخذ الجرعة
  const handleTakeDose = useCallback(async (dose: UpcomingDose) => {
    Alert.alert("تأكيد أخذ الجرعة", `هل أنت متأكد أنك أخذت جرعة (${dose.dosage}) من ${dose.medicineName}؟`,
      [{ text: "إلغاء", style: "cancel" }, { text: "نعم، تم أخذها", onPress: async () => {
          await manager.handleTakeDose(dose);
          await refreshData();
      }}]
    );
  }, [refreshData]);

  // دالة معالجة تخطي الجرعة
  const handleSkipDose = useCallback(async (dose: UpcomingDose) => {
     await manager.handleSkipDose(dose);
     await refreshData();
     Alert.alert("تم التخطي", `تم تسجيل أن جرعة ${dose.medicineName} قد تم تخطيها.`);
  }, [refreshData]);

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <Appbar.Header>
        <Appbar.BackAction onPress={() => router.back()} />
        <Appbar.Content title="الجرعات الفائتة" titleStyle={{ fontFamily: 'Cairo-Bold' }} />
      </Appbar.Header>
      
      {missedDoses.length === 0 ? (
        <View style={styles.emptyContainer}>
            <MaterialCommunityIcons name="check-circle-outline" size={80} color={theme.colors.primary} />
            <Text style={[styles.emptyText, { color: theme.colors.onSurface }]}>لا توجد جرعات فائتة. عمل رائع!</Text>
        </View>
      ) : (
        <FlatList
          data={missedDoses}
          keyExtractor={(item) => item.medicineId.toString() + item.scheduledTime.toISOString()}
          renderItem={({ item }) => (
            <MissedDoseItem dose={item} onTake={handleTakeDose} onSkip={handleSkipDose} />
          )}
          contentContainerStyle={styles.listContent}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  listContent: { padding: 16 },
  card: { marginBottom: 16 },
  cardTitle: { fontFamily: 'Cairo-Bold' },
  cardSubtitle: { fontFamily: 'Cairo-Regular', marginTop: 4 },
  cardActions: { justifyContent: 'flex-end', paddingTop: 8, paddingBottom: 8 },
  emptyContainer: { flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20 },
  emptyText: { fontFamily: 'Cairo-Bold', fontSize: 18, marginTop: 16, textAlign: 'center' },
});
