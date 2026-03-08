// الملف: app/security/components/SettingsSection.tsx

import React from 'react';
import { StyleSheet } from 'react-native';
import { List, MD3Theme, useTheme } from 'react-native-paper';

const getStyles = (theme: MD3Theme) => StyleSheet.create({
  subheader: {
    fontFamily: 'Cairo-SemiBold',
    fontSize: 16,
    textAlign: 'right',
    color: theme.colors.primary,
  },
});

interface Props {
  title: string;
  children: React.ReactNode;
}

export default function SettingsSection({ title, children }: Props) {
  const theme = useTheme();
  const styles = getStyles(theme);

  return (
    <List.Section>
      <List.Subheader style={styles.subheader}>{title}</List.Subheader>
      {children}
    </List.Section>
  );
}
