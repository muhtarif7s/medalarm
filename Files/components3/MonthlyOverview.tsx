// الموقع: components3/MonthlyOverview.tsx

import { useAppContext } from '@/context/AppContext';
import { useTranslation } from '@/context/TranslationContext';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { isAfter, parseISO, subDays } from 'date-fns';
import React, { useMemo } from 'react';
import { Pressable, StyleSheet, View } from 'react-native';
import { Card, Text } from 'react-native-paper';

const AnimatedStatCard = ({ icon, label, value, color, glowColor }: any) => {
  const glowStyle = {
    shadowColor: glowColor,
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.8,
    shadowRadius: 25,
    elevation: 20,
  };

  return (
    <Pressable>
      <View style={styles.cardContainer}>
        <Card style={[styles.statCard, glowStyle]}>
          <Card.Content style={styles.statCardContent}>
            <MaterialCommunityIcons name={icon} size={28} color={color} />
            <Text style={styles.statLabel}>{label}</Text>
            <Text style={styles.statValue}>{value}</Text>
          </Card.Content>
        </Card>
      </View>
    </Pressable>
  );
};

export default function MonthlyOverview() {
  const { t } = useTranslation();
  const { doseHistory, missedDoses } = useAppContext();

  const stats = useMemo(() => {
    const thirtyDaysAgo = subDays(new Date(), 30);

    const taken = doseHistory.filter(
      (d) =>
        d.status === 'taken' &&
        isAfter(parseISO(d.scheduled_time), thirtyDaysAgo),
    ).length;

    const skipped = missedDoses.filter((d) =>
      isAfter(d.scheduledTime, thirtyDaysAgo),
    ).length;

    const totalProcessed = taken + skipped;
    const adherence =
      totalProcessed > 0
        ? Math.round((taken / totalProcessed) * 100)
        : 0;

    return { adherence, taken, skipped };
  }, [doseHistory, missedDoses]);

  return (
    <View style={styles.statsGrid}>
      <AnimatedStatCard
        icon="check-circle-outline"
        label={t('statistics.adherenceRate')}
        value={`${stats.adherence}%`}
        color="#00ACC1"
        glowColor="#00ACC1"
      />
      <AnimatedStatCard
        icon="pill"
        label={t('statistics.dosesTaken')}
        value={stats.taken}
        color="#4CAF50"
        glowColor="#4CAF50"
      />
      <AnimatedStatCard
        icon="close-circle-outline"
        label={t('statistics.dosesSkipped')}
        value={stats.skipped}
        color="#EF5350"
        glowColor="#EF5350"
      />
    </View>
  );
}

const styles = StyleSheet.create({
  statsGrid: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: 10,
  },
  cardContainer: {
    flex: 1,
  },
  statCard: {
    borderRadius: 12,
    overflow: 'visible',
    marginStart: -3,
  },
  statCardContent: {
    alignItems: 'center',
    paddingVertical: 16,
    paddingHorizontal: 8,
    gap: 8,
  },
  statLabel: {
    fontSize: 13,
    textAlign: 'center',
  },
  statValue: {
    fontFamily: 'Cairo-Bold',
    fontSize: 22,
    letterSpacing: 0.5,
  },
});
