// Consolidated notification system helpers
// This module provides a small, well-defined entry point used by the
// background task glue (`backgroundTasks.ts`) to trigger the scheduler.

import { scheduleNext24HoursNotifications } from './scheduler';

/**
 * Schedule optimized notifications.
 *
 * This is intentionally a thin wrapper around the canonical scheduler so
 * background tasks have a single, stable import to call.
 */
export async function scheduleOptimizedNotifications(): Promise<void> {
    try {
        await scheduleNext24HoursNotifications();
    } catch (error) {
        console.error('❌ scheduleOptimizedNotifications failed:', error);
        throw error;
    }
}

export default {
    scheduleOptimizedNotifications,
};