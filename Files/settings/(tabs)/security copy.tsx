import { Ionicons } from '@expo/vector-icons'; // أو أي مكتبة أيقونات أخرى
import React from 'react';
import { ScrollView, StyleSheet, Text, View } from 'react-native';
import { Divider, List, MD3Theme, Switch, useTheme } from 'react-native-paper';

const SecurityPrivacyScreen = () => {
  const theme = useTheme();
  const styles = getStyles(theme);
  const [isBiometricEnabled, setIsBiometricEnabled] = React.useState(false);

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Ionicons name="shield-checkmark-outline" size={48} color={theme.colors.primary} />
        <Text style={styles.title}>الأمان والخصوصية</Text>
        <Text style={styles.subtitle}>
          نحن ملتزمون بحماية بياناتك الصحية وجعل تجربتك آمنة.
        </Text>
      </View>

      <Divider style={styles.divider} />

      <List.Section>
        <List.Subheader style={styles.subheader}>أمان الحساب</List.Subheader>
        <List.Item
          title="القفل باستخدام بصمة الإصبع / الوجه"
          description="استخدم بصمتك أو وجهك لفتح التطبيق"
          titleStyle={styles.listItemTitle}
          descriptionStyle={styles.listItemDescription}
          right={() => (
            <Switch
              value={isBiometricEnabled}
              onValueChange={setIsBiometricEnabled}
              color={theme.colors.primary}
            />
          )}
        />
        <List.Item
          title="تغيير كلمة المرور"
          titleStyle={styles.listItemTitle}
          left={() => <List.Icon icon="chevron-left" />}
          onPress={() => console.log('Navigate to Change Password')}
        />
      </List.Section>

      <Divider style={styles.divider} />
      
      <List.Section>
        <List.Subheader style={styles.subheader}>البيانات والخصوصية</List.Subheader>
        <List.Item
          title="سياسة الخصوصية"
          titleStyle={styles.listItemTitle}
          left={() => <List.Icon icon="chevron-left" />}
          onPress={() => console.log('Navigate to Privacy Policy')}
        />
         <List.Item
          title="تصدير بيانات الأدوية"
          titleStyle={styles.listItemTitle}
          left={() => <List.Icon icon="chevron-left" />}
          onPress={() => console.log('Export Data')}
        />
      </List.Section>

      <Divider style={styles.divider} />

      <List.Section>
         <List.Subheader style={styles.subheader}>إدارة الحساب</List.Subheader>
         <List.Item
          title="حذف الحساب نهائياً"
          description="سيتم حذف جميع بياناتك بشكل دائم"
          titleStyle={[styles.listItemTitle, { color: theme.colors.error }]}
          descriptionStyle={styles.listItemDescription}
          left={() => <List.Icon color={theme.colors.error} icon="chevron-left" />}
          onPress={() => console.log('Show Delete Confirmation')}
        />
      </List.Section>

    </ScrollView>
  );
};


// --- أضف هذه الأنماط في ملفك ---
const getStyles = (theme: MD3Theme) => StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: theme.colors.background,
  },
  header: {
    alignItems: 'center',
    padding: 24,
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
  divider: {
    marginHorizontal: 16,
  },
  subheader: {
    fontFamily: 'Cairo-SemiBold',
    fontSize: 16,
    textAlign: 'right',
    color: theme.colors.primary,
  },
  listItemTitle: {
    fontFamily: 'Cairo-SemiBold',
    fontSize: 16,
    textAlign: 'right',
  },
  listItemDescription: {
    fontFamily: 'Cairo-Regular',
    fontSize: 13,
    textAlign: 'right',
  }
});

export default SecurityPrivacyScreen;
