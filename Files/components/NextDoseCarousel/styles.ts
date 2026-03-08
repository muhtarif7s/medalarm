// الموقع: components2/NextDoseCarousel/styles.ts
import { I18nManager, Platform, StyleSheet } from 'react-native';
import type { MD3Theme } from 'react-native-paper';

export const getStyles = (theme: MD3Theme) => StyleSheet.create({
  container: { 
    marginVertical: 20, 
    paddingHorizontal: 16 
  },

  header: { 
    flexDirection: I18nManager.isRTL ? 'row-reverse' : 'row', 
    alignItems: 'baseline', 
    marginBottom: 16, 
    paddingHorizontal: 8 
  },
  headerText: { 
    fontFamily: 'Cairo-Bold', 
    color: theme.colors.onSurfaceVariant, 
    fontSize: 18, 
    marginEnd: I18nManager.isRTL ? 10 : 0,
    marginStart: I18nManager.isRTL ? 0 : 10,
    textAlign: I18nManager.isRTL ? 'right' : 'left'
  },
  countdownText: { 
    fontFamily: 'Cairo-Bold', 
    color: theme.colors.primary, 
    fontSize: 18, 
    minWidth: 80, 
    textAlign: I18nManager.isRTL ? 'left' : 'right'
  },

  noDoseText: { 
    fontFamily: 'Cairo-Bold', 
    color: theme.colors.onSurface, 
    fontSize: 16, 
    textAlign: 'center', 
    padding: 30, 
    backgroundColor: theme.colors.surfaceVariant, 
    borderRadius: 16 
  },

  carousel: {
    // نستخدم inverted في المكون نفسه لدعم RTL
  },

  doseItemContainer: { 
    backgroundColor: theme.colors.surfaceVariant, 
    borderRadius: 20, 
    padding: 18, 
    marginHorizontal: 8, 
    ...Platform.select({ 
      android: { elevation: 4 }, 
      ios: { 
        shadowColor: '#000', 
        shadowOffset: { width: 0, height: 2 }, 
        shadowOpacity: 0.1, 
        shadowRadius: 4 
      } 
    }) 
  },

  medicineInfo: { 
    flexDirection: I18nManager.isRTL ? 'row-reverse' : 'row', 
    alignItems: 'center', 
    marginBottom: 12,
  },
  pillIconContainer: { 
    width: 50, 
    height: 50, 
    borderRadius: 12, 
    justifyContent: 'center', 
    alignItems: 'center',
  },
  medicineDetails: { 
    flex: 1, 
    marginEnd: I18nManager.isRTL ? 16 : 0,
    marginStart: I18nManager.isRTL ? 0 : 16
  },
  medicineName: { 
    fontFamily: 'Cairo-Bold', 
    fontSize: 22, 
    color: theme.colors.onSurface, 
    textAlign: I18nManager.isRTL ? 'right' : 'left'
  },
  doseInfo: { 
    fontFamily: 'Cairo-Regular', 
    fontSize: 16, 
    color: theme.colors.onSurfaceVariant, 
    marginTop: 4, 
    textAlign: I18nManager.isRTL ? 'right' : 'left'
  },

  mainButton: { 
    borderRadius: 15, 
    paddingVertical: 14, 
    alignItems: 'center', 
    justifyContent: 'center' 
  },
  buttonActive: { backgroundColor: theme.colors.primary },
  buttonInactive: { backgroundColor: theme.colors.surfaceDisabled },
  buttonText: { 
    fontFamily: 'Cairo-Bold', 
    fontSize: 16, 
    color: theme.colors.onPrimary 
  },
skipButton: { 
  position: 'absolute', 
  top: 8, // بدل -3 عشان ما يغطيش على الأيقونة
  [I18nManager.isRTL ? 'left' : 'right']: 8, // عكسنا الاتجاه عشان الزر يبقى بعيد عن أيقونة الحبة
  backgroundColor: 'rgba(69, 90, 100, 0.5)', 
  zIndex: 1 
},

  gracePeriodContainer: { 
    flexDirection: I18nManager.isRTL ? 'row-reverse' : 'row', 
    alignItems: 'center', 
    justifyContent: 'center', 
    backgroundColor: theme.colors.errorContainer, 
    borderRadius: 8, 
    paddingVertical: 6, 
    marginBottom: 12 
  },
  gracePeriodText: { 
    color: theme.colors.onErrorContainer, 
    fontFamily: 'Cairo-Bold', 
    fontSize: 14, 
    marginStart: I18nManager.isRTL ? 8 : 0,
    marginEnd: I18nManager.isRTL ? 0 : 8
  },
});