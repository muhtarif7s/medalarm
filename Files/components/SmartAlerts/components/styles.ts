import { I18nManager, StyleSheet } from 'react-native';
import type { MD3Theme } from 'react-native-paper';

export const getStyles = (theme: MD3Theme) => StyleSheet.create({
  container: {
    marginTop: 20,
    marginHorizontal: 16,
    marginBottom: 40,
  },
  title: {
    flex: 1,
    fontFamily: 'Cairo-Bold',
    fontSize: 18,
    color: theme.colors.onSurface,
    marginBottom: 16,
    textAlign: 'auto',
  },
  titleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  soonBox: {
    backgroundColor: '#ff8383ff',
    borderRadius: 12,
    paddingHorizontal: 8,
    paddingVertical: 2,
    marginLeft: 8,
  },
  soonText: {
    fontSize: 12,
    color: '#ffffffff',
  },
  alertItem: {
    flexDirection: I18nManager.isRTL ? 'row-reverse' : 'row', // يتغير حسب اتجاه اللغة
    alignItems: 'center',
    marginBottom: 16,
    gap: 12,
    flex: 1,
  },
  alertText: {
    fontFamily: 'Cairo-Regular',
    fontSize: 14,
    color: theme.colors.onSurfaceVariant,
    flex: 1,
    textAlign: 'auto',
  },
});