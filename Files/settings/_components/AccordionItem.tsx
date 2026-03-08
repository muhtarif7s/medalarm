// الموقع: app/settings/components/AccordionItem.tsx

import { MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { LayoutAnimation, Platform, StyleSheet, Text, TouchableOpacity, UIManager, View } from 'react-native';
import { useTheme } from 'react-native-paper';

// تفعيل LayoutAnimation على أندرويد
if (Platform.OS === 'android' && UIManager.setLayoutAnimationEnabledExperimental) {
  UIManager.setLayoutAnimationEnabledExperimental(true);
}

interface AccordionItemProps {
  title: string;
  children: React.ReactNode;
}

export const AccordionItem: React.FC<AccordionItemProps> = ({ title, children }) => {
  const theme = useTheme();
  const styles = createStyles(theme);
  const [isOpen, setIsOpen] = React.useState(false);

  const toggleAccordion = () => {
    LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
    setIsOpen(!isOpen);
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity style={styles.header} onPress={toggleAccordion}>
        <Text style={styles.title}>{title}</Text>
        <View style={{ transform: [{ rotate: isOpen ? '180deg' : '0deg' }] }}>
          <MaterialCommunityIcons
            name="chevron-down"
            size={28}
            color={theme.colors.primary}
          />
        </View>
      </TouchableOpacity>
      {isOpen && (
        <View style={styles.content}>
          <Text style={styles.contentText}>{children}</Text>
        </View>
      )}
    </View>
  );
};

const createStyles = (theme: any) =>
  StyleSheet.create({
    container: {
      backgroundColor: theme.colors.surface,
      borderRadius: 12,
      marginBottom: 12,
      overflow: 'hidden',
    },
    header: {
      paddingHorizontal: 16,
      paddingVertical: 18,
      flexDirection: 'row-reverse',
      justifyContent: 'space-between',
      alignItems: 'center',
    },
    title: {
      fontFamily: 'Cairo-Bold',
      fontSize: 16,
      color: theme.colors.onSurface,
    },
    content: {
      paddingHorizontal: 16,
      paddingBottom: 16,
    },
    contentText: {
      fontFamily: 'Cairo-Regular',
      fontSize: 15,
      lineHeight: 22,
      color: theme.colors.onSurfaceVariant,
      textAlign: 'auto',
    },
  });
