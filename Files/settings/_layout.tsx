// الموقع: app/settings/_layout.tsx
import { Stack } from 'expo-router';
import React from 'react';
import { useTheme } from 'react-native-paper';

export default function SettingsSubLayout() {
    const theme = useTheme();

    return (
        <Stack
            screenOptions={{
                headerStyle: {
                    backgroundColor: theme.colors.surface,
                },
                headerTintColor: theme.colors.onSurface,
                headerTitleStyle: {
                    fontFamily: 'Cairo-Bold',
                }
            }}
        >
            <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
            <Stack.Screen name="(tabs)/profile" options={{ title: 'الملف الشخصي', headerShown: false }} />
            <Stack.Screen name="(tabs)/reminders" options={{ title: 'التذكيرات', headerShown: false }} />
                        <Stack.Screen name="(tabs)/language" options={{ title: 'التذكيرات', headerShown: false }} />
            <Stack.Screen name="(tabs)/security" options={{ title: 'الأمان', headerShown: false }} />
            <Stack.Screen name="(tabs)/help" options={{ title: 'المساعدة', headerShown: false }} />
                        <Stack.Screen name="security/SecurityHeader" options={{ title: 'سياسة الخصوصية', headerShown: false }} />
            <Stack.Screen name="(tabs)/terms" options={{ title: 'الشروط والأحكام', headerShown: false }} />
        </Stack>
    );
}
