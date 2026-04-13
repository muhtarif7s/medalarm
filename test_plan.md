Here is the test plan:

**1. General**
   - **T1.1:** Build and run the app.
   - **T1.2:** Open all screens to check for rendering issues.
   - **T1.3:** Rotate the device to test landscape and portrait modes.
   - **T1.4:** Test light and dark themes.

**2. Navigation**
   - **T2.1:** Tap "Add Medication" to go to the "Add/Edit Medication" screen.
   - **T2.2:** On the "Add/Edit Medication" screen, tap the back arrow to return to the home screen.
   - **T2.3:** Tap a medication to go to its details page.
   - **T2.4:** On the medication details page, tap the back arrow to return to the home screen.
   - **T2.5:** Tap "History" to go to the "History" screen.
   - **T2.6:** On the "History" screen, tap the back arrow to return to the home screen.
   - **T2.7:** Tap "Settings" to go to the "Settings" screen.
   - **T2.8:** On the "Settings" screen, tap the back arrow to return to the home screen.

**3. Home Screen**
   - **T3.1:** Verify that the "No medications yet" message is displayed if the database is empty.
   - **T3.2:** Add a new medication and check that it appears on the home screen.
   - **T3.3:** Delete a medication and check that it is no longer on the home screen.

**4. Add/Edit Medication**
   - **T4.1:** Add a new medication and fill out all fields.
   - **T4.2:** Save the new medication and verify that it is correctly stored in the database.
   - **T4.3:** Edit an existing medication and verify that the changes are correctly stored in the database.
   - **T4.4:** Delete a medication and check that it is no longer in the database.

**5. Dose Tracking**
   - **T5.1:** Mark a dose as "taken" and verify that its status is correctly updated.
   - **T5.2:** Mark a dose as "skipped" and verify that its status is correctly updated.
   - **T5.3:** Check that the dose history is correctly displayed.

**6. Settings**
   - **T6.1:** Change the app language to Arabic and check that the text is correctly translated.
   - **T6.2:** Change the app language back to English and check that the text is correctly translated.
   - **T6.3:** Change the theme to dark and verify that all screens are correctly displayed.
   - **T6.4:** Change the theme back to light and verify that all screens are correctly displayed.
   - **T6.5:** Click the "Privacy Policy" link and check that it opens the correct URL.

**7. Notifications**
   - **T7.1:** Set up a medication with a notification.
   - **T7.2:** Verify that a notification is triggered at the correct time.