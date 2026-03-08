// الملف: app/security/components/SettingsItem.tsx

import React from 'react';
import { StyleSheet } from 'react-native';
import { List, MD3Theme, useTheme } from 'react-native-paper';

const getStyles = (theme: MD3Theme) => StyleSheet.create({
  listItemTitle: {
    fontFamily: 'Cairo-SemiBold',
    fontSize: 16,
    textAlign: 'right',
  },
  listItemDescription: {
    fontFamily: 'Cairo-Regular',
    fontSize: 13,
    textAlign: 'right',
  },
});

interface Props {
  title: string;
  description?: string;
  onPress: () => void;
  isDanger?: boolean;
}

export default function SettingsItem({ title, description, onPress, isDanger = false }: Props) {
  const theme = useTheme();
  const styles = getStyles(theme);
  const color = isDanger ? theme.colors.error : theme.colors.onSurface;

  return (
    <List.Item
      title={title}
      description={description}
      titleStyle={[styles.listItemTitle, { color }]}
      descriptionStyle={styles.listItemDescription}
      onPress={onPress}
      left={() => <List.Icon color={isDanger ? theme.colors.error : theme.colors.onSurfaceVariant} icon="chevron-left" />}
    />
  );
}
