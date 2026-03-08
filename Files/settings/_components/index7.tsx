import { useAppContext } from '@/context/AppContext';
import { Stack, router } from 'expo-router';
import React from 'react';
import { SafeAreaView, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useTheme } from 'react-native-paper';
import { MedicineListItem } from '../../../medicines/components/MedicineListItem';

export default function MedicinesListScreen() {
  const theme = useTheme();
  const { medicines, startupLoading } = useAppContext();

  const navigateToEdit = (medicineId: number) => {
    router.push(`./medicines/edit/${medicineId}`);
  };

  return (
    <SafeAreaView style={[styles.screen, { backgroundColor: theme.colors.background }]}>
      <Stack.Screen options={{ title: 'أدويتي' }} />
      
      <ScrollView contentContainerStyle={styles.container} showsVerticalScrollIndicator={false}>
        <Text style={[styles.header, { color: theme.colors.onSurface }]}>قائمة الأدوية</Text>
        <Text style={[styles.subtitle, { color: theme.colors.onSurfaceVariant }]}>
          {medicines.length > 0 
            ? `لديك ${medicines.length} دواء نشط. اضغط على أي دواء لتعديله.`
            : 'لا توجد أدوية مضافة حالياً.'
          }
        </Text>

        {startupLoading ? (
          <View style={styles.loadingContainer}>
            <Text style={[styles.loadingText, { color: theme.colors.onSurfaceVariant }]}>
              جار تحميل الأدوية...
            </Text>
          </View>
        ) : medicines.length === 0 ? (
          <View style={styles.emptyContainer}>
            <Text style={[styles.emptyText, { color: theme.colors.onSurfaceVariant }]}>
              لا توجد أدوية لعرضها
            </Text>
            <Text style={[styles.emptySubtext, { color: theme.colors.onSurfaceVariant }]}>
              يمكنك إضافة الأدوية من الشاشة الرئيسية
            </Text>
          </View>
        ) : (
          <View style={styles.listContainer}>
            {medicines.map((medicine) => (
              <MedicineListItem
                key={medicine.id}
                name={medicine.name}
                dosage={`${medicine.dosage_amount} ${medicine.dosage_unit}`}
                color={medicine.color || '#10B981'}
                onPress={() => navigateToEdit(medicine.id)}
              />
            ))}
          </View>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
  },
  container: {
    padding: 16,
    flexGrow: 1,
  },
  header: {
    fontFamily: 'Cairo-Bold',
    fontSize: 28,
    textAlign: 'auto',
    marginBottom: 4,
  },
  subtitle: {
    fontFamily: 'Cairo-Regular',
    fontSize: 16,
    textAlign: 'auto',
    marginBottom: 24,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: 40,
  },
  loadingText: {
    fontFamily: 'Cairo-Regular',
    fontSize: 16,
  },
  emptyContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: 40,
  },
  emptyText: {
    fontFamily: 'Cairo-SemiBold',
    fontSize: 18,
    textAlign: 'center',
    marginBottom: 8,
  },
  emptySubtext: {
    fontFamily: 'Cairo-Regular',
    fontSize: 14,
    textAlign: 'center',
  },
  listContainer: {
    flex: 1,
  },
});
