// الملف: app/security/components/SettingsSwitchItem.tsx

import React from 'react';
import { StyleSheet } from 'react-native';
import { List, MD3Theme, Switch, useTheme } from 'react-native-paper';

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
  description: string;
  value: boolean;
  onValueChange: (value: boolean) => void;
}

export default function SettingsSwitchItem({ title, description, value, onValueChange }: Props) {
  const theme = useTheme();
  const styles = getStyles(theme);

  return (
    <List.Item
      title={title}
      description={description}
      titleStyle={styles.listItemTitle}
      descriptionStyle={styles.listItemDescription}
      right={() => (
        <Switch
          value={value}
          onValueChange={onValueChange}
          color={theme.colors.primary}
        />
      )}
    />
  );
}
