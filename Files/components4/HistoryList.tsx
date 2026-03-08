// الموقع: app/(tabs)/history/components/HistoryList.tsx

import { useAppContext } from '@/context/AppContext';
import { useTranslation } from '@/context/TranslationContext';
import type { HistoryEvent } from '@/types/history';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { formatRelative, isSameDay, isYesterday, parseISO } from 'date-fns';
import { ar } from 'date-fns/locale';
import React, { useMemo } from 'react';
import { FlatList, StyleSheet, Text, View } from 'react-native';
import { useTheme } from 'react-native-paper';
import { HistoryItem } from './HistoryItem';

export default function HistoryList({ filter }: { filter: string }) {
  const theme = useTheme();
  const { t, language } = useTranslation();
  const { doseHistory, upcomingDoses, medicines } = useAppContext();

  const medDetailsLookup = useMemo(() => {
    const lookup = new Map<number, { name: string, icon?: string, dosage_unit: string }>();
    medicines.forEach(med => {
      lookup.set(med.id, { name: med.name, icon: med.icon_name, dosage_unit: med.dosage_unit });
    });
    return lookup;
  }, [medicines]);

  const fullHistory = useMemo(() => {
    const history: HistoryEvent[] = doseHistory.map(d => {
      const details = medDetailsLookup.get(d.medicine_id);
      return {
        id: `h-${d.id}`,
        type: d.status === 'taken' ? 'TAKEN' : 'SKIPPED',
        medicine: details?.name || 'Unknown',
        dosage: `${d.taken_at ? '' : ''}${details?.dosage_unit || ''}`, // Dosage info needs improvement if available
        time: parseISO(d.scheduled_time),
        icon: details?.icon as any || 'pill',
      };
    });

    const upcoming: HistoryEvent[] = upcomingDoses.map(d => ({
        id: `u-${d.medicineId}-${d.scheduledTime.toISOString()}`,
        type: 'UPCOMING',
        medicine: d.medicineName,
        dosage: d.dosage,
        time: d.scheduledTime,
        icon: medDetailsLookup.get(d.medicineId)?.icon as any || 'pill',
    }));

    const combined = [...history, ...upcoming];
    combined.sort((a, b) => b.time.getTime() - a.time.getTime());

    if (filter === 'all') return combined;
    return combined.filter(item => item.type.toLowerCase() === filter);
  }, [filter, doseHistory, upcomingDoses, medDetailsLookup]);


  const renderItemWithHeader = ({ item, index }: { item: HistoryEvent; index: number }) => {
    const prevItem = index > 0 ? fullHistory[index - 1] : null;
    const showDateHeader = !prevItem || !isSameDay(item.time, prevItem.time);

    let dateLabel = '';
    if (showDateHeader) {
      if (isSameDay(item.time, new Date())) dateLabel = t('history.today');
      else if (isYesterday(item.time)) dateLabel = t('history.yesterday');
      else dateLabel = formatRelative(item.time, new Date(), { locale: language === 'ar' ? ar : undefined }).split(' at ')[0];
    }

    return (
      <>
        {showDateHeader && <Text style={[styles.dateHeader, { color: theme.colors.onSurface }]}>{dateLabel}</Text>}
        <HistoryItem item={item} />
      </>
    );
  };

  return (
    <FlatList
      data={fullHistory}
      renderItem={renderItemWithHeader}
      keyExtractor={item => item.id}
      contentContainerStyle={styles.listContent}
      ListEmptyComponent={
        <View style={styles.emptyContainer}>
          <MaterialCommunityIcons name="history" size={64} color={theme.colors.surfaceVariant} />
          <Text style={[styles.emptyText, { color: theme.colors.onSurfaceVariant }]}>{t('history.noHistory')}</Text>
        </View>
      }
    />
  );
}

const styles = StyleSheet.create({
  listContent: { paddingHorizontal: 16, paddingTop: 8, paddingBottom: 40 },
  dateHeader: { fontFamily: 'Cairo-Bold', fontSize: 18, marginBottom: 12, marginTop: 8, textAlign: 'auto' },
  emptyContainer: { flex: 1, justifyContent: 'center', alignItems: 'center', paddingTop: '30%' },
  emptyText: { fontFamily: 'Cairo-Bold', marginTop: 16, fontSize: 18 },
});
