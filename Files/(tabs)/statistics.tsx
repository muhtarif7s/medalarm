// الموقع: app/(tabs)/statistics.tsx

import MonthlyOverview from '@/components3/MonthlyOverview';
import MostSkipped from '@/components3/MostSkipped'; // <-- استيراد المكونات الجديدة
import { useTranslation } from '@/context/TranslationContext';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { SafeAreaView, ScrollView, StyleSheet } from 'react-native';
import { Card, Text, useTheme } from 'react-native-paper';

// (مكون الالتزام الأسبوعي لم نقم بإنشائه بعد لأنه يحتاج منطقًا معقدًا، سنضيفه لاحقًا)

export default function StatisticsScreen() {
  const theme = useTheme();
  const { t } = useTranslation();

  return (
    <SafeAreaView style={[styles.screen, { backgroundColor: theme.colors.background }]}>
      <ScrollView contentContainerStyle={styles.container}>
        <Text style={[styles.title, { color: theme.colors.onSurface, fontFamily: 'Cairo-Bold' }]}>
          {t('statistics.screenTitle')}
        </Text>

        {/* --- القسم الأول: نظرة عامة (مكون حي) --- */}
        <Card style={[styles.sectionCard, { backgroundColor: theme.colors.surface }]}>
          <Card.Title
            title={t('statistics.monthlyOverview')}
            titleStyle={[styles.sectionTitle, { fontFamily: 'Cairo-Bold', color: theme.colors.primary }]}
            left={(props) => <MaterialCommunityIcons {...props} name="chart-donut" color={theme.colors.primary} />}
          />
          <Card.Content>
            <MonthlyOverview />
          </Card.Content>
        </Card>

        {/* --- القسم الثاني: الالتزام الأسبوعي (مؤقتًا) --- */}
        <Card style={[styles.sectionCard, { backgroundColor: theme.colors.surface }]}>
          <Card.Title
            title={t('statistics.weeklyAdherence')}
            titleStyle={[styles.sectionTitle, { fontFamily: 'Cairo-Bold' }]}
            left={(props) => <MaterialCommunityIcons {...props} name="calendar-week" color={theme.colors.primary} />}
          />
          <Card.Content>
            <Text style={{ textAlign: 'center', fontFamily: 'Cairo-Bold',  padding: 20 }}>سيتم تفعيل هذا القسم قريبًا!</Text>
          </Card.Content>
        </Card>

        {/* --- القسم الثالث: الأكثر تفويتاً (مكون حي) --- */}
        <Card style={[styles.sectionCard, { backgroundColor: theme.colors.surface }]}>
          <Card.Title
            title={t('statistics.mostSkipped')}
            titleStyle={[styles.sectionTitle, { fontFamily: 'Cairo-Bold' }]}
            left={(props) => (
              <MaterialCommunityIcons
                {...props}
                name="alert-circle-outline"
                color="#FF3B30"
              />
            )} />
          <Card.Content>
            <MostSkipped />
          </Card.Content>
        </Card>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  container: { padding: 16, paddingBottom: 40, gap: 3, marginTop: 29 },
  title: { fontSize: 22, marginBottom: 20, },
  sectionCard: { marginBottom: 20, borderRadius: 16 },
  sectionTitle: { fontSize: 20 },
});
