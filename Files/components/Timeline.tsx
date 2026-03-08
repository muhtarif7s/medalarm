// الموقع: app/(tabs)/home/components/Timeline.tsx

import { useAppContext } from '@/context/AppContext';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { format, isToday } from 'date-fns';
import { ar } from 'date-fns/locale';
import React, { useMemo } from 'react';
import { FlatList, StyleSheet, Text, View } from 'react-native';
import { MD3Theme, useTheme } from 'react-native-paper';

interface TimelineItemType {
  time: string;
  name: string;
  status: 'taken' | 'missed' | 'active' | 'upcoming';
  color: string;
}

const getStyles = (theme: MD3Theme) =>
  StyleSheet.create({
    wrapper: { marginTop: 30, marginHorizontal: 16 },
    mainTitle: {
      fontFamily: 'Cairo-Bold',
      fontSize: 18,
      color: theme.colors.onSurface,
      marginBottom: 12,
      textAlign: 'auto',
    },
    container: {
      backgroundColor: theme.colors.surfaceVariant,
      borderRadius: 16,
      paddingVertical: 20,
    },
    itemContainer: { alignItems: 'center', width: 90 },
    timeText: {
      fontFamily: 'Cairo-Regular',
      color: theme.colors.onSurfaceVariant,
      fontSize: 12,
      marginBottom: 4,
    },
    line: {
      height: 2,
      width: '100%',
      backgroundColor: theme.colors.outline,
      marginVertical: 3,
      justifyContent: 'center',
      alignItems: 'center',
    },
    iconWrapper: {
      position: 'absolute',
      backgroundColor: theme.colors.surfaceVariant,
      paddingHorizontal: 1,
    },
    dot: {
      height: 10,
      width: 12,
      marginTop: -4,
      borderRadius: 20,
      position: 'absolute',
    },
    nameText: {
      fontFamily: 'Cairo-Bold',
      color: theme.colors.onSurface,
      fontSize: 12,
      textAlign: 'center',
      marginTop: 4,
    },
  });

function TimelineItem({
  item,
  theme,
  styles,
}: {
  item: TimelineItemType;
  theme: MD3Theme;
  styles: ReturnType<typeof getStyles>;
}) {
  const statusColors = {
    taken: theme.colors.primary,
    missed: theme.colors.error,
    active: theme.colors.secondary,
    upcoming: theme.colors.outline,
  };
  const currentStatusColor = statusColors[item.status];

  return (
    <View style={styles.itemContainer}>
      <Text style={styles.timeText}>{item.time}</Text>
      <View
        style={[
          styles.line,
          { backgroundColor: currentStatusColor + '55' },
        ]}
      >
        <View style={styles.iconWrapper}>
          {item.status === 'taken' && (
            <MaterialCommunityIcons
              name="check-circle"
              size={18}
              color={currentStatusColor}
            />
          )}
          {item.status === 'missed' && (
            <MaterialCommunityIcons
              name="alert-circle"
              size={18}
              color={currentStatusColor}
            />
          )}
          {(item.status === 'upcoming' || item.status === 'active') && (
            <View
              style={[
                styles.dot,
                { backgroundColor: currentStatusColor },
              ]}
            />
          )}
        </View>
      </View>
      <Text style={styles.nameText}>{item.name}</Text>
    </View>
  );
}

export default function Timeline() {
  const theme = useTheme();
  const styles = getStyles(theme);
  const { upcomingDoses, missedDoses, doseHistory } = useAppContext();

  const timelineData = useMemo(() => {
    const allTodayDoses = [
      ...upcomingDoses.filter((d) => isToday(d.scheduledTime)),
      ...missedDoses.filter((d) => isToday(d.scheduledTime)),
    ];

    const takenTodayLookup = new Set(
      doseHistory
        .filter(
          (d) =>
            d.status === 'taken' &&
            isToday(new Date(d.scheduled_time)),
        )
        .map((d) =>
          new Date(d.scheduled_time).toISOString(),
        ),
    );

    const activeDoseTime =
      upcomingDoses[0]?.scheduledTime.toISOString();

    const processedDoses = allTodayDoses.map((dose) => {
      const scheduledISO = dose.scheduledTime.toISOString();
      let status: TimelineItemType['status'] = 'upcoming';

      if (takenTodayLookup.has(scheduledISO)) {
        status = 'taken';
      } else if (
        missedDoses.some(
          (d) =>
            d.scheduledTime.toISOString() === scheduledISO,
        )
      ) {
        status = 'missed';
      } else if (activeDoseTime === scheduledISO) {
        status = 'active';
      }

      return {
        time: format(dose.scheduledTime, 'h:mm a', {
          locale: ar,
        }),
        name: dose.medicineName,
        status,
        color: dose.color,
      };
    });

    const uniqueDoses = Array.from(
      new Map(
        processedDoses.map((d) => [d.time + d.name, d]),
      ).values(),
    );

    return uniqueDoses.sort((a, b) =>
      a.time.localeCompare(b.time, 'ar-EG-u-nu-latn'),
    );
  }, [upcomingDoses, missedDoses, doseHistory]);

  if (timelineData.length === 0) return null;

  return (
    <View style={styles.wrapper}>
      <Text style={styles.mainTitle}>الجدول الزمني اليومي</Text>
      <View style={styles.container}>
        <FlatList
          horizontal
          data={timelineData}
          keyExtractor={(item) => item.time + item.name}
          renderItem={({ item }) => (
            <TimelineItem
              item={item}
              theme={theme}
              styles={styles}
            />
          )}
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={{ paddingHorizontal: 10 }}
        />
      </View>
    </View>
  );
}