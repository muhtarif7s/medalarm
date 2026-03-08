// الملف: app/security/components/SecurityHeader.tsx

import { Ionicons } from '@expo/vector-icons';
import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { MD3Theme, useTheme } from 'react-native-paper';

const getStyles = (theme: MD3Theme) => StyleSheet.create({
  header: {
    alignItems: 'center',
    padding: 24,
    paddingTop: 60,
  },
  title: {
    fontFamily: 'Cairo-Bold',
    fontSize: 22,
    color: theme.colors.onSurface,
    marginTop: 16,
  },
  subtitle: {
    fontFamily: 'Cairo-Regular',
    fontSize: 15,
    color: theme.colors.onSurfaceVariant,
    textAlign: 'center',
    marginTop: 8,
  },
});

export default function SecurityHeader() {
  const theme = useTheme();
  const styles = getStyles(theme);

  return (
    <View style={styles.header}>
      <Ionicons name="shield-checkmark-outline" size={48} color={theme.colors.primary} />
      <Text style={styles.title}>الأمان والخصوصية</Text>
      <Text style={styles.subtitle}>
        نحن ملتزمون بحماية بياناتك الصحية وجعل تجربتك آمنة.
      </Text>
    </View>
  );
}
