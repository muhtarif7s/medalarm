// الموقع: app/(tabs)/settings/components/SettingsRow.tsx
import { MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import {
    I18nManager,
    StyleSheet,
    Switch,
    Text,
    TouchableOpacity,
    View,
} from 'react-native';
import { useTheme } from 'react-native-paper';

// (الواجهة لم تتغير)
interface SettingsRowProps {
  icon: keyof typeof MaterialCommunityIcons.glyphMap;
  title: string;
  subtitle?: string;
  hasSwitch?: boolean;
  isSwitchOn?: boolean;
  onSwitchChange?: (value: boolean) => void;
  onPress?: () => void;
  titleStyle?: object;
  subtitleStyle?: object;
}

export const SettingsRow: React.FC<SettingsRowProps> = ({
  icon, title, subtitle, hasSwitch, isSwitchOn, onSwitchChange, onPress, titleStyle, subtitleStyle,
}) => {
  const { colors } = useTheme();
  const styles = getStyles(colors); // <-- سنمرر الألوان مباشرة

  return (
    <TouchableOpacity onPress={onPress} disabled={!onPress || hasSwitch} style={styles.rowContainer}>
      <View style={styles.iconContainer}>
        <MaterialCommunityIcons name={icon} size={24} color={colors.onPrimary} />
      </View>
      <View style={styles.textContainer}>
        <Text style={[styles.title, titleStyle]}>{title}</Text>
        {subtitle && <Text style={[styles.subtitle, subtitleStyle]}>{subtitle}</Text>}
      </View>
      <View style={styles.actionContainer}>
        {hasSwitch ? (
          <Switch value={!!isSwitchOn} onValueChange={onSwitchChange} />
        ) : (
          <MaterialCommunityIcons name="chevron-left" size={28} color={colors.onSurfaceVariant} style={styles.chevronIcon} />
        )}
      </View>
    </TouchableOpacity>
  );
};

// لقد حولنا الأنماط إلى دالة بسيطة لتقبل الألوان
const getStyles = (colors: any) => StyleSheet.create({
    rowContainer: { flexDirection: 'row', alignItems: 'center', paddingVertical: 12, paddingHorizontal: 16, marginBottom: 2, backgroundColor: colors.surface },
    iconContainer: { padding: 8, borderRadius: 8, marginEnd: 16, backgroundColor: colors.primary },
    textContainer: { flex: 1 },
    title: { fontSize: 16, textAlign: 'auto', fontFamily: 'Cairo-Bold', color: colors.onSurface },
    subtitle: { fontSize: 13, textAlign: 'auto', marginTop: 2, fontFamily: 'Cairo-Bold', color: colors.onSurfaceVariant },
    actionContainer: { marginStart: 16 },
    chevronIcon: { transform: [{ scaleX: I18nManager.isRTL ? -1 : 1 }] },
});
