// الموقع: app/(tabs)/_layout.tsx (النسخة النهائية المتوافقة مع الثيم والترجمة)

import { useTranslation } from '@/context/TranslationContext'; // <-- 1. استيراد هوك الترجمة
import { Ionicons } from '@expo/vector-icons';
import { Tabs } from 'expo-router';
import React from 'react';
import { useTheme } from 'react-native-paper'; // <-- 2. استيراد هوك الثيم

export default function TabLayout() {
  const { colors } = useTheme(); // <-- 3. سحب الألوان من الثيم الحالي
  const { t } = useTranslation(); // <-- 4. سحب دالة الترجمة

  return (
    <Tabs
      screenOptions={{
        tabBarActiveTintColor: colors.primary, // <-- 5. استخدام ألوان الثيم
        tabBarInactiveTintColor: colors.onSurfaceVariant,
        headerShown: false,
        tabBarStyle: {
          backgroundColor: colors.surface, // خلفية الشريط من الثيم
          borderTopColor: colors.outline, // لون الخط الفاصل من الثيم
          borderTopWidth: 0.5,
        },
      }}
    >
      {/* التبويبات الآن تقرأ عناوينها من نظام الترجمة */}
      <Tabs.Screen
        name="index"
        options={{
          title: t('tabs.home'), // <-- 6. استخدام مفتاح الترجمة
          tabBarIcon: ({ color, size }) => (
            <Ionicons name="home" size={size} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="index1" // هذا هو تبويب "إضافة"
        options={{
          title: t('tabs.add'), // <-- 6. استخدام مفتاح الترجمة
          tabBarIcon: ({ color, size }) => (
            <Ionicons name="add-circle" size={size} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="statistics"
        options={{
          title: t('tabs.statistics'), // <-- 6. استخدام مفتاح الترجمة
          tabBarIcon: ({ color, size }) => (
            <Ionicons name="stats-chart" size={size} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="history"
        options={{
          title: t('tabs.history'), // <-- 6. استخدام مفتاح الترجمة
          tabBarIcon: ({ color, size }) => (
            <Ionicons name="time" size={size} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="settings"
        options={{
          title: t('tabs.settings'), // <-- 6. استخدام مفتاح الترجمة
          tabBarIcon: ({ color, size }) => (
            <Ionicons name="settings" size={size} color={color} />
          ),
        }}
      />
    </Tabs>
  );
}
