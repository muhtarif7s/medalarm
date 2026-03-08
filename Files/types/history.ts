// الموقع: types/history.ts
import type { MaterialCommunityIcons } from '@expo/vector-icons';
type IconName = keyof typeof MaterialCommunityIcons.glyphMap;

export type HistoryStatus = 'TAKEN' | 'SKIPPED' | 'UPCOMING';

export interface HistoryEvent {
  id: string;
  type: HistoryStatus;
  medicine: string;
  dosage: string;
  time: Date;
  icon: IconName;
}
