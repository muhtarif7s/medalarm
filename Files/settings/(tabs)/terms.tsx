// الموقع: app/settings/terms.tsx

import { MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { ScrollView, StyleSheet, View } from 'react-native';
import { Surface, Text, useTheme, type MD3Theme } from 'react-native-paper';

// مكون داخلي لتنظيم المحتوى
const Section = ({ title, children, icon }: { title: string; children: React.ReactNode; icon: keyof typeof MaterialCommunityIcons.glyphMap }) => {
  const theme = useTheme();
  const styles = createStyles(theme);
  return (
    <Surface style={styles.sectionContainer} elevation={1}>
      <View style={styles.sectionHeader}>
        <MaterialCommunityIcons name={icon} size={24} color={theme.colors.primary} />
        <Text style={styles.sectionTitle}>{title}</Text>
      </View>
      <Text style={styles.paragraph}>{children}</Text>
    </Surface>
  );
};

export default function TermsScreen() {
  const theme = useTheme();
  const styles = createStyles(theme);

  return (
    <ScrollView style={styles.screen} contentContainerStyle={styles.container}>
      <Text style={styles.mainTitle}>الشروط والأحكام</Text>
      <Text style={styles.updateDate}>آخر تحديث: 12 أغسطس 2025</Text>

      <Section title="مقدمة" icon="information-outline">
        مرحبًا بك في "دوائي اليومي". هذه الشروط تحكم استخدامك لتطبيقنا. باستخدامك للتطبيق، فإنك توافق على هذه الشروط بالكامل. إذا كنت لا توافق على أي جزء من هذه الشروط، يجب عليك عدم استخدام التطبيق.
      </Section>

      <Section title="إخلاء مسؤولية طبية (هام جدًا)" icon="alert-decagram-outline">
        تطبيق "دوائي اليومي" هو أداة مساعدة لتنظيم وتذكيرك بمواعيد الأدوية فقط. المعلومات والتذكيرات المقدمة لا تمثل استشارة طبية ولا تغني عن استشارة الطبيب أو الصيدلي. أنت المسؤول الوحيد عن التأكد من صحة الجرعات، المواعيد، والأدوية التي تدخلها. يجب عليك دائمًا اتباع توجيهات طبيبك المعالج.
      </Section>

      <Section title="استخدام التطبيق" icon="cellphone-check">
        أنت توافق على استخدام التطبيق لأغراضه المقصودة فقط. أنت مسؤول عن دقة وصحة البيانات التي تدخلها، بما في ذلك أسماء الأدوية، الجرعات، والمواعيد. المطورون غير مسؤولين عن أي ضرر ناتج عن إدخال بيانات غير صحيحة أو سوء استخدام التطبيق.
      </Section>

      <Section title="خصوصية البيانات" icon="lock-outline">
        نحن نحترم خصوصيتك. كل بياناتك الشخصية وبيانات الأدوية يتم تخزينها محليًا على جهازك فقط ولا يتم مشاركتها مع أي خوادم خارجية أو أطراف ثالثة. لمزيد من التفاصيل، يرجى مراجعة "سياسة الخصوصية" الخاصة بنا.
      </Section>

      <Section title="حقوق الملكية الفكرية" icon="copyright">
        التطبيق وكل المحتويات والتصاميم والبرمجيات المرتبطة به هي ملك للمطورين. لا يجوز لك نسخ أو تعديل أو توزيع أو بيع أي جزء من التطبيق دون إذن كتابي مسبق.
      </Section>

      <Section title="تحديد المسؤولية" icon="shield-alert-outline">
        إلى أقصى حد يسمح به القانون، لن يكون المطورون مسؤولين عن أي أضرار مباشرة أو غير مباشرة (بما في ذلك فقدان البيانات أو المشاكل الصحية) تنتج عن استخدام أو عدم القدرة على استخدام هذا التطبيق.
      </Section>

      <Section title="التعديلات على الشروط" icon="update">
        نحتفظ بالحق في تعديل هذه الشروط في أي وقت. سيتم إشعارك بأي تغييرات جوهرية. استمرارك في استخدام التطبيق بعد هذه التعديلات يعتبر موافقة منك على الشروط الجديدة.
      </Section>
    </ScrollView>
  );
}

// الأنماط تتبع "النظام الذهبي" بالكامل
const createStyles = (theme: MD3Theme) => StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: theme.colors.background,
  },
  container: {
    padding: 16,
    paddingBottom: 40,
    paddingTop: 50,
  },
  mainTitle: {
    fontFamily: 'Cairo-Bold',
    fontSize: 28,
    color: theme.colors.onBackground,
    marginBottom: 8,
    textAlign: 'auto',
  },
  updateDate: {
    fontFamily: 'Cairo-Regular',
    fontSize: 14,
    color: theme.colors.onSurfaceVariant,
    marginBottom: 24,
    textAlign: 'auto',
  },
  sectionContainer: {
    borderRadius: 12,
    padding: 16,
    marginBottom: 16,
    backgroundColor: theme.colors.surface,
  },
  sectionHeader: {
    flexDirection: 'row-reverse',
    alignItems: 'center',
    gap: 12,
    marginBottom: 12,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.outlineVariant,
    paddingBottom: 8,
  },
  sectionTitle: {
    fontFamily: 'Cairo-Bold',
    fontSize: 18,
    color: theme.colors.primary,
    flex: 1,
    textAlign: 'auto',
  },
  paragraph: {
    fontFamily: 'Cairo-Regular',
    fontSize: 15,
    lineHeight: 24,
    color: theme.colors.onSurface,
    textAlign: 'auto',
  },
});
