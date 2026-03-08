// الموقع: app/(tabs)/history.tsx

import HistoryList from '@/components4/HistoryList'; // <-- استيراد العقل المدبر
import { useTranslation } from '@/context/TranslationContext';
import type { MaterialCommunityIcons } from '@expo/vector-icons';
import React, { useMemo, useState } from 'react';
import { SafeAreaView, ScrollView, StyleSheet, Text, View } from 'react-native';
import { Chip, useTheme } from 'react-native-paper';

type IconName = keyof typeof MaterialCommunityIcons.glyphMap;

export default function HistoryScreen() {
  const theme = useTheme();
  const { t } = useTranslation();
  const [filter, setFilter] = useState<string>('all');

  const FILTERS = useMemo(() => [
    { key: 'all', label: t('history.all'), icon: 'select-all' as IconName },
    { key: 'taken', label: t('history.taken'), icon: 'check' as IconName },
    { key: 'skipped', label: t('history.skipped'), icon: 'close' as IconName },
    { key: 'upcoming', label: t('history.upcoming'), icon: 'clock-fast' as IconName },
  ], [t]);

  return (
    <SafeAreaView style={[styles.screen, { backgroundColor: theme.colors.background }]}>
      <View style={styles.headerContainer}>
        <Text style={[styles.title, { color: theme.colors.onSurface }]}>{t('history.screenTitle')}</Text>
        <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={styles.filterContainer}>
          {FILTERS.map(f => (
            <Chip key={f.key} selected={filter === f.key} onPress={() => setFilter(f.key)} icon={f.icon} style={[styles.chip, { backgroundColor: filter === f.key ? theme.colors.primaryContainer : theme.colors.surfaceVariant }]} textStyle={{ color: filter === f.key ? theme.colors.onPrimaryContainer : theme.colors.onSurfaceVariant }}>{f.label}</Chip>
          ))}
        </ScrollView>
      </View>
      <HistoryList filter={filter} />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  headerContainer: { paddingHorizontal: 16, paddingTop: 43 },
  title: { fontSize: 28, fontFamily: 'Cairo-Bold', textAlign: 'auto', marginBottom: 16 },
  filterContainer: { gap: 8, paddingBottom: 16 },
  chip: { borderRadius: 20 },
});
