// الموقع: app/_layout.tsx

import MissedDosesManager from '@/components2/MissedDosesManager';
import { Colors } from '@/constants/Colors';
import { AppContextProvider, useAppContext } from '@/context/AppContext';
import { TranslationProvider } from '@/context/TranslationContext';
import { Ionicons } from '@expo/vector-icons';
import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native';
import { useFonts } from 'expo-font';
import * as LocalAuthentication from 'expo-local-authentication';
import { SplashScreen, Stack } from 'expo-router';
import * as SecureStore from 'expo-secure-store';
import { StatusBar } from 'expo-status-bar';
import React, { useEffect, useRef, useState } from 'react';
import { Animated, Easing, StyleSheet, Text, useColorScheme, View } from 'react-native';
import { Button, MD3DarkTheme, MD3LightTheme, PaperProvider, type MD3Theme } from 'react-native-paper';

import { initializeNotificationSystem } from '@/services/notifications';

SplashScreen.preventAutoHideAsync();
const SECURE_STORE_KEY = 'isBiometricEnabled';

// --- الثيمات ---
const customDarkTheme: MD3Theme = {
  ...MD3DarkTheme,
  colors: {
    ...MD3DarkTheme.colors,
    primary: Colors.dark.primary,
    background: Colors.dark.background,
    surface: Colors.dark.card,
    onSurface: Colors.dark.text,
    onSurfaceVariant: Colors.dark.gray,
    outline: Colors.dark.border,
    elevation: { ...MD3DarkTheme.colors.elevation, level2: Colors.dark.card },
  },
};

const customLightTheme: MD3Theme = {
  ...MD3LightTheme,
  colors: {
    ...MD3LightTheme.colors,
    primary: Colors.light.primary,
    background: Colors.light.background,
    surface: Colors.light.card,
    onSurface: Colors.light.text,
    onSurfaceVariant: Colors.light.gray,
    outline: Colors.light.border,
    elevation: { ...MD3LightTheme.colors.elevation, level2: Colors.light.card },
  },
};

// --- AppContent ---
function AppContent() {
  return (
    <View style={{ flex: 1 }}>
      <Stack>
        <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
        <Stack.Screen
          name="missed-doses"
          options={{ headerShown: false, presentation: 'modal' }}
        />
        <Stack.Screen name="index2" options={{ headerShown: false }} />
        <Stack.Screen name="settings" options={{ headerShown: false }} />
        <Stack.Screen
          name="medicines/components/edit/[id]"
          options={{ headerShown: false }}
        />
        <Stack.Screen
          name="medicines/index"
          options={{ presentation: 'modal' }}
        />
      </Stack>
      <MissedDosesManager />
    </View>
  );
}

// --- شاشة الترحيب (بدون Reanimated) ---
function AnimatedWelcomeSplash() {
  const theme =
    useColorScheme() === 'dark' ? customDarkTheme : customLightTheme;

  const fadeAnim = useRef(new Animated.Value(0)).current;
  const scaleAnim = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    Animated.timing(fadeAnim, {
      toValue: 1,
      duration: 800,
      useNativeDriver: true,
    }).start();

    Animated.loop(
      Animated.sequence([
        Animated.timing(scaleAnim, {
          toValue: 1.1,
          duration: 600,
          easing: Easing.inOut(Easing.ease),
          useNativeDriver: true,
        }),
        Animated.timing(scaleAnim, {
          toValue: 1,
          duration: 600,
          easing: Easing.inOut(Easing.ease),
          useNativeDriver: true,
        }),
      ]),
    ).start();
  }, []);

  return (
    <Animated.View
      style={[
        styles.welcomeSplashContainer,
        { backgroundColor: theme.colors.background, opacity: fadeAnim },
      ]}
    >
      <Animated.View style={{ transform: [{ scale: scaleAnim }] }}>
        <Ionicons name="pulse" size={80} color={theme.colors.primary} />
      </Animated.View>
      <Text
        style={[
          styles.welcomeSplashTitle,
          { color: theme.colors.onBackground },
        ]}
      >
        دوائي اليومي
      </Text>
      <Text
        style={[
          styles.welcomeSplashSubtitle,
          { color: theme.colors.onSurfaceVariant },
        ]}
      >
        نهتم بصحتك أولاً
      </Text>
    </Animated.View>
  );
}

// --- مدير القفل ---
function AppLocker({ children }: { children: React.ReactNode }) {
  const { startupLoading } = useAppContext();
  const [fontsLoaded] = useFonts({
    'Cairo-Regular': require('../assets/fonts/Cairo-Regular.ttf'),
    'Cairo-Bold': require('../assets/fonts/Cairo-Bold.ttf'),
    'Cairo-SemiBold': require('../assets/fonts/Cairo-SemiBold.ttf'),
  });
  const [isUnlocked, setIsUnlocked] = useState(false);
  const [authLoading, setAuthLoading] = useState(true);
  const theme =
    useColorScheme() === 'dark' ? customDarkTheme : customLightTheme;

  const tryAuthentication = async () => {
    try {
      const isBiometricEnabled = await SecureStore.getItemAsync(
        SECURE_STORE_KEY,
      );
      if (isBiometricEnabled === 'true') {
        const result = await LocalAuthentication.authenticateAsync({
          promptMessage: 'قم بالمصادقة لفتح التطبيق',
          cancelLabel: 'الخروج',
          disableDeviceFallback: true,
        });
        if (result.success) {
          setIsUnlocked(true);
        }
      } else {
        setIsUnlocked(true);
      }
    } catch (error) {
      console.error('❌ Authentication error:', error);
      setIsUnlocked(true);
    } finally {
      setAuthLoading(false);
    }
  };

  useEffect(() => {
    if (fontsLoaded) {
      tryAuthentication();
    }
  }, [fontsLoaded]);

  useEffect(() => {
    if (!authLoading) {
      SplashScreen.hideAsync();
    }
  }, [authLoading]);

  if (authLoading || !fontsLoaded || startupLoading) {
    return <AnimatedWelcomeSplash />;
  }

  if (!isUnlocked) {
    return (
      <View
        style={[
          styles.lockedContainer,
          { backgroundColor: theme.colors.background },
        ]}
      >
        <Ionicons
          name="lock-closed"
          size={48}
          color={theme.colors.primary}
        />
        <Text
          style={[
            styles.lockedTitle,
            { color: theme.colors.onSurface },
          ]}
        >
          التطبيق مقفل
        </Text>
        <Text
          style={[
            styles.lockedSubtitle,
            { color: theme.colors.onSurfaceVariant },
          ]}
        >
          الرجاء المصادقة للمتابعة.
        </Text>
        <Button
          mode="contained"
          onPress={tryAuthentication}
          style={styles.retryButton}
          labelStyle={styles.retryButtonLabel}
          icon="fingerprint"
        >
          استخدام البصمة
        </Button>
      </View>
    );
  }

  return <>{children}</>;
}

// --- التخطيط الرئيسي ---
export default function RootLayout() {
  const colorScheme = useColorScheme();
  const paperTheme =
    colorScheme === 'dark' ? customDarkTheme : customLightTheme;
  const navigationTheme = {
    ...(colorScheme === 'dark' ? DarkTheme : DefaultTheme),
    colors: {
      ...(colorScheme === 'dark'
        ? DarkTheme.colors
        : DefaultTheme.colors),
      ...paperTheme.colors,
    },
  };

  useEffect(() => {
    const setupNotificationSystem = async () => {
      try {
        console.log('🚀 Setting up notification system...');
        const result = await initializeNotificationSystem();
        if (result.success && result.permissionsGranted) {
          console.log('✅ Notification system fully operational');
        } else if (result.success && !result.permissionsGranted) {
          console.warn('⚠️ Permissions denied');
        } else {
          console.error('❌ Failed to initialize notification system');
        }
      } catch (error) {
        console.error('❌ Critical error during notification setup:', error);
      }
    };

    const timeoutId = setTimeout(() => {
      setupNotificationSystem();
    }, 2000);

    return () => clearTimeout(timeoutId);
  }, []);

  return (
    <AppContextProvider>
      <TranslationProvider>
        <PaperProvider theme={paperTheme}>
          <ThemeProvider value={navigationTheme}>
            <AppLocker>
              <AppContent />
            </AppLocker>
          </ThemeProvider>
          <StatusBar
            style={colorScheme === 'dark' ? 'light' : 'dark'}
          />
        </PaperProvider>
      </TranslationProvider>
    </AppContextProvider>
  );
}

const styles = StyleSheet.create({
  welcomeSplashContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  welcomeSplashTitle: {
    fontFamily: 'Cairo-Bold',
    fontSize: 32,
    marginTop: 20,
    textAlign: 'center',
  },
  welcomeSplashSubtitle: {
    fontFamily: 'Cairo-Regular',
    fontSize: 16,
    marginTop: 8,
    textAlign: 'center',
  },
  lockedContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  lockedTitle: {
    fontFamily: 'Cairo-Bold',
    fontSize: 22,
    marginTop: 16,
    textAlign: 'center',
  },
  lockedSubtitle: {
    fontFamily: 'Cairo-Regular',
    fontSize: 15,
    marginTop: 8,
    textAlign: 'center',
    lineHeight: 22,
  },
  retryButton: {
    marginTop: 24,
    borderRadius: 12,
    paddingHorizontal: 16,
  },
  retryButtonLabel: {
    fontFamily: 'Cairo-SemiBold',
    fontSize: 16,
  },
});
