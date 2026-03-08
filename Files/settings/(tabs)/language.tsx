// الموقع: app/settings/LanguageScreen.tsx
// هذا هو التصميم الاحترافي والجديد بالكامل

import { useTranslation } from '@/context/TranslationContext';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { Image, SafeAreaView, ScrollView, StyleSheet, View } from 'react-native';
import { Card, Text, useTheme } from 'react-native-paper';
import LanguageSelector from '../../settings/_components/LanguageSelector'; // تأكد من صحة المسار

import type { TextStyle } from 'react-native'; // For typing

export default function LanguageScreen() {
  const { colors } = useTheme();
  const { t, language } = useTranslation();

  // Explicitly type styles as TextStyle
  const dynamicTitleStyle: TextStyle = { fontFamily: language === 'ar' ? 'Cairo-Bold' : 'System', fontWeight: 'bold' };
  const dynamicParagraphStyle: TextStyle = { fontFamily: language === 'ar' ? 'Cairo-Regular' : 'System' };

  return (
    <SafeAreaView style={[styles.screen, { backgroundColor: colors.background }]}>
      <ScrollView contentContainerStyle={styles.container}>
        <View style={styles.headerContainer}>
          <Image 
            source={require('../../../assets/images/language_illustration.png')}
            style={styles.illustration}
          />
          <Text variant="headlineLarge" style={[styles.header, { color: colors.primary }, dynamicTitleStyle]}>
            {t('settings.languageHeader')}
          </Text>
          <Text variant="bodyMedium" style={[styles.subtitle, { color: colors.onSurfaceVariant }, dynamicParagraphStyle]}>
            {t('settings.languageSubtitle')} 
          </Text>
        </View>

        <Card style={[styles.card, { backgroundColor: colors.surface }]}>
          <Card.Content>
            <View style={styles.cardHeader}>
              <MaterialCommunityIcons name="translate" size={24} color={colors.primary} />
              <Text variant="titleMedium" style={[styles.cardTitle, dynamicParagraphStyle]}>
                {t('settings.selectLanguage')}
              </Text>
            </View>
            <LanguageSelector />
          </Card.Content>
        </Card>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  screen: {
    flex: 1,
  },
  container: {
    padding: 24,
    paddingTop: 90,
    alignItems: 'center',
  },
  headerContainer: {
    alignItems: 'center',
    marginBottom: 32,
  },
  illustration: {
    width: 50,
    height: 50,
    marginBottom: 24,
  },
  header: {
    fontSize: 28,
    textAlign: 'center',
  },
  subtitle: {
    fontSize: 16,
    textAlign: 'center',
    marginTop: 8,
    paddingHorizontal: 20,
  },
  card: {
    borderRadius: 16,
    width: '100%',
    elevation: 2,
  },
  cardHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
    paddingHorizontal: 8,
    gap: 12,
  },
  cardTitle: {
    fontSize: 18,
    flex: 1,
  }
});
