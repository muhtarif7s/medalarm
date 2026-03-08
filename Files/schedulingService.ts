// الموقع: app/services/schedulingService.ts

import type { DoseHistory, Medicine, UpcomingDose } from '@/types/medicine';
import { addDays, differenceInDays, format, isAfter, isBefore, isFuture, set, startOfDay, subMinutes } from 'date-fns';

const normalizeArabicNumerals = (str: string): string => {
  if (!str) return '';
  return str.replace(/[٠-٩]/g, d => '٠١٢٣٤٥٦٧٨٩'.indexOf(d).toString());
};

export const processAndCategorizeDoses = (
  medicines: Medicine[],
  takenOrSkippedDoses: DoseHistory[]
): { upcoming: UpcomingDose[]; missed: UpcomingDose[] } => {
  const now = new Date();
  const processedDosesLookup = new Set<string>(
    takenOrSkippedDoses.map(dose => `${dose.medicine_id}-${dose.scheduled_time}`)
  );
  
  let allPotentialDoses: UpcomingDose[] = [];

  for (let dayOffset = -7; dayOffset < 14; dayOffset++) {
    const targetDay = addDays(startOfDay(new Date()), dayOffset);
    generateDosesForDay(medicines, targetDay, processedDosesLookup, allPotentialDoses);
  }

  const upcoming: UpcomingDose[] = [];
  const missed: UpcomingDose[] = [];
  
  const gracePeriodThreshold = subMinutes(now, 2);

  allPotentialDoses.forEach(dose => {
    const isUpcomingOrInGrace = isFuture(dose.scheduledTime) || !isBefore(dose.scheduledTime, gracePeriodThreshold);
    
    if (isUpcomingOrInGrace) {
      upcoming.push(dose);
    } else {
      missed.push(dose);
    }
  });

  const firstUpcomingDate = upcoming.length > 0 ? format(upcoming[0].scheduledTime, 'yyyy-MM-dd') : null;
  const filteredUpcoming = firstUpcomingDate 
    ? upcoming.filter(dose => format(dose.scheduledTime, 'yyyy-MM-dd') === firstUpcomingDate)
    : [];

  return {
    upcoming: filteredUpcoming.sort((a, b) => a.scheduledTime.getTime() - b.scheduledTime.getTime()),
    missed: missed.sort((a, b) => a.scheduledTime.getTime() - b.scheduledTime.getTime()),
  };
};

const generateDosesForDay = (
  medicines: Medicine[],
  targetDay: Date,
  processedDosesLookup: Set<string>,
  resultArray: UpcomingDose[]
) => {
  medicines.forEach(med => {
    // هذا الشرط الآن سيعمل بشكل صحيح لأن created_at أصبح موجودًا في النوع
    if (!med.dose_times || !med.start_date || !med.created_at) return;
    
    const startDate = startOfDay(new Date(med.start_date));
    if (isBefore(targetDay, startDate)) return;

    if (med.end_date) {
      const endDate = startOfDay(new Date(med.end_date));
      if (isBefore(endDate, targetDay)) return;
    }

    let isDoseDay = false;
    switch (med.frequency_type) {
      case 'daily': isDoseDay = true; break;
      case 'specific_days':
        const specificDays = JSON.parse(med.specific_days || '[]');
        const dayName = format(targetDay, 'EEE');
        if (specificDays.includes(dayName)) isDoseDay = true;
        break;
      case 'interval':
        const interval = med.interval_days || 1;
        const daysSinceStart = differenceInDays(targetDay, startDate);
        if (daysSinceStart >= 0 && daysSinceStart % interval === 0) isDoseDay = true;
        break;
    }

    if (isDoseDay) {
      const doseTimes: string[] = JSON.parse(med.dose_times);
      doseTimes.forEach(timeStr => {
        const normalizedTimeStr = normalizeArabicNumerals(timeStr);
        const match = normalizedTimeStr.match(/(\d+):(\d+)/);
        if (!match) return;

        const hours = parseInt(match[1], 10);
        const minutes = parseInt(match[2], 10);
        const isPM = normalizedTimeStr.includes('م') || normalizedTimeStr.toLowerCase().includes('pm');
        let finalHours = hours;
        if (isPM && hours < 12) finalHours += 12;
        else if (!isPM && hours === 12) finalHours = 0;

        const scheduledTime = set(targetDay, { hours: finalHours, minutes, seconds: 0, milliseconds: 0 });
        
        // هذا الشرط الآن سيعمل بشكل صحيح لأن created_at أصبح موجودًا في النوع
        if (isAfter(new Date(med.created_at), scheduledTime)) {
            return; 
        }
        
        const doseKey = `${med.id}-${scheduledTime.toISOString()}`;
        if (!processedDosesLookup.has(doseKey)) {
          resultArray.push({
            medicineId: med.id,
            medicineName: med.name,
            dosage: `${med.dosage_amount} ${med.dosage_unit}`,
            color: med.color || '#64B5F6',
            scheduledTime,
            doseValue: med.dosage_amount,
          });
        }
      });
    }
  });
};
