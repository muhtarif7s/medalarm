// الموقع: app/(tabs)/settings.tsx
import { router } from 'expo-router';
import React from 'react';
import {
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
} from 'react-native';
import { useTheme } from 'react-native-paper';
import { SettingsRow } from '../settings/_components/SettingsRow'; // <-- استيراد المكون الجديد

export default function SettingsScreen() {
  const { colors } = useTheme();
  const [isNotificationsOn, setIsNotificationsOn] = React.useState(true);

  return (
    <SafeAreaView style={[styles.screen, { backgroundColor: colors.background }]}>
      <ScrollView>
        {/* --- ✅ القسم الأول: الملف الشخصي (مرتبط الآن بشاشات) --- */}
        <Text style={[styles.header, { color: colors.onSurface }]}>الملف الشخصي</Text>
        <SettingsRow icon="account-circle-outline" title="تعديل الملف الشخصي" onPress={() => router.push('/settings/profile')} />
        <SettingsRow icon="shield-check-outline" title="الأمان" onPress={() => router.push('/settings/security')} />
        {/* --- ✅ 3. تمت إضافة صف اللغة هنا كما طلبت --- */}
        <SettingsRow 
          icon="translate" 
          title="اللغة" // يمكنك تغييرها إلى t('settings.language')
          onPress={() => router.push('/settings/language')}
        />
        {/* --- ✅ القسم الثاني: الإشعارات (مرتبط الآن بشاشات) --- */}
        <Text style={[styles.header, { color: colors.onSurface }]}>الإشعارات</Text>
        <SettingsRow icon="bell-outline" title="إشعارات الجرعات" hasSwitch isSwitchOn={isNotificationsOn} onSwitchChange={setIsNotificationsOn} />
        <SettingsRow icon="calendar-clock" title="التذكيرات" onPress={() => router.push('/settings/reminders')} />

        {/* --- ✅ القسم الثالث: عن التطبيق (مرتبط الآن بشاشات) --- */}
        <Text style={[styles.header, { color: colors.onSurface }]}>عن التطبيق</Text>
        <SettingsRow icon="help-circle-outline" title="المساعدة" onPress={() => router.push('/settings/help')} />
        <SettingsRow icon="information-outline" title="الشروط والأحكام" subtitle="الإصدار 1.0.0" onPress={() => router.push('/settings/terms')} />
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1 },
  header: {
    fontSize: 27,
    textAlign: 'auto',
    marginHorizontal: 16,
    paddingTop: 48,
    marginBottom: 8,
    fontFamily: 'Cairo-Bold',
  },
});
