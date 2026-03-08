// الموقع: components4/HistoryItem.tsx

import { useTranslation } from '@/context/TranslationContext';
import type { HistoryEvent } from '@/types/history';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { format } from 'date-fns';
import { ar } from 'date-fns/locale';
import React from 'react';
import { StyleSheet, View } from 'react-native';
import { Avatar, Card, Text, useTheme } from 'react-native-paper';

// --- تعريف نوع أسماء الأيقونات بشكل صريح ---
type IconName = keyof typeof MaterialCommunityIcons.glyphMap;

export const HistoryItem = React.memo(({ item }: { item: HistoryEvent }) => {
  const theme = useTheme();
  const { t, language } = useTranslation();

  const STATUS_CONFIG: Record<string, { color: string; icon: IconName; label: string }> = {
    TAKEN: { color: theme.colors.primary, icon: 'check-circle', label: t('history.takenAt') },
    SKIPPED: { color: theme.colors.error, icon: 'close-circle', label: t('history.skippedAt') },
    UPCOMING: { color: theme.colors.onSurfaceVariant, icon: 'clock-outline', label: t('history.dueAt') },
  };

  const config = STATUS_CONFIG[item.type];
  const time = format(item.time, 'p', { locale: language === 'ar' ? ar : undefined });

  // --- ✅ الإصلاح الجذري والنهائي هنا ---
  // نقوم بتحويل النص القادم إلى نوع الأيقونة الصريح الذي يتوقعه المكون
  const medicineIcon = (item.icon as IconName) || 'pill';

  return (
    <View style={styles.itemContainer}>
      <View style={styles.timeline}>
        <View style={[styles.timelineDot, { backgroundColor: config.color }]} />
        <View style={[styles.timelineLine, { backgroundColor: theme.colors.outlineVariant }]} />
      </View>
      <Card style={[styles.itemCard, { backgroundColor: theme.colors.surface }]}>
        <Card.Title
          title={item.medicine}
          subtitle={item.dosage}
          titleStyle={styles.itemTitle}
          subtitleStyle={styles.itemSubtitle}
          left={(props) => <Avatar.Icon {...props} icon={medicineIcon} style={{ backgroundColor: theme.colors.surfaceVariant }} />}
          right={(props) => (
            <View {...props} style={styles.timeContainer}>
              <MaterialCommunityIcons name={config.icon} color={config.color} size={16} />
              <Text style={[styles.timeText, { color: config.color }]}>{`${config.label} ${time}`}</Text>
            </View>
          )}
        />
      </Card>
    </View>
  );
});

const styles = StyleSheet.create({
  itemContainer: { flexDirection: 'row', gap: 8 },
  timeline: { alignItems: 'center' },
  timelineDot: { width: 14, height: 14, borderRadius: 7 },
  timelineLine: { flex: 1, width: 2 },
  itemCard: { flex: 1, marginBottom: 16, borderRadius: 12 },
  itemTitle: { fontFamily: 'Cairo-Bold', fontSize: 16 },
  itemSubtitle: { fontFamily: 'Cairo-Regular', fontSize: 13, marginTop: -4 },
  timeContainer: { flexDirection: 'row', alignItems: 'center', paddingEnd: 16, gap: 4 },
  timeText: { fontFamily: 'Cairo-Regular', fontSize: 12 },
});
