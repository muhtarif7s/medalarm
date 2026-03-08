// الموقع: app/settings/help.tsx

import { MaterialCommunityIcons } from '@expo/vector-icons';
// --- ✅ 1. استيراد الأدوات الجديدة والمهمة ---
import * as Linking from 'expo-linking';
import React from 'react';
import { Alert, ScrollView, StyleSheet, TouchableOpacity, View } from 'react-native';
import { Surface, Text, useTheme } from 'react-native-paper';
import { AccordionItem } from '../_components/AccordionItem';

export default function HelpScreen() {
  const theme = useTheme();
  const styles = createStyles(theme);
  const supportEmail = 'support@doctordaily.app';

  // --- ✅ 2. الدالة الجديدة التي تفتح تطبيق البريد الإلكتروني ---
  const handleEmailPress = () => {
    // نستخدم 'mailto:' لإنشاء رابط بريد إلكتروني
    const url = `mailto:${supportEmail}`;
    
    Linking.canOpenURL(url)
      .then(supported => {
        if (supported) {
          return Linking.openURL(url);
        } else {
          Alert.alert('خطأ', 'لا يمكن فتح تطبيق البريد الإلكتروني. يرجى التأكد من وجود تطبيق بريد إلكتروني مثبت على جهازك.');
        }
      })
      .catch(err => console.error('An error occurred', err));
  };

  return (
    <ScrollView style={styles.screen} contentContainerStyle={styles.container}>
      <Text style={styles.mainTitle}>مركز المساعدة والدعم</Text>
      <Text style={styles.subtitle}>نجيب هنا على بعض الأسئلة الشائعة ونوفر لك طرق التواصل معنا.</Text>

      {/* ... (قسم الأسئلة الشائعة لا يتغير) ... */}
      <View style={styles.section}>
          <AccordionItem title="كيف أضيف دواءً جديدًا؟">
              من الشاشة الرئيسية، اضغط على زر الإضافة (+) في شريط التبويبات السفلي، ثم املأ جميع تفاصيل الدواء المطلوبة واضغط على "حفظ".
          </AccordionItem>
          <AccordionItem title="هل بياناتي آمنة؟">
              نعم، بكل تأكيد. يتم تخزين جميع بياناتك الشخصية وبيانات الأدوية محليًا على جهازك فقط ولا يتم مشاركتها مع أي جهة خارجية.
          </AccordionItem>
      </View>

      <Surface style={styles.contactSection} elevation={2}>
        <MaterialCommunityIcons name="email-fast-outline" size={40} color={theme.colors.primary} />
        <Text style={styles.contactTitle}>هل تحتاج إلى مساعدة إضافية؟</Text>
        <Text style={styles.contactSubtitle}>فريق الدعم لدينا جاهز لمساعدتك. تواصل معنا عبر البريد الإلكتروني:</Text>
        
        {/* --- ✅ 3. ربط الدالة الجديدة بزر البريد الإلكتروني --- */}
        <TouchableOpacity onPress={handleEmailPress}>
          <Text style={styles.emailText}>{supportEmail}</Text>
        </TouchableOpacity>
      </Surface>
    </ScrollView>
  );
}

// (الأنماط لا تحتاج إلى أي تعديل)
const createStyles = (theme: any) => StyleSheet.create({
  screen: { flex: 1, backgroundColor: theme.colors.background },
  container: { padding: 20, paddingTop: 50 },
  mainTitle: { fontFamily: 'Cairo-Bold', fontSize: 23, color: theme.colors.onBackground, marginBottom: 8, textAlign: 'auto' },
  subtitle: { fontFamily: 'Cairo-Regular', fontSize: 16, color: theme.colors.onSurfaceVariant, marginBottom: 24, textAlign: 'auto' },
  section: { marginBottom: 24 },
  contactSection: { borderRadius: 16, padding: 24, alignItems: 'center', backgroundColor: theme.colors.surface },
  contactTitle: { fontFamily: 'Cairo-Bold', fontSize: 18, marginTop: 16, color: theme.colors.onSurface },
  contactSubtitle: { fontFamily: 'Cairo-Regular', fontSize: 14, color: theme.colors.onSurfaceVariant, textAlign: 'center', marginTop: 8 },
  emailText: { fontFamily: 'Cairo-Bold', fontSize: 16, color: theme.colors.primary, marginTop: 12, textDecorationLine: 'underline' },
});
