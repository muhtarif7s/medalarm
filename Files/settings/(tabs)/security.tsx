// الملف: app/settings/security/index.tsx

import { useRouter } from 'expo-router';
import React from 'react';
import { Alert, ScrollView, StyleSheet } from 'react-native';
import { Divider, MD3Theme, useTheme } from 'react-native-paper';

// استيراد المكتبات الجديدة
import * as LocalAuthentication from 'expo-local-authentication';
import * as SecureStore from 'expo-secure-store';

// استيراد المكونات من المجلد الصحيح
import SecurityHeader from '../security/SecurityHeader';
import SettingsItem from '../security/SettingsItem';
import SettingsSection from '../security/SettingsSection';
import SettingsSwitchItem from '../security/SettingsSwitchItem';

const SECURE_STORE_KEY = 'isBiometricEnabled';

const getStyles = (theme: MD3Theme) => StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: theme.colors.background,
  },
  divider: {
    marginHorizontal: 16,
  },
});

export default function SecurityPrivacyScreen() {
  const theme = useTheme();
  const styles = getStyles(theme);
  const router = useRouter();
  const [isBiometricEnabled, setIsBiometricEnabled] = React.useState(false);

  // عند تحميل الشاشة، نقوم بقراءة الإعداد المحفوظ
  React.useEffect(() => {
    const loadSetting = async () => {
      const savedState = await SecureStore.getItemAsync(SECURE_STORE_KEY);
      setIsBiometricEnabled(savedState === 'true');
    };
    loadSetting();
  }, []);

  // دالة تفعيل/إلغاء قفل البصمة
  const handleBiometricToggle = async () => {
    const isSupported = await LocalAuthentication.hasHardwareAsync();
    if (!isSupported) {
      Alert.alert('غير مدعوم', 'جهازك لا يدعم قفل البصمة أو الوجه.');
      return;
    }

    const isEnrolled = await LocalAuthentication.isEnrolledAsync();
    if (!isEnrolled) {
      Alert.alert('غير مسجل', 'الرجاء تسجيل بصمة إصبع أو وجه في إعدادات جهازك أولاً.');
      return;
    }

    if (isBiometricEnabled) {
      await SecureStore.deleteItemAsync(SECURE_STORE_KEY);
      setIsBiometricEnabled(false);
      Alert.alert('تم الإلغاء', 'تم إلغاء قفل التطبيق باستخدام البصمة.');
    } else {
      const result = await LocalAuthentication.authenticateAsync({
        promptMessage: 'قم بالمصادقة لتفعيل القفل',
        cancelLabel: 'إلغاء',
      });

      if (result.success) {
        await SecureStore.setItemAsync(SECURE_STORE_KEY, 'true');
        setIsBiometricEnabled(true);
        Alert.alert('تم التفعيل', 'تم تفعيل قفل التطبيق بنجاح!');
      } else {
        Alert.alert('فشل', 'فشلت عملية المصادقة. الرجاء المحاولة مرة أخرى.');
      }
    }
  };

  // دالة لعرض رسالة تأكيد قبل الحذف
  const showDeleteConfirmation = () => {
    Alert.alert(
      'تأكيد حذف الحساب',
      'هل أنت متأكد أنك تريد حذف حسابك؟ سيتم حذف جميع بياناتك الصحية بشكل دائم ولا يمكن التراجع عن هذا الإجراء.',
      [
        { text: 'إلغاء', style: 'cancel' },
        { text: 'نعم، أحذف الحساب', style: 'destructive', onPress: () => handleDeleteAccount() },
      ]
    );
  };

  // دالة لحذف الحساب فعلياً (ستضيف منطق الحذف هنا لاحقاً)
  const handleDeleteAccount = () => {
    console.log('Account deleted!');
    // هنا تضع كود حذف الحساب من قاعدة البيانات ثم توجه المستخدم للخارج
    // router.replace('/login');
  };

  // دالة لتصدير البيانات (لا تتطلب تنقل)
  const handleExportData = () => {
    Alert.alert('تصدير البيانات', 'جاري تجهيز بياناتك للتصدير...');
    // هنا تضع منطق تصدير البيانات كملف
  };

  return (
    <ScrollView style={styles.container}>
      <SecurityHeader />
      <Divider style={styles.divider} />
      <SettingsSection title="أمان الحساب">
        <SettingsSwitchItem
          title="القفل باستخدام بصمة الإصبع / الوجه"
          description="استخدم بصمتك أو وجهك لفتح التطبيق"
          value={isBiometricEnabled}
          onValueChange={handleBiometricToggle}
        />
      </SettingsSection>
      <Divider style={styles.divider} />
      <SettingsSection title="البيانات والخصوصية">
        <SettingsItem
          title="سياسة الخصوصية"
          onPress={() => router.push('/settings/security/SecurityHeader')}
        />
        <SettingsItem
          title="تصدير بيانات الأدوية"
          onPress={handleExportData}
        />
      </SettingsSection>
      <Divider style={styles.divider} />
      <SettingsSection title="إدارة الحساب">
        <SettingsItem
          title="حذف الحساب نهائياً"
          description="سيتم حذف جميع بياناتك بشكل دائم"
          onPress={showDeleteConfirmation}
          isDanger={true}
        />
      </SettingsSection>
    </ScrollView>
  );
}
